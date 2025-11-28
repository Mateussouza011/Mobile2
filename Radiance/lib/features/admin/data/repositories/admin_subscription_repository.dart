import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../data/datasources/local/database_helper.dart';
import '../../../../core/error/failures.dart';
import '../../../multi_tenant/domain/entities/company.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';
import '../../domain/entities/admin_subscription_stats.dart';

class AdminSubscriptionRepository {
  final DatabaseHelper _databaseHelper;

  AdminSubscriptionRepository(this._databaseHelper);

  /// Lista todas as assinaturas com filtros
  Future<Either<Failure, List<AdminSubscriptionStats>>> getAllSubscriptions(
    SubscriptionFilters filters,
  ) async {
    try {
      final db = await _databaseHelper.database;

      // Query base com JOIN
      var query = '''
        SELECT 
          s.*,
          c.id as company_id,
          c.name as company_name,
          c.email as company_email,
          c.slug as company_slug,
          c.owner_id as company_owner_id,
          c.is_active as company_is_active,
          c.created_at as company_created_at
        FROM subscriptions s
        INNER JOIN companies c ON s.company_id = c.id
        WHERE 1=1
      ''';

      final args = <dynamic>[];

      // Filtro de busca (nome da empresa)
      if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
        query += ' AND c.name LIKE ?';
        args.add('%${filters.searchQuery}%');
      }

      // Filtro de tier
      if (filters.tier != null) {
        query += ' AND s.tier = ?';
        args.add(filters.tier!.name);
      }

      // Filtro de status
      if (filters.status != null) {
        query += ' AND s.status = ?';
        args.add(filters.status!.name);
      }

      // Filtro de data de criação
      if (filters.createdAfter != null) {
        query += ' AND s.created_at >= ?';
        args.add(filters.createdAfter!.toIso8601String());
      }

      if (filters.createdBefore != null) {
        query += ' AND s.created_at <= ?';
        args.add(filters.createdBefore!.toIso8601String());
      }

      // Ordenação
      switch (filters.sortBy) {
        case SubscriptionSortBy.companyName:
          query += ' ORDER BY c.name';
          break;
        case SubscriptionSortBy.tier:
          query += ' ORDER BY s.tier';
          break;
        case SubscriptionSortBy.status:
          query += ' ORDER BY s.status';
          break;
        case SubscriptionSortBy.createdAt:
          query += ' ORDER BY s.created_at';
          break;
        case SubscriptionSortBy.revenue:
          query += ' ORDER BY s.amount';
          break;
        case SubscriptionSortBy.nextBilling:
          query += ' ORDER BY s.next_billing_date';
          break;
      }

      query += filters.ascending ? ' ASC' : ' DESC';

      final results = await db.rawQuery(query, args);

      final subscriptions = <AdminSubscriptionStats>[];
      for (final row in results) {
        final subscription = _mapToSubscription(row);
        final company = _mapToCompany(row);
        
        // Buscar histórico de pagamentos
        final paymentHistory = await _getPaymentHistory(db, subscription.id);
        
        // Calcular métricas
        final totalRevenue = _calculateTotalRevenue(paymentHistory);
        final mrr = _calculateMRR(subscription);
        final daysUntilRenewal = _calculateDaysUntilRenewal(subscription);
        final isOverdue = daysUntilRenewal < 0;

        // Aplicar filtro de vencida (pós-query)
        if (filters.isOverdue != null && filters.isOverdue != isOverdue) {
          continue;
        }

        final stats = AdminSubscriptionStats(
          subscription: subscription,
          company: company,
          paymentHistory: paymentHistory,
          totalRevenue: totalRevenue,
          monthlyRecurringRevenue: mrr,
          daysUntilRenewal: daysUntilRenewal,
          isOverdue: isOverdue,
          lastPaymentDate: paymentHistory.isNotEmpty
              ? paymentHistory
                  .where((p) => p.status == PaymentStatus.success)
                  .map((p) => p.processedAt ?? p.createdAt)
                  .reduce((a, b) => a.isAfter(b) ? a : b)
              : null,
          nextBillingDate: subscription.nextBillingDate,
        );

        subscriptions.add(stats);
      }

      return Right(subscriptions);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar assinaturas: $e'));
    }
  }

  /// Busca detalhes de uma assinatura
  Future<Either<Failure, AdminSubscriptionStats>> getSubscriptionDetails(
    String subscriptionId,
  ) async {
    try {
      final db = await _databaseHelper.database;

      final results = await db.rawQuery('''
        SELECT 
          s.*,
          c.id as company_id,
          c.name as company_name,
          c.email as company_email,
          c.slug as company_slug,
          c.owner_id as company_owner_id,
          c.is_active as company_is_active,
          c.created_at as company_created_at
        FROM subscriptions s
        INNER JOIN companies c ON s.company_id = c.id
        WHERE s.id = ?
      ''', [subscriptionId]);

      if (results.isEmpty) {
        return Left(DatabaseFailure('Assinatura não encontrada'));
      }

      final row = results.first;
      final subscription = _mapToSubscription(row);
      final company = _mapToCompany(row);
      final paymentHistory = await _getPaymentHistory(db, subscriptionId);

      final stats = AdminSubscriptionStats(
        subscription: subscription,
        company: company,
        paymentHistory: paymentHistory,
        totalRevenue: _calculateTotalRevenue(paymentHistory),
        monthlyRecurringRevenue: _calculateMRR(subscription),
        daysUntilRenewal: _calculateDaysUntilRenewal(subscription),
        isOverdue: _calculateDaysUntilRenewal(subscription) < 0,
        lastPaymentDate: paymentHistory.isNotEmpty
            ? paymentHistory
                .where((p) => p.status == PaymentStatus.success)
                .map((p) => p.processedAt ?? p.createdAt)
                .reduce((a, b) => a.isAfter(b) ? a : b)
            : null,
        nextBillingDate: subscription.nextBillingDate,
      );

      return Right(stats);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar detalhes: $e'));
    }
  }

  /// Atualiza o tier de uma assinatura (upgrade/downgrade)
  Future<Either<Failure, void>> updateSubscriptionTier(
    String subscriptionId,
    SubscriptionTier newTier,
    String adminUserId,
    String? reason,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      // Buscar assinatura atual
      final current = await db.query(
        'subscriptions',
        where: 'id = ?',
        whereArgs: [subscriptionId],
      );

      if (current.isEmpty) {
        return Left(DatabaseFailure('Assinatura não encontrada'));
      }

      final currentTier = SubscriptionTier.values.firstWhere(
        (t) => t.name == current.first['tier'],
      );

      // Atualizar tier
      await db.update(
        'subscriptions',
        {
          'tier': newTier.name,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [subscriptionId],
      );

      // Registrar ação
      final actionType = _getTierIndex(newTier) > _getTierIndex(currentTier)
          ? SubscriptionActionType.upgrade
          : SubscriptionActionType.downgrade;

      await _logAction(db, subscriptionId, actionType, adminUserId, newTier, reason);

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao atualizar assinatura: $e'));
    }
  }

  /// Cancela uma assinatura
  Future<Either<Failure, void>> cancelSubscription(
    String subscriptionId,
    String adminUserId,
    String? reason,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.update(
        'subscriptions',
        {
          'status': SubscriptionStatus.cancelled.name,
          'cancelled_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [subscriptionId],
      );

      await _logAction(
        db,
        subscriptionId,
        SubscriptionActionType.cancel,
        adminUserId,
        null,
        reason,
      );

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao cancelar assinatura: $e'));
    }
  }

  /// Reativa uma assinatura cancelada
  Future<Either<Failure, void>> reactivateSubscription(
    String subscriptionId,
    String adminUserId,
    String? reason,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.update(
        'subscriptions',
        {
          'status': SubscriptionStatus.active.name,
          'cancelled_at': null,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [subscriptionId],
      );

      await _logAction(
        db,
        subscriptionId,
        SubscriptionActionType.reactivate,
        adminUserId,
        null,
        reason,
      );

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao reativar assinatura: $e'));
    }
  }

  /// Suspende uma assinatura
  Future<Either<Failure, void>> suspendSubscription(
    String subscriptionId,
    String adminUserId,
    String? reason,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.update(
        'subscriptions',
        {
          'status': SubscriptionStatus.suspended.name,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [subscriptionId],
      );

      await _logAction(
        db,
        subscriptionId,
        SubscriptionActionType.suspend,
        adminUserId,
        null,
        reason,
      );

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao suspender assinatura: $e'));
    }
  }

  /// Processa reembolso
  Future<Either<Failure, void>> processRefund(
    String paymentId,
    String adminUserId,
    String? reason,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      // Verificar se tabela existe
      await _ensurePaymentsTableExists(db);

      // Buscar pagamento
      final payment = await db.query(
        'payment_records',
        where: 'id = ?',
        whereArgs: [paymentId],
      );

      if (payment.isEmpty) {
        return Left(DatabaseFailure('Pagamento não encontrado'));
      }

      // Atualizar status
      await db.update(
        'payment_records',
        {
          'status': PaymentStatus.refunded.name,
          'processed_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [paymentId],
      );

      // Log da ação
      final subscriptionId = payment.first['subscription_id'] as String;
      await _logAction(
        db,
        subscriptionId,
        SubscriptionActionType.refund,
        adminUserId,
        null,
        reason,
      );

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao processar reembolso: $e'));
    }
  }

  /// Estatísticas gerais de assinaturas
  Future<Either<Failure, Map<String, dynamic>>> getSystemSubscriptionStats() async {
    try {
      final db = await _databaseHelper.database;

      final results = await db.rawQuery('''
        SELECT 
          COUNT(*) as total_subscriptions,
          SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active,
          SUM(CASE WHEN status = 'trialing' THEN 1 ELSE 0 END) as trial,
          SUM(CASE WHEN status = 'pastDue' THEN 1 ELSE 0 END) as past_due,
          SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) as canceled,
          SUM(CASE WHEN tier = 'free' THEN 1 ELSE 0 END) as free_tier,
          SUM(CASE WHEN tier = 'pro' THEN 1 ELSE 0 END) as pro_tier,
          SUM(CASE WHEN tier = 'enterprise' THEN 1 ELSE 0 END) as enterprise_tier
        FROM subscriptions
      ''');

      final stats = results.first;

      // Calcular MRR total
      final allSubs = await db.query('subscriptions');
      double totalMRR = 0;
      for (final sub in allSubs) {
        final subscription = _mapToSubscription(sub);
        totalMRR += _calculateMRR(subscription);
      }

      return Right({
        'totalSubscriptions': stats['total_subscriptions'] ?? 0,
        'active': stats['active'] ?? 0,
        'trial': stats['trial'] ?? 0,
        'pastDue': stats['past_due'] ?? 0,
        'canceled': stats['canceled'] ?? 0,
        'freeTier': stats['free_tier'] ?? 0,
        'proTier': stats['pro_tier'] ?? 0,
        'enterpriseTier': stats['enterprise_tier'] ?? 0,
        'totalMRR': totalMRR,
      });
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar estatísticas: $e'));
    }
  }

  // ==================== HELPERS ====================

  Subscription _mapToSubscription(Map<String, dynamic> map) {
    final tier = SubscriptionTier.values.firstWhere(
      (t) => t.name == map['tier'],
      orElse: () => SubscriptionTier.free,
    );
    
    return Subscription(
      id: map['id'] as String,
      companyId: map['company_id'] as String,
      tier: tier,
      status: SubscriptionStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => SubscriptionStatus.active,
      ),
      billingInterval: BillingInterval.values.firstWhere(
        (b) => b.name == map['billing_interval'],
        orElse: () => BillingInterval.monthly,
      ),
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] != null
          ? DateTime.parse(map['end_date'] as String)
          : null,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      currentPeriodStart: DateTime.parse(map['start_date'] as String),
      currentPeriodEnd: DateTime.parse(map['end_date'] as String? ?? DateTime.now().add(const Duration(days: 30)).toIso8601String()),
      nextBillingDate: map['next_billing_date'] != null
          ? DateTime.parse(map['next_billing_date'] as String)
          : null,
      cancelledAt: map['cancelled_at'] != null
          ? DateTime.parse(map['cancelled_at'] as String)
          : null,
      limits: _getLimitsForTier(tier),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String? ?? map['created_at'] as String),
    );
  }

  SubscriptionLimits _getLimitsForTier(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return SubscriptionLimits.free;
      case SubscriptionTier.pro:
        return SubscriptionLimits.pro;
      case SubscriptionTier.enterprise:
        return SubscriptionLimits.enterprise;
    }
  }

  Company _mapToCompany(Map<String, dynamic> map) {
    return Company(
      id: map['company_id'] as String,
      name: map['company_name'] as String,
      slug: map['company_slug'] as String? ?? map['company_name'].toString().toLowerCase(),
      ownerId: map['company_owner_id'] as String? ?? '1',
      isActive: (map['company_is_active'] as int? ?? 1) == 1,
      createdAt: DateTime.parse(map['company_created_at'] as String),
      updatedAt: DateTime.parse(map['company_created_at'] as String),
    );
  }

  Future<List<PaymentRecord>> _getPaymentHistory(
    Database db,
    String subscriptionId,
  ) async {
    await _ensurePaymentsTableExists(db);

    final results = await db.query(
      'payment_records',
      where: 'subscription_id = ?',
      whereArgs: [subscriptionId],
      orderBy: 'created_at DESC',
      limit: 50,
    );

    return results.map((row) => PaymentRecord(
      id: row['id'] as String,
      subscriptionId: row['subscription_id'] as String,
      amount: (row['amount'] as num).toDouble(),
      status: PaymentStatus.values.firstWhere(
        (s) => s.name == row['status'],
        orElse: () => PaymentStatus.pending,
      ),
      transactionId: row['transaction_id'] as String?,
      paymentMethod: row['payment_method'] as String?,
      failureReason: row['failure_reason'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
      processedAt: row['processed_at'] != null
          ? DateTime.parse(row['processed_at'] as String)
          : null,
    )).toList();
  }

  double _calculateTotalRevenue(List<PaymentRecord> payments) {
    return payments
        .where((p) => p.status == PaymentStatus.success)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  double _calculateMRR(Subscription subscription) {
    if (subscription.status != SubscriptionStatus.active) return 0;
    
    switch (subscription.billingInterval) {
      case BillingInterval.monthly:
        return subscription.amount;
      case BillingInterval.yearly:
        return subscription.amount / 12;
    }
  }

  int _calculateDaysUntilRenewal(Subscription subscription) {
    if (subscription.nextBillingDate == null) return -1;
    return subscription.nextBillingDate!.difference(DateTime.now()).inDays;
  }

  int _getTierIndex(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return 0;
      case SubscriptionTier.pro:
        return 1;
      case SubscriptionTier.enterprise:
        return 2;
    }
  }

  Future<void> _logAction(
    Database db,
    String subscriptionId,
    SubscriptionActionType type,
    String adminUserId,
    SubscriptionTier? newTier,
    String? reason,
  ) async {
    await _ensureActionsTableExists(db);

    await db.insert('subscription_actions', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'subscription_id': subscriptionId,
      'type': type.name,
      'new_tier': newTier?.name,
      'reason': reason,
      'performed_by': adminUserId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _ensurePaymentsTableExists(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS payment_records (
        id TEXT PRIMARY KEY,
        subscription_id TEXT NOT NULL,
        amount REAL NOT NULL,
        status TEXT NOT NULL,
        transaction_id TEXT,
        payment_method TEXT,
        failure_reason TEXT,
        created_at TEXT NOT NULL,
        processed_at TEXT,
        FOREIGN KEY (subscription_id) REFERENCES subscriptions (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _ensureActionsTableExists(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS subscription_actions (
        id TEXT PRIMARY KEY,
        subscription_id TEXT NOT NULL,
        type TEXT NOT NULL,
        new_tier TEXT,
        reason TEXT,
        performed_by TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (subscription_id) REFERENCES subscriptions (id) ON DELETE CASCADE
      )
    ''');
  }
}
