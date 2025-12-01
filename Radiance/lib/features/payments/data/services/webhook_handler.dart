import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/subscription_data.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';
import '../repositories/subscription_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';

/// Handler para processar webhooks do Abacate Pay
class WebhookHandler {
  final SubscriptionRepository _subscriptionRepository;
  final String _webhookSecret;
  final AppLogger _logger;

  WebhookHandler({
    required SubscriptionRepository subscriptionRepository,
    required String webhookSecret,
    AppLogger? logger,
  })  : _subscriptionRepository = subscriptionRepository,
        _webhookSecret = webhookSecret,
        _logger = logger ?? AppLogger();

  // ============================================
  // Webhook Processing
  // ============================================

  /// Processa um webhook recebido do Abacate Pay
  Future<Either<Failure, void>> processWebhook({
    required Map<String, dynamic> payload,
    required String signature,
    String? timestamp,
  }) async {
    try {
      // 1. Validar assinatura do webhook
      final validationResult = _validateSignature(
        payload: payload,
        signature: signature,
        timestamp: timestamp,
      );

      if (validationResult.isLeft()) {
        _logger.error('Webhook validation failed');
        return validationResult;
      }

      // 2. Extrair tipo de evento
      final eventType = _parseEventType(payload['type'] as String?);
      if (eventType == null) {
        _logger.warning('Unknown webhook event type: ${payload['type']}');
        return const Left(ValidationFailure('Tipo de evento desconhecido'));
      }

      _logger.info('Processing webhook event: ${eventType.name}');

      // 3. Processar evento com base no tipo
      final result = await _handleEvent(eventType, payload['data'] as Map<String, dynamic>?);

      if (result.isRight()) {
        _logger.info('Webhook processed successfully: ${eventType.name}');
      } else {
        _logger.error('Failed to process webhook: ${eventType.name}');
      }

      return result;
    } catch (e) {
      _logger.error('Unexpected error processing webhook: $e');
      return Left(ServerFailure('Erro ao processar webhook: $e'));
    }
  }

  /// Valida a assinatura do webhook para segurança
  Either<Failure, void> _validateSignature({
    required Map<String, dynamic> payload,
    required String signature,
    String? timestamp,
  }) {
    try {
      // Criar string para assinar: timestamp.payload_json
      final payloadJson = jsonEncode(payload);
      final signedPayload = timestamp != null 
          ? '$timestamp.$payloadJson' 
          : payloadJson;

      // Calcular HMAC SHA256
      final key = utf8.encode(_webhookSecret);
      final bytes = utf8.encode(signedPayload);
      final hmac = Hmac(sha256, key);
      final digest = hmac.convert(bytes);
      final expectedSignature = digest.toString();

      // Comparar assinaturas (timing-safe)
      if (_secureCompare(signature, expectedSignature)) {
        return const Right(null);
      }

      return const Left(UnauthorizedFailure('Assinatura de webhook inválida'));
    } catch (e) {
      return Left(ValidationFailure('Erro ao validar assinatura: $e'));
    }
  }

