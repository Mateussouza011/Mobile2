import 'package:dartz/dartz.dart';
import '../../domain/entities/admin_company_stats.dart';
import '../../../../core/error/failures.dart';
import '../../../../data/datasources/local/database_helper.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';
import '../../../multi_tenant/domain/entities/company.dart';

/// Repositório para administração de empresas
class AdminCompanyRepository {
  final DatabaseHelper _databaseHelper;

  AdminCompanyRepository({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  /// Lista todas as empresas com estatísticas
  Future<Either<Failure, List<AdminCompanyStats>>> getAllCompanies({
    CompanyFilters? filters,
  }) async {
    try {
      final db = await _databaseHelper.database;

      // Query base
      String query = '''
        SELECT 
          c.*,
          COUNT(DISTINCT cu.user_id) as total_members,
          COUNT(DISTINCT CASE 
            WHEN ph.created_at > datetime('now', '-30 days') 
            THEN cu.user_id 
          END) as active_members,
          COUNT(ph.id) as total_predictions,
          COUNT(CASE 
            WHEN ph.created_at > datetime('now', 'start of month') 
            THEN 1 
          END) as predictions_this_month,
          MAX(ph.created_at) as last_activity
        FROM companies c
        LEFT JOIN company_users cu ON c.id = cu.company_id
        LEFT JOIN prediction_history ph ON c.id = ph.company_id
      ''';

      List<String> whereClauses = [];
      List<dynamic> whereArgs = [];

      // Aplicar filtros
      if (filters != null) {
        if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
          whereClauses.add('(c.name LIKE ? OR c.email LIKE ?)');
          final searchPattern = '%${filters.searchQuery}%';
          whereArgs.add(searchPattern);
          whereArgs.add(searchPattern);
        }

        if (filters.isActive != null) {
          whereClauses.add('c.is_active = ?');
          whereArgs.add(filters.isActive! ? 1 : 0);
        }

        if (filters.createdAfter != null) {
          whereClauses.add('c.created_at >= ?');
          whereArgs.add(filters.createdAfter!.toIso8601String());
        }

        if (filters.createdBefore != null) {
          whereClauses.add('c.created_at <= ?');
          whereArgs.add(filters.createdBefore!.toIso8601String());
        }
      }

      if (whereClauses.isNotEmpty) {
        query += ' WHERE ${whereClauses.join(' AND ')}';
      }

      query += ' GROUP BY c.id';

      // Ordenação
      final sortBy = filters?.sortBy ?? CompanySortBy.createdAt;
      final ascending = filters?.ascending ?? false;
      final order = ascending ? 'ASC' : 'DESC';

      switch (sortBy) {
        case CompanySortBy.name:
          query += ' ORDER BY c.name $order';
          break;
        case CompanySortBy.createdAt:
          query += ' ORDER BY c.created_at $order';
          break;
        case CompanySortBy.totalMembers:
          query += ' ORDER BY total_members $order';
          break;
        case CompanySortBy.totalPredictions:
          query += ' ORDER BY total_predictions $order';
          break;
        case CompanySortBy.revenue:
          query += ' ORDER BY c.created_at $order'; // TODO: Add revenue calculation
          break;
      }

      final results = await db.rawQuery(query, whereArgs);

      // Buscar assinaturas separadamente
      final companiesWithStats = <AdminCompanyStats>[];
      
      for (final row in results) {
        final company = _mapToCompany(row);
        
        // Buscar assinatura
        final subscriptionResults = await db.query(
          'subscriptions',
          where: 'company_id = ?',
          whereArgs: [company.id],
          orderBy: 'created_at DESC',
          limit: 1,
        );

        Subscription? subscription;
        if (subscriptionResults.isNotEmpty) {
          subscription = _mapToSubscription(subscriptionResults.first);
        }

        // Calcular receita total (mockado)
        final totalRevenue = _calculateRevenue(subscription);

        // Filtrar por tier e status se necessário
        if (filters != null) {
          if (filters.tier != null && 
              (subscription == null || subscription.tier != filters.tier)) {
            continue;
          }
          
          if (filters.status != null && 
              (subscription == null || subscription.status != filters.status)) {
            continue;
          }
        }

        companiesWithStats.add(
          AdminCompanyStats(
            company: company,
            subscription: subscription,
            totalMembers: row['total_members'] as int? ?? 0,
            activeMembers: row['active_members'] as int? ?? 0,
            totalPredictions: row['total_predictions'] as int? ?? 0,
            predictionsThisMonth: row['predictions_this_month'] as int? ?? 0,
            lastActivity: row['last_activity'] != null
                ? DateTime.parse(row['last_activity'] as String)
                : null,
            totalRevenue: totalRevenue,
            createdAt: DateTime.parse(row['created_at'] as String),
          ),
        );
      }

      return Right(companiesWithStats);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar empresas: $e'));
    }
  }

  /// Busca detalhes de uma empresa específica
  Future<Either<Failure, AdminCompanyStats>> getCompanyDetails(
    String companyId,
  ) async {
    try {
      final result = await getAllCompanies(
        filters: CompanyFilters(searchQuery: companyId),
      );

      return result.fold(
        (failure) => Left(failure),
        (companies) {
          final company = companies.firstWhere(
            (c) => c.company.id == companyId,
            orElse: () => throw Exception('Empresa não encontrada'),
          );
          return Right(company);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar empresa: $e'));
    }
  }

  /// Suspende uma empresa
  Future<Either<Failure, void>> suspendCompany(String companyId) async {
    try {
      final db = await _databaseHelper.database;

      await db.update(
        'companies',
        {'is_active': 0, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [companyId],
      );

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao suspender empresa: $e'));
    }
  }

  /// Ativa uma empresa
  Future<Either<Failure, void>> activateCompany(String companyId) async {
    try {
      final db = await _databaseHelper.database;

      await db.update(
        'companies',
        {'is_active': 1, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [companyId],
      );

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao ativar empresa: $e'));
    }
  }

  /// Exclui uma empresa (soft delete)
  Future<Either<Failure, void>> deleteCompany(String companyId) async {
    try {
      final db = await _databaseHelper.database;

      // Soft delete - marca como inativa
      await db.update(
        'companies',
        {
          'is_active': 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [companyId],
      );

      // Nota: Em produção, considere implementar hard delete
      // removendo também: company_users, subscriptions, prediction_history, etc.

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao excluir empresa: $e'));
    }
  }

  /// Busca estatísticas gerais do sistema
  Future<Either<Failure, Map<String, dynamic>>> getSystemStats() async {
    try {
      final db = await _databaseHelper.database;

      final stats = <String, dynamic>{};

      // Total de empresas
      final companiesResult = await db.rawQuery(
        'SELECT COUNT(*) as total, SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active FROM companies',
      );
      stats['total_companies'] = companiesResult.first['total'] as int? ?? 0;
      stats['active_companies'] = companiesResult.first['active'] as int? ?? 0;

      // Total de usuários
      final usersResult = await db.rawQuery(
        'SELECT COUNT(DISTINCT user_id) as total FROM company_users',
      );
      stats['total_users'] = usersResult.first['total'] as int? ?? 0;

      // Total de previsões
      final predictionsResult = await db.rawQuery(
        'SELECT COUNT(*) as total FROM prediction_history',
      );
      stats['total_predictions'] = predictionsResult.first['total'] as int? ?? 0;

      // Previsões este mês
      final predictionsMonthResult = await db.rawQuery(
        "SELECT COUNT(*) as total FROM prediction_history WHERE created_at > datetime('now', 'start of month')",
      );
      stats['predictions_this_month'] =
          predictionsMonthResult.first['total'] as int? ?? 0;

      // Distribuição por tier
      final tiersResult = await db.rawQuery(
        'SELECT tier, COUNT(*) as count FROM subscriptions GROUP BY tier',
      );
      stats['tier_distribution'] = {
        for (final row in tiersResult)
          row['tier'] as String: row['count'] as int,
      };

      return Right(stats);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar estatísticas: $e'));
    }
  }

  // Helpers
  Company _mapToCompany(Map<String, dynamic> map) {
    return Company(
      id: map['id'] as String,
      name: map['name'] as String,
      slug: map['slug'] as String? ?? map['name'].toString().toLowerCase().replaceAll(' ', '-'),
      ownerId: map['owner_id'] as String? ?? '1',
      isActive: (map['is_active'] as int? ?? 1) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : DateTime.parse(map['created_at'] as String),
    );
  }

  Subscription _mapToSubscription(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'] as String,
      companyId: map['company_id'] as String,
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.name == (map['tier'] as String).toLowerCase(),
        orElse: () => SubscriptionTier.free,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == (map['status'] as String).toLowerCase(),
        orElse: () => SubscriptionStatus.active,
      ),
      amount: ((map['amount'] as int? ?? 0)).toDouble(),
      billingInterval: BillingInterval.values.firstWhere(
        (e) => e.name == (map['billing_interval'] as String? ?? 'monthly'),
        orElse: () => BillingInterval.monthly,
      ),
      startDate: DateTime.parse(map['start_date'] as String),
      currentPeriodStart: DateTime.parse(map['current_period_start'] as String),
      currentPeriodEnd: DateTime.parse(map['current_period_end'] as String),
      trialEndsAt: map['trial_ends_at'] != null
          ? DateTime.parse(map['trial_ends_at'] as String)
          : null,
      cancelledAt: map['canceled_at'] != null
          ? DateTime.parse(map['canceled_at'] as String)
          : null,
      nextBillingDate: map['next_billing_date'] != null
          ? DateTime.parse(map['next_billing_date'] as String)
          : null,
      limits: SubscriptionLimits.free, // TODO: Parse from JSON
      abacatePaySubscriptionId: map['abacate_pay_subscription_id'] as String?,
      abacatePayCustomerId: map['abacate_pay_customer_id'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : DateTime.parse(map['created_at'] as String),
    );
  }

  double _calculateRevenue(Subscription? subscription) {
    if (subscription == null) return 0.0;
    
    // Calcular receita baseado no período ativo
    final now = DateTime.now();
    final monthsSinceStart = now.difference(subscription.startDate).inDays / 30;
    
    final monthlyAmount = subscription.billingInterval == BillingInterval.yearly
        ? subscription.amount / 12
        : subscription.amount.toDouble();
    
    return monthlyAmount * monthsSinceStart;
  }
}
