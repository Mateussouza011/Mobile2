import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/subscription_data.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';
import '../../../../core/error/failures.dart';
import '../../../../data/datasources/local/database_helper.dart';

/// Repositório de assinaturas com persistência local e sincronização com Abacate Pay
class SubscriptionRepository {
  final DatabaseHelper _databaseHelper;

  SubscriptionRepository({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  // ============================================
  // Create
  // ============================================

  /// Salva uma nova assinatura localmente após criação no Abacate Pay
  Future<Either<Failure, String>> saveSubscription(
    Subscription subscription,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      final data = {
        'id': subscription.id,
        'company_id': subscription.companyId,
        'tier': subscription.tier.name,
        'status': subscription.status.name,
        'amount': subscription.amount,
        'currency': subscription.currency,
        'billing_interval': subscription.billingInterval.name,
        'start_date': subscription.startDate.toIso8601String(),
        if (subscription.endDate != null)
          'end_date': subscription.endDate!.toIso8601String(),
        if (subscription.trialEndsAt != null)
          'trial_ends_at': subscription.trialEndsAt!.toIso8601String(),
        if (subscription.cancelledAt != null)
          'cancelled_at': subscription.cancelledAt!.toIso8601String(),
        'current_period_start': subscription.currentPeriodStart.toIso8601String(),
        'current_period_end': subscription.currentPeriodEnd.toIso8601String(),
        if (subscription.nextBillingDate != null)
          'next_billing_date': subscription.nextBillingDate!.toIso8601String(),
        'max_users': subscription.limits.maxUsers,
        'max_predictions_per_month': subscription.limits.maxPredictionsPerMonth,
        'has_api_access': subscription.limits.hasApiAccess ? 1 : 0,
        'has_export': subscription.limits.hasExportFeatures ? 1 : 0,
        'has_white_label': subscription.limits.hasWhiteLabel ? 1 : 0,
        'has_priority_support': subscription.limits.hasPrioritySupport ? 1 : 0,
        if (subscription.abacatePaySubscriptionId != null)
          'abacate_pay_subscription_id': subscription.abacatePaySubscriptionId,
        if (subscription.abacatePayCustomerId != null)
          'abacate_pay_customer_id': subscription.abacatePayCustomerId,
        'created_at': subscription.createdAt.toIso8601String(),
        'updated_at': subscription.updatedAt.toIso8601String(),
      };

      await db.insert(
        'subscriptions',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return Right(subscription.id);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao salvar assinatura: $e'));
    }
  }

  // ============================================
  // Read
  // ============================================

  /// Busca a assinatura ativa de uma empresa
  Future<Either<Failure, Subscription>> getCompanySubscription(
    String companyId,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      final maps = await db.query(
        'subscriptions',
        where: 'company_id = ? AND status IN (?, ?, ?)',
        whereArgs: ['active', 'trialing', 'past_due'],
        orderBy: 'created_at DESC',
        limit: 1,
      );

      if (maps.isEmpty) {
        return const Left(NotFoundFailure('Assinatura não encontrada para a empresa'));
      }

      return Right(_subscriptionFromMap(maps.first));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar assinatura: $e'));
    }
  }

  /// Busca assinatura por ID
  Future<Either<Failure, Subscription>> getSubscriptionById(String id) async {
    try {
      final db = await _databaseHelper.database;
      
      final maps = await db.query(
        'subscriptions',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        return const Left(NotFoundFailure('Assinatura não encontrada'));
      }

      return Right(_subscriptionFromMap(maps.first));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar assinatura: $e'));
    }
  }

  /// Lista todas as assinaturas de uma empresa (incluindo canceladas/expiradas)
  Future<Either<Failure, List<Subscription>>> getCompanySubscriptionHistory(
    String companyId,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      final maps = await db.query(
        'subscriptions',
        where: 'company_id = ?',
        whereArgs: [companyId],
        orderBy: 'created_at DESC',
      );

      final subscriptions = maps.map((map) => _subscriptionFromMap(map)).toList();
      return Right(subscriptions);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar histórico de assinaturas: $e'));
    }
  }

  // ============================================
  // Update
  // ============================================