  /// Compara strings de forma segura contra timing attacks
  bool _secureCompare(String a, String b) {
    if (a.length != b.length) return false;
    
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  // ============================================
  // Event Handlers
  // ============================================

  Future<Either<Failure, void>> _handleEvent(
    WebhookEventType eventType,
    Map<String, dynamic>? data,
  ) async {
    if (data == null) {
      return const Left(ValidationFailure('Dados do evento não fornecidos'));
    }

    switch (eventType) {
      case WebhookEventType.paymentSucceeded:
        return _handlePaymentSucceeded(data);
      case WebhookEventType.paymentFailed:
        return _handlePaymentFailed(data);
      case WebhookEventType.subscriptionCreated:
        return _handleSubscriptionCreated(data);
      case WebhookEventType.subscriptionUpdated:
        return _handleSubscriptionUpdated(data);
      case WebhookEventType.subscriptionCancelled:
        return _handleSubscriptionCancelled(data);
      case WebhookEventType.subscriptionPaused:
        return _handleSubscriptionPaused(data);
      case WebhookEventType.subscriptionResumed:
        return _handleSubscriptionResumed(data);
      case WebhookEventType.subscriptionExpired:
        return _handleSubscriptionExpired(data);
      case WebhookEventType.invoicePaid:
        return _handleInvoicePaid(data);
      case WebhookEventType.invoiceFailed:
        return _handleInvoiceFailed(data);
      case WebhookEventType.trialEnding:
        return _handleTrialEnding(data);
      case WebhookEventType.trialEnded:
        return _handleTrialEnded(data);
      default:
        _logger.info('Event type not handled: ${eventType.name}');
        return const Right(null);
    }
  }

  Future<Either<Failure, void>> _handlePaymentSucceeded(
    Map<String, dynamic> data,
  ) async {
    try {
      final subscriptionId = data['subscription_id'] as String?;
      final amount = (data['amount'] as num?)?.toDouble();
      final paymentDate = data['paid_at'] != null
          ? DateTime.parse(data['paid_at'] as String)
          : DateTime.now();

      if (subscriptionId != null) {
        // Registrar pagamento
        final payment = PaymentHistory(
          id: data['id'] as String? ?? '',
          companyId: data['company_id'] as String? ?? '',
          subscriptionId: subscriptionId,
          amount: amount ?? 0.0,
          status: 'paid',
          paymentMethod: data['payment_method'] as String?,
          transactionId: data['transaction_id'] as String?,
          paidAt: paymentDate,
          createdAt: paymentDate,
        );

        await _subscriptionRepository.recordPayment(payment);

        // Atualizar status da assinatura para ativa
        return await _subscriptionRepository.updateSubscriptionStatus(
          subscriptionId: subscriptionId,
          status: 'active',
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao processar pagamento bem-sucedido: $e'));
    }
  }

  Future<Either<Failure, void>> _handlePaymentFailed(
    Map<String, dynamic> data,
  ) async {
    try {
      final subscriptionId = data['subscription_id'] as String?;
      
      if (subscriptionId != null) {
        // Atualizar status para past_due
        return await _subscriptionRepository.updateSubscriptionStatus(
          subscriptionId: subscriptionId,
          status: 'past_due',
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao processar falha de pagamento: $e'));
    }
  }

  Future<Either<Failure, void>> _handleSubscriptionCreated(
    Map<String, dynamic> data,
  ) async {
    _logger.info('Subscription created webhook received');
    // Assinatura já foi criada localmente antes da criação no Abacate Pay
    // Não precisamos fazer nada aqui
    return const Right(null);
  }

  Future<Either<Failure, void>> _handleSubscriptionUpdated(
    Map<String, dynamic> data,
  ) async {
    try {
      final subscriptionId = data['id'] as String?;
      final status = data['status'] as String?;

      if (subscriptionId != null && status != null) {
        return await _subscriptionRepository.updateSubscriptionStatus(
          subscriptionId: subscriptionId,
          status: status,
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao atualizar assinatura: $e'));
    }
  }

  Future<Either<Failure, void>> _handleSubscriptionCancelled(
    Map<String, dynamic> data,
  ) async {
    try {
      final subscriptionId = data['id'] as String?;
      final cancelledAt = data['cancelled_at'] != null
          ? DateTime.parse(data['cancelled_at'] as String)
          : DateTime.now();
      final cancelAtPeriodEnd = data['cancel_at_period_end'] as bool? ?? false;

      if (subscriptionId != null) {
        return await _subscriptionRepository.updateSubscriptionStatus(
          subscriptionId: subscriptionId,
          status: cancelAtPeriodEnd ? 'active' : 'cancelled',
          canceledAt: cancelledAt,
          cancelAtPeriodEnd: cancelAtPeriodEnd,
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao cancelar assinatura: $e'));
    }
  }

  Future<Either<Failure, void>> _handleSubscriptionPaused(
    Map<String, dynamic> data,
  ) async {
    try {
      final subscriptionId = data['id'] as String?;

      if (subscriptionId != null) {
        return await _subscriptionRepository.updateSubscriptionStatus(
          subscriptionId: subscriptionId,
          status: 'suspended',
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao pausar assinatura: $e'));
    }
  }

  Future<Either<Failure, void>> _handleSubscriptionResumed(
    Map<String, dynamic> data,
  ) async {
    try {
      final subscriptionId = data['id'] as String?;

      if (subscriptionId != null) {
        return await _subscriptionRepository.updateSubscriptionStatus(
          subscriptionId: subscriptionId,
          status: 'active',
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao retomar assinatura: $e'));
    }
  }

  Future<Either<Failure, void>> _handleSubscriptionExpired(
    Map<String, dynamic> data,
  ) async {
    try {
      final subscriptionId = data['id'] as String?;

      if (subscriptionId != null) {
        return await _subscriptionRepository.updateSubscriptionStatus(
          subscriptionId: subscriptionId,
          status: 'expired',
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao expirar assinatura: $e'));
    }
  }

  Future<Either<Failure, void>> _handleInvoicePaid(
    Map<String, dynamic> data,
  ) async {
    try {
      final subscriptionId = data['subscription_id'] as String?;
      final periodStart = data['period_start'] != null
          ? DateTime.parse(data['period_start'] as String)
          : null;
      final periodEnd = data['period_end'] != null
          ? DateTime.parse(data['period_end'] as String)
          : null;

      if (subscriptionId != null && periodStart != null && periodEnd != null) {
        // Renovar período da assinatura
        await _subscriptionRepository.renewSubscriptionPeriod(
          subscriptionId: subscriptionId,
          periodStart: periodStart,
          periodEnd: periodEnd,
        );

        // Garantir que status está ativo
        return await _subscriptionRepository.updateSubscriptionStatus(
          subscriptionId: subscriptionId,
          status: 'active',
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao processar fatura paga: $e'));
    }
  }

  Future<Either<Failure, void>> _handleInvoiceFailed(
    Map<String, dynamic> data,
  ) async {
    return _handlePaymentFailed(data);
  }

  Future<Either<Failure, void>> _handleTrialEnding(
    Map<String, dynamic> data,
  ) async {
    _logger.info('Trial ending soon for subscription: ${data['id']}');
    // TODO: Enviar notificação para o usuário
    return const Right(null);
  }

  Future<Either<Failure, void>> _handleTrialEnded(
    Map<String, dynamic> data,
  ) async {
    try {
      final subscriptionId = data['id'] as String?;
      final hasPaymentMethod = data['has_payment_method'] as bool? ?? false;

      if (subscriptionId != null) {
        // Se não tem método de pagamento, cancelar
        final newStatus = hasPaymentMethod ? 'active' : 'expired';
        
        return await _subscriptionRepository.updateSubscriptionStatus(
          subscriptionId: subscriptionId,
          status: newStatus,
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao finalizar trial: $e'));
    }
  }

  // ============================================
  // Helpers
  // ============================================

  WebhookEventType? _parseEventType(String? type) {
    if (type == null) return null;

    switch (type.toLowerCase()) {
      case 'payment.succeeded':
        return WebhookEventType.paymentSucceeded;
      case 'payment.failed':
        return WebhookEventType.paymentFailed;
      case 'subscription.created':
        return WebhookEventType.subscriptionCreated;
      case 'subscription.updated':
        return WebhookEventType.subscriptionUpdated;
      case 'subscription.cancelled':
        return WebhookEventType.subscriptionCancelled;
      case 'subscription.paused':
        return WebhookEventType.subscriptionPaused;
      case 'subscription.resumed':
        return WebhookEventType.subscriptionResumed;
      case 'subscription.expired':
        return WebhookEventType.subscriptionExpired;
      case 'invoice.paid':
        return WebhookEventType.invoicePaid;
      case 'invoice.failed':
        return WebhookEventType.invoiceFailed;
      case 'invoice.upcoming':
        return WebhookEventType.invoiceUpcoming;
      case 'trial.ending':
        return WebhookEventType.trialEnding;
      case 'trial.ended':
        return WebhookEventType.trialEnded;
      case 'customer.created':
        return WebhookEventType.customerCreated;
      case 'customer.updated':
        return WebhookEventType.customerUpdated;
      default:
        return null;
    }
  }
}
