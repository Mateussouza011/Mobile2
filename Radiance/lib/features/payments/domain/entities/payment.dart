import 'package:equatable/equatable.dart';

/// Configuração do Abacate Pay
class AbacatePayConfig extends Equatable {
  final String apiKey;
  final String apiSecret;
  final String baseUrl;
  final bool isProduction;

  const AbacatePayConfig({
    required this.apiKey,
    required this.apiSecret,
    this.baseUrl = 'https://api.abacatepay.com/v1',
    this.isProduction = false,
  });

  // Configuração de desenvolvimento/teste
  static const AbacatePayConfig development = AbacatePayConfig(
    apiKey: 'test_key',
    apiSecret: 'test_secret',
    baseUrl: 'https://api-sandbox.abacatepay.com/v1',
    isProduction: false,
  );

  @override
  List<Object?> get props => [apiKey, apiSecret, baseUrl, isProduction];
}

/// Métodos de pagamento suportados
enum PaymentMethodType {
  creditCard,
  debitCard,
  pix,
  boleto,
}

/// Entidade que representa um método de pagamento
class PaymentMethod extends Equatable {
  final String id;
  final String customerId;
  final PaymentMethodType type;
  final bool isDefault;
  
  // Dados do cartão (mascarados)
  final String? cardBrand; // visa, mastercard, etc
  final String? cardLast4;
  final String? cardExpMonth;
  final String? cardExpYear;
  
  // Metadados
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PaymentMethod({
    required this.id,
    required this.customerId,
    required this.type,
    this.isDefault = false,
    this.cardBrand,
    this.cardLast4,
    this.cardExpMonth,
    this.cardExpYear,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isCard => type == PaymentMethodType.creditCard || type == PaymentMethodType.debitCard;
  bool get isExpired {
    if (!isCard || cardExpMonth == null || cardExpYear == null) return false;
    final now = DateTime.now();
    final expYear = int.parse(cardExpYear!);
    final expMonth = int.parse(cardExpMonth!);
    return DateTime(expYear, expMonth).isBefore(DateTime(now.year, now.month));
  }

  String get displayName {
    if (isCard && cardBrand != null && cardLast4 != null) {
      return '$cardBrand •••• $cardLast4';
    }
    return type.name.toUpperCase();
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        type,
        isDefault,
        cardBrand,
        cardLast4,
        cardExpMonth,
        cardExpYear,
        createdAt,
        updatedAt,
      ];
}

/// Entidade que representa um cliente no Abacate Pay
class AbacatePayCustomer extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? documentNumber; // CPF/CNPJ
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const AbacatePayCustomer({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.documentNumber,
    this.metadata,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phone,
        documentNumber,
        metadata,
        createdAt,
      ];
}

/// Tipos de eventos de webhook do Abacate Pay
enum WebhookEventType {
  paymentSucceeded,
  paymentFailed,
  paymentRefunded,
  subscriptionCreated,
  subscriptionUpdated,
  subscriptionCancelled,
  subscriptionPaused,
  subscriptionResumed,
  invoiceCreated,
  invoicePaid,
  invoiceFailed,
  customerCreated,
  customerUpdated,
  customerDeleted,
}

/// Entidade que representa um evento de webhook
class WebhookEvent extends Equatable {
  final String id;
  final WebhookEventType type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final bool processed;
  final DateTime? processedAt;
  final String? errorMessage;

  const WebhookEvent({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
    this.processed = false,
    this.processedAt,
    this.errorMessage,
  });

  WebhookEvent copyWith({
    String? id,
    WebhookEventType? type,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    bool? processed,
    DateTime? processedAt,
    String? errorMessage,
  }) {
    return WebhookEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      processed: processed ?? this.processed,
      processedAt: processedAt ?? this.processedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        data,
        createdAt,
        processed,
        processedAt,
        errorMessage,
      ];
}

/// Entidade para resposta de criação de pagamento
class PaymentIntent extends Equatable {
  final String id;
  final String customerId;
  final double amount;
  final String currency;
  final String status; // pending, processing, succeeded, failed, cancelled
  final String? paymentUrl; // URL para checkout
  final String? pixCode; // Código PIX se aplicável
  final String? boletoUrl; // URL do boleto se aplicável
  final DateTime createdAt;
  final DateTime? expiresAt;

  const PaymentIntent({
    required this.id,
    required this.customerId,
    required this.amount,
    this.currency = 'BRL',
    required this.status,
    this.paymentUrl,
    this.pixCode,
    this.boletoUrl,
    required this.createdAt,
    this.expiresAt,
  });

  bool get isPending => status == 'pending';
  bool get isSucceeded => status == 'succeeded';
  bool get isFailed => status == 'failed';
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  @override
  List<Object?> get props => [
        id,
        customerId,
        amount,
        currency,
        status,
        paymentUrl,
        pixCode,
        boletoUrl,
        createdAt,
        expiresAt,
      ];
}
