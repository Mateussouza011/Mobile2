import 'package:dartz/dartz.dart';
import '../../domain/entities/team_stats.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/data/repositories/prediction_history_repository.dart';
import '../../../multi_tenant/data/repositories/company_repository.dart';

/// Repositório para estatísticas da equipe
class TeamStatsRepository {
  final PredictionHistoryRepository _predictionRepository;
  final CompanyRepository _companyRepository;

  TeamStatsRepository({
    required PredictionHistoryRepository predictionRepository,
    required CompanyRepository companyRepository,
  })  : _predictionRepository = predictionRepository,
        _companyRepository = companyRepository;

  /// Busca estatísticas gerais da equipe
  Future<Either<Failure, TeamStats>> getTeamStats(String companyId) async {
    try {
      // Buscar todas as previsões da empresa
      final predictions = await _predictionRepository.getPredictionsForUser(
        0,
        companyId: companyId,
      );

      // Buscar membros da empresa
      final membersResult = await _companyRepository.getCompanyMembers(companyId);

      return membersResult.fold(
        (failure) => Left(failure),
        (members) {
          final now = DateTime.now();
          final monthStart = DateTime(now.year, now.month, 1);

          // Calcular estatísticas
          final totalPredictions = predictions.length;
          final predictionsThisMonth = predictions
              .where((p) => p.createdAt.isAfter(monthStart))
              .length;

          // Membros ativos = membros com pelo menos 1 previsão nos últimos 30 dias
          final thirtyDaysAgo = now.subtract(const Duration(days: 30));
          final recentPredictions = predictions
              .where((p) => p.createdAt.isAfter(thirtyDaysAgo))
              .toList();

          final activeMemberIds = recentPredictions
              .map((p) => p.userId)
              .toSet()
              .length;

          final avgPredictions = members.isNotEmpty
              ? totalPredictions / members.length
              : 0.0;

          return Right(
            TeamStats(
              totalPredictions: totalPredictions,
              predictionsThisMonth: predictionsThisMonth,
              activeMembers: activeMemberIds,
              totalMembers: members.length,
              avgPredictionsPerMember: avgPredictions,
              period: now,
            ),
          );
        },
      );
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar estatísticas: $e'));
    }
  }

  /// Busca atividade dos membros
  Future<Either<Failure, List<MemberActivity>>> getMemberActivities(
    String companyId,
    {int days = 30}
  ) async {
    try {
      // Buscar todas as previsões da empresa
      final predictions = await _predictionRepository.getPredictionsForUser(
        0,
        companyId: companyId,
      );

      // Buscar membros da empresa
      final membersResult = await _companyRepository.getCompanyMembers(companyId);

      return membersResult.fold(
        (failure) => Left(failure),
        (members) {
          final now = DateTime.now();
          final startDate = now.subtract(Duration(days: days));

          // Agrupar previsões por usuário
          final activitiesByUser = <String, List<DateTime>>{};
          
          for (final prediction in predictions) {
            if (prediction.createdAt.isAfter(startDate)) {
              final userId = prediction.userId.toString();
              activitiesByUser.putIfAbsent(userId, () => []);
              activitiesByUser[userId]!.add(prediction.createdAt);
            }
          }

          // Criar atividades por membro
          final memberActivities = members.map((member) {
            final userId = member.userId.toString();
            final userPredictions = activitiesByUser[userId] ?? [];
            
            // Agrupar por dia
            final dailyMap = <String, int>{};
            for (final date in userPredictions) {
              final dayKey = '${date.year}-${date.month}-${date.day}';
              dailyMap[dayKey] = (dailyMap[dayKey] ?? 0) + 1;
            }

            final dailyActivities = dailyMap.entries.map((entry) {
              final parts = entry.key.split('-');
              return DailyActivity(
                date: DateTime(
                  int.parse(parts[0]),
                  int.parse(parts[1]),
                  int.parse(parts[2]),
                ),
                count: entry.value,
              );
            }).toList()
              ..sort((a, b) => a.date.compareTo(b.date));

            return MemberActivity(
              userId: userId,
              userName: 'User $userId', // TODO: Buscar nome real do usuário
              predictionsCount: userPredictions.length,
              lastActivity: userPredictions.isNotEmpty
                  ? userPredictions.reduce((a, b) => a.isAfter(b) ? a : b)
                  : null,
              dailyActivities: dailyActivities,
            );
          }).toList()
            ..sort((a, b) => b.predictionsCount.compareTo(a.predictionsCount));

          return Right(memberActivities);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar atividades: $e'));
    }
  }

  /// Busca uso de recursos
  Future<Either<Failure, ResourceUsage>> getResourceUsage(
    String companyId,
  ) async {
    try {
      // Buscar empresa para obter limites
      final companyResult = await _companyRepository.getCompanyById(companyId);

      return companyResult.fold(
        (failure) => Left(failure),
        (company) async {
          // Buscar previsões do mês atual
          final predictions = await _predictionRepository.getPredictionsForUser(
            0,
            companyId: companyId,
          );

          final now = DateTime.now();
          final monthStart = DateTime(now.year, now.month, 1);
          final predictionsThisMonth = predictions
              .where((p) => p.createdAt.isAfter(monthStart))
              .length;

          // Buscar membros
          final membersResult = await _companyRepository.getCompanyMembers(companyId);
          final membersCount = membersResult.fold(
            (failure) => 0,
            (members) => members.length,
          );

          // Definir limites baseado no plano (mockado)
          final limits = _getLimitsByTier('pro'); // TODO: Usar tier real da empresa

          return Right(
            ResourceUsage(
              predictionsUsed: predictionsThisMonth,
              predictionsLimit: limits['predictions']!,
              membersUsed: membersCount,
              membersLimit: limits['members']!,
              storageUsedMB: predictions.length * 1, // ~1KB por previsão
              storageLimitMB: limits['storage']!,
            ),
          );
        },
      );
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar uso de recursos: $e'));
    }
  }

  Map<String, int> _getLimitsByTier(String tier) {
    switch (tier.toLowerCase()) {
      case 'free':
        return {
          'predictions': 10,
          'members': 1,
          'storage': 100,
        };
      case 'pro':
        return {
          'predictions': 100,
          'members': 5,
          'storage': 1000,
        };
      case 'enterprise':
        return {
          'predictions': 999999,
          'members': 999999,
          'storage': 10000,
        };
      default:
        return {
          'predictions': 10,
          'members': 1,
          'storage': 100,
        };
    }
  }
}
