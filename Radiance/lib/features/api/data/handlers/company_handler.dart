import 'package:dartz/dartz.dart';
import '../../domain/entities/api_response.dart';
import '../../../api_keys/domain/entities/api_key.dart';
import '../../../multi_tenant/data/repositories/company_repository.dart';
import '../../../../core/error/failures.dart';

/// Handler para endpoints de empresa
class CompanyHandler {
  final CompanyRepository _companyRepository;

  CompanyHandler({required CompanyRepository companyRepository})
      : _companyRepository = companyRepository;

  /// GET /api/v1/company
  /// Retorna informações da empresa
  Future<Either<Failure, ApiResponse<Map<String, dynamic>>>> getCompanyInfo({
    required ApiKey apiKey,
  }) async {
    try {
      // Verificar permissão
      if (!apiKey.permissions.contains('read:company')) {
        return const Left(UnauthorizedFailure('Missing permission: read:company'));
      }

      // Buscar empresa
      final result = await _companyRepository.getCompanyById(apiKey.companyId);

      return result.fold(
        (failure) => Left(failure),
        (company) {
          return Right(
            ApiResponse.success(
              data: {
                'id': company.id,
                'name': company.name,
                'subscription_tier': 'enterprise', // TODO: Add to Company model
                'subscription_status': 'active', // TODO: Add to Company model
                'created_at': company.createdAt.toIso8601String(),
              },
            ),
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure('Error fetching company info: $e'));
    }
  }

  /// GET /api/v1/company/usage
  /// Retorna métricas de uso da empresa
  Future<Either<Failure, ApiResponse<Map<String, dynamic>>>> getCompanyUsage({
    required ApiKey apiKey,
  }) async {
    try {
      // Verificar permissão
      if (!apiKey.permissions.contains('read:analytics')) {
        return const Left(UnauthorizedFailure('Missing permission: read:analytics'));
      }

      // Buscar métricas de uso (temporário: retornar dados mockados)
      // TODO: Implementar getUsageStats no CompanyRepository
      final stats = {
        'predictions_this_month': 0,
        'predictions_total': 0,
        'members_count': 0,
        'api_calls_this_month': 0,
      };

      return Right(
        ApiResponse.success(
          data: stats,
        ),
      );

      /* final result = await _companyRepository.getUsageStats(apiKey.companyId);

      */
    } catch (e) {
      return Left(ServerFailure('Error fetching usage stats: $e'));
    }
  }

  /// GET /api/v1/company/members
  /// Lista membros da empresa
  Future<Either<Failure, ApiResponse<List<Map<String, dynamic>>>>> getCompanyMembers({
    required ApiKey apiKey,
  }) async {
    try {
      // Verificar permissão
      if (!apiKey.permissions.contains('read:users')) {
        return const Left(UnauthorizedFailure('Missing permission: read:users'));
      }

      // Buscar membros
      final result = await _companyRepository.getCompanyMembers(apiKey.companyId);

      return result.fold(
        (failure) => Left(failure),
        (members) {
          final data = members.map((member) {
            return {
              'id': member.id,
              'user_id': member.userId,
              'role': 'member', // TODO: Add role to CompanyUser model
              'joined_at': member.joinedAt.toIso8601String(),
            };
          }).toList();

          return Right(ApiResponse.success(data: data));
        },
      );
    } catch (e) {
      return Left(ServerFailure('Error fetching members: $e'));
    }
  }
}