  /// Atualiza o status da assinatura (sincronizar com webhooks)
  Future<Either<Failure, void>> updateSubscriptionStatus({
    required String subscriptionId,
    required String status,
    DateTime? canceledAt,
    DateTime? cancelAt,
    bool? cancelAtPeriodEnd,
  }) async {
    try {
      final db = await _databaseHelper.database;
      
      final data = <String, dynamic>{
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
        if (canceledAt != null) 'canceled_at': canceledAt.toIso8601String(),
        if (cancelAt != null) 'cancel_at': cancelAt.toIso8601String(),
        if (cancelAtPeriodEnd != null) 
          'cancel_at_period_end': cancelAtPeriodEnd ? 1 : 0,
      };

      final rowsAffected = await db.update(
        'subscriptions',
        data,
        where: 'id = ?',
        whereArgs: [subscriptionId],
      );

      if (rowsAffected == 0) {
        return const Left(NotFoundFailure('Assinatura não encontrada'));
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao atualizar status da assinatura: $e'));
    }
  }

  /// Atualiza o tier e preços da assinatura
  Future<Either<Failure, void>> updateSubscriptionTier({
    required String subscriptionId,
    required String newTier,
    required double monthlyPrice,
    required double yearlyPrice,
    required String billingInterval,
    required SubscriptionLimits limits,
  }) async {
    try {
      final db = await _databaseHelper.database;
      
      final data = {
        'tier': newTier,
        'amount': billingInterval == 'yearly' ? yearlyPrice : monthlyPrice,
        'billing_interval': billingInterval,
        'max_users': limits.maxUsers,
        'max_predictions_per_month': limits.maxPredictionsPerMonth,
        'has_api_access': limits.hasApiAccess ? 1 : 0,
        'has_export': limits.hasExportFeatures ? 1 : 0,
        'has_white_label': limits.hasWhiteLabel ? 1 : 0,
        'has_priority_support': limits.hasPrioritySupport ? 1 : 0,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final rowsAffected = await db.update(
        'subscriptions',
        data,
        where: 'id = ?',
        whereArgs: [subscriptionId],
      );

      if (rowsAffected == 0) {
        return const Left(NotFoundFailure('Assinatura não encontrada'));
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao atualizar tier da assinatura: $e'));
    }
  }

  /// Atualiza o período atual da assinatura (renovação)
  Future<Either<Failure, void>> renewSubscriptionPeriod({
    required String subscriptionId,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    try {
      final db = await _databaseHelper.database;
      
      final data = {
        'current_period_start': periodStart.toIso8601String(),
        'current_period_end': periodEnd.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final rowsAffected = await db.update(
        'subscriptions',
        data,
        where: 'id = ?',
        whereArgs: [subscriptionId],
      );

      if (rowsAffected == 0) {
        return const Left(NotFoundFailure('Assinatura não encontrada'));
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao renovar período da assinatura: $e'));
    }
  }

  // ============================================
  // Delete
  // ============================================

  /// Remove uma assinatura (apenas para limpeza, não deve ser usado normalmente)
  Future<Either<Failure, void>> deleteSubscription(String subscriptionId) async {
    try {
      final db = await _databaseHelper.database;
      
      final rowsAffected = await db.delete(
        'subscriptions',
        where: 'id = ?',
        whereArgs: [subscriptionId],
      );

      if (rowsAffected == 0) {
        return const Left(NotFoundFailure('Assinatura não encontrada'));
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao deletar assinatura: $e'));
    }
  }

  // ============================================
  // Payment History
  // ============================================

  /// Registra um pagamento realizado
  Future<Either<Failure, void>> recordPayment(PaymentHistory payment) async {
    try {
      final db = await _databaseHelper.database;
      
      // Assumindo que há uma tabela payment_history (ainda não criada)
      // Por enquanto, vamos apenas retornar sucesso
      // TODO: Criar tabela payment_history no database_helper.dart
      
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao registrar pagamento: $e'));
    }
  }

  /// Busca histórico de pagamentos de uma empresa
  Future<Either<Failure, List<PaymentHistory>>> getPaymentHistory({
    required String companyId,
    int? limit,
  }) async {
    try {
      // TODO: Implementar quando a tabela payment_history for criada
      return const Right([]);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar histórico de pagamentos: $e'));
    }
  }

  // ============================================
  // Helpers
  // ============================================

  Subscription _subscriptionFromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'] as String,
      companyId: map['company_id'] as String,
      tier: _parseTier(map['tier'] as String),
      status: _parseStatus(map['status'] as String),
      amount: map['amount'] as double,
      currency: map['currency'] as String? ?? 'BRL',
      billingInterval: _parseBillingInterval(map['billing_interval'] as String),
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] != null 
          ? DateTime.parse(map['end_date'] as String) 
          : null,
      trialEndsAt: map['trial_ends_at'] != null 
          ? DateTime.parse(map['trial_ends_at'] as String) 
          : null,
      cancelledAt: map['cancelled_at'] != null 
          ? DateTime.parse(map['cancelled_at'] as String) 
          : null,
      currentPeriodStart: DateTime.parse(map['current_period_start'] as String),
      currentPeriodEnd: DateTime.parse(map['current_period_end'] as String),
      nextBillingDate: map['next_billing_date'] != null 
          ? DateTime.parse(map['next_billing_date'] as String) 
          : null,
      limits: SubscriptionLimits(
        maxUsers: map['max_users'] as int,
        maxPredictionsPerMonth: map['max_predictions_per_month'] as int,
        hasApiAccess: map['has_api_access'] == 1,
        hasExportFeatures: map['has_export'] == 1,
        hasWhiteLabel: map['has_white_label'] == 1,
        hasPrioritySupport: map['has_priority_support'] == 1,
      ),
      abacatePaySubscriptionId: map['abacate_pay_subscription_id'] as String?,
      abacatePayCustomerId: map['abacate_pay_customer_id'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  SubscriptionTier _parseTier(String tier) {
    switch (tier.toLowerCase()) {
      case 'pro':
        return SubscriptionTier.pro;
      case 'enterprise':
        return SubscriptionTier.enterprise;
      default:
        return SubscriptionTier.free;
    }
  }

  SubscriptionStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return SubscriptionStatus.active;
      case 'trialing':
        return SubscriptionStatus.trialing;
      case 'past_due':
      case 'pastdue':
        return SubscriptionStatus.pastDue;
      case 'cancelled':
        return SubscriptionStatus.cancelled;
      case 'expired':
        return SubscriptionStatus.expired;
      case 'suspended':
        return SubscriptionStatus.suspended;
      default:
        return SubscriptionStatus.expired;
    }
  }

  BillingInterval _parseBillingInterval(String interval) {
    switch (interval.toLowerCase()) {
      case 'yearly':
        return BillingInterval.yearly;
      default:
        return BillingInterval.monthly;
    }
  }
}
