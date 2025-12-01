import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/subscription_data.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';
import '../../../../core/error/failures.dart';

/// Serviço de integração com Abacate Pay
class AbacatePayService {
  final Dio _dio;
  final AbacatePayConfig _config;

  AbacatePayService({
    required AbacatePayConfig config,
    Dio? dio,
  })  : _config = config,
        _dio = dio ?? Dio() {
    _dio.options.baseUrl = _config.baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer ${_config.apiKey}',
      'Content-Type': 'application/json',
    };
  }

  // ============================================
  // Customer Management
  // ============================================

  /// Cria um novo cliente no Abacate Pay
  Future<Either<Failure, AbacatePayCustomer>> createCustomer({
    required String email,
    required String name,
    String? phone,
    String? documentNumber,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post('/customers', data: {
        'email': email,
        'name': name,
        if (phone != null) 'phone': phone,
        if (documentNumber != null) 'document_number': documentNumber,
        if (metadata != null) 'metadata': metadata,
      });

      if (response.statusCode == 201) {
        return Right(_customerFromJson(response.data));
      }

      return Left(ServerFailure('Erro ao criar cliente: ${response.statusMessage}'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  /// Busca um cliente por ID
  Future<Either<Failure, AbacatePayCustomer>> getCustomer(String customerId) async {
    try {
      final response = await _dio.get('/customers/$customerId');

      if (response.statusCode == 200) {
        return Right(_customerFromJson(response.data));
      }

      return const Left(NotFoundFailure('Cliente não encontrado'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  // ============================================
  // Payment Methods
  // ============================================

  /// Adiciona um método de pagamento ao cliente
  Future<Either<Failure, PaymentMethod>> addPaymentMethod({
    required String customerId,
    required String token, // Token do cartão gerado pelo frontend
    bool setAsDefault = false,
  }) async {
    try {
      final response = await _dio.post('/payment-methods', data: {
        'customer_id': customerId,
        'token': token,
        'set_as_default': setAsDefault,
      });

      if (response.statusCode == 201) {
        return Right(_paymentMethodFromJson(response.data));
      }

      return const Left(ServerFailure('Erro ao adicionar método de pagamento'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  /// Lista métodos de pagamento do cliente
  Future<Either<Failure, List<PaymentMethod>>> listPaymentMethods(
    String customerId,
  ) async {
    try {
      final response = await _dio.get('/customers/$customerId/payment-methods');

      if (response.statusCode == 200) {
        final methods = (response.data['data'] as List)
            .map((json) => _paymentMethodFromJson(json))
            .toList();
        return Right(methods);
      }

      return const Left(ServerFailure('Erro ao listar métodos de pagamento'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  /// Remove um método de pagamento
  Future<Either<Failure, void>> removePaymentMethod(String paymentMethodId) async {
    try {
      final response = await _dio.delete('/payment-methods/$paymentMethodId');

      if (response.statusCode == 204) {
        return const Right(null);
      }

      return const Left(ServerFailure('Erro ao remover método de pagamento'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  // ============================================
  // Subscriptions
  // ============================================

  /// Cria uma nova assinatura
  Future<Either<Failure, String>> createSubscription(
    CreateSubscriptionData data,
  ) async {
    try {
      final pricing = SubscriptionPricing.getByTier(data.tier);
      if (pricing == null) {
        return Left(ValidationFailure('Tier inválido: ${data.tier}'));
      }

      final amount = data.billingInterval == 'yearly'
          ? pricing.yearlyPrice
          : pricing.monthlyPrice;

      final response = await _dio.post('/subscriptions', data: {
        'customer_id': data.customerId,
        'plan_id': '${data.tier}_${data.billingInterval}',
        'amount': amount,
        'currency': 'BRL',
        'interval': data.billingInterval,
        if (data.paymentMethodId != null)
          'payment_method_id': data.paymentMethodId,
        if (data.startTrial) 'trial_period_days': data.trialDays ?? 14,
        'metadata': {
          'company_id': data.companyId,
          'tier': data.tier,
        },
      });

      if (response.statusCode == 201) {
        return Right(response.data['id'] as String);
      }

      return const Left(ServerFailure('Erro ao criar assinatura'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  /// Atualiza uma assinatura existente
  Future<Either<Failure, void>> updateSubscription(
    UpdateSubscriptionData data,
  ) async {
    try {
      final updateData = <String, dynamic>{};

      if (data.newTier != null) {
        final pricing = SubscriptionPricing.getByTier(data.newTier!);
        if (pricing == null) {
          return Left(ValidationFailure('Tier inválido: ${data.newTier}'));
        }

        final interval = data.newBillingInterval ?? 'monthly';
        final amount =
            interval == 'yearly' ? pricing.yearlyPrice : pricing.monthlyPrice;

        updateData['plan_id'] = '${data.newTier}_$interval';
        updateData['amount'] = amount;
      }

      if (data.newPaymentMethodId != null) {
        updateData['payment_method_id'] = data.newPaymentMethodId;
      }

      if (data.cancelAtPeriodEnd != null) {
        updateData['cancel_at_period_end'] = data.cancelAtPeriodEnd;
      }

      final response = await _dio.patch(
        '/subscriptions/${data.subscriptionId}',
        data: updateData,
      );

      if (response.statusCode == 200) {
        return const Right(null);
      }

      return const Left(ServerFailure('Erro ao atualizar assinatura'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  /// Cancela uma assinatura
  Future<Either<Failure, void>> cancelSubscription(
    String subscriptionId, {
    bool immediate = false,
  }) async {
    try {
      final response = await _dio.post(
        '/subscriptions/$subscriptionId/cancel',
        data: {'immediate': immediate},
      );

      if (response.statusCode == 200) {
        return const Right(null);
      }

      return const Left(ServerFailure('Erro ao cancelar assinatura'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  /// Pausa uma assinatura
  Future<Either<Failure, void>> pauseSubscription(String subscriptionId) async {
    try {
      final response = await _dio.post('/subscriptions/$subscriptionId/pause');

      if (response.statusCode == 200) {
        return const Right(null);
      }

      return const Left(ServerFailure('Erro ao pausar assinatura'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  /// Retoma uma assinatura pausada
  Future<Either<Failure, void>> resumeSubscription(String subscriptionId) async {
    try {
      final response = await _dio.post('/subscriptions/$subscriptionId/resume');

      if (response.statusCode == 200) {
        return const Right(null);
      }

      return const Left(ServerFailure('Erro ao retomar assinatura'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  // ============================================
  // Payments
  // ============================================

  /// Cria um pagamento único (não recorrente)
  Future<Either<Failure, PaymentIntent>> createPayment({
    required String customerId,
    required double amount,
    String currency = 'BRL',
    String? paymentMethodId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post('/payments', data: {
        'customer_id': customerId,
        'amount': (amount * 100).round(), // Converter para centavos
        'currency': currency,
        if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
        if (metadata != null) 'metadata': metadata,
      });

      if (response.statusCode == 201) {
        return Right(_paymentIntentFromJson(response.data));
      }

      return const Left(ServerFailure('Erro ao criar pagamento'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  // ============================================
  // Helpers
  // ============================================

  Failure _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = e.response!.data['message'] ?? e.message;

      switch (statusCode) {
        case 400:
          return ValidationFailure(message ?? 'Dados inválidos');
        case 401:
          return const UnauthorizedFailure('Credenciais inválidas');
        case 404:
          return NotFoundFailure(message ?? 'Recurso não encontrado');
        case 429:
          return const ServerFailure('Muitas requisições. Tente novamente mais tarde.');
        default:
          return ServerFailure(message ?? 'Erro no servidor');
      }
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Timeout na conexão');
    }

    return NetworkFailure('Erro de conexão: ${e.message}');
  }

  AbacatePayCustomer _customerFromJson(Map<String, dynamic> json) {
    return AbacatePayCustomer(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      documentNumber: json['document_number'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  PaymentMethod _paymentMethodFromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      type: _parsePaymentMethodType(json['type'] as String),
      isDefault: json['is_default'] as bool? ?? false,
      cardBrand: json['card_brand'] as String?,
      cardLast4: json['card_last4'] as String?,
      cardExpMonth: json['card_exp_month'] as String?,
      cardExpYear: json['card_exp_year'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  PaymentIntent _paymentIntentFromJson(Map<String, dynamic> json) {
    return PaymentIntent(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      amount: (json['amount'] as num).toDouble() / 100, // Converter de centavos
      currency: json['currency'] as String? ?? 'BRL',
      status: json['status'] as String,
      paymentUrl: json['payment_url'] as String?,
      pixCode: json['pix_code'] as String?,
      boletoUrl: json['boleto_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }

  PaymentMethodType _parsePaymentMethodType(String type) {
    switch (type.toLowerCase()) {
      case 'credit_card':
        return PaymentMethodType.creditCard;
      case 'debit_card':
        return PaymentMethodType.debitCard;
      case 'pix':
        return PaymentMethodType.pix;
      case 'boleto':
        return PaymentMethodType.boleto;
      default:
        return PaymentMethodType.creditCard;
    }
  }
}
