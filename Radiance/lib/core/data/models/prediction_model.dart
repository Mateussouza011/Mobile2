/// Modelo de histórico de predição de diamantes
class PredictionHistoryModel {
  final int? id;
  final int userId;
  final String? companyId; // Multi-tenant: ID da empresa
  final double carat;
  final String cut;
  final String color;
  final String clarity;
  final double depth;
  final double table;
  final double x;
  final double y;
  final double z;
  final double predictedPrice;
  final DateTime createdAt;

  const PredictionHistoryModel({
    this.id,
    required this.userId,
    this.companyId,
    required this.carat,
    required this.cut,
    required this.color,
    required this.clarity,
    required this.depth,
    required this.table,
    required this.x,
    required this.y,
    required this.z,
    required this.predictedPrice,
    required this.createdAt,
  });

  /// Cria uma instância a partir de um Map (do SQLite)
  factory PredictionHistoryModel.fromMap(Map<String, dynamic> map) {
    return PredictionHistoryModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      companyId: map['company_id'] as String?,
      carat: (map['carat'] as num).toDouble(),
      cut: map['cut'] as String,
      color: map['color'] as String,
      clarity: map['clarity'] as String,
      depth: (map['depth'] as num).toDouble(),
      table: (map['table_value'] as num).toDouble(),
      x: (map['x'] as num).toDouble(),
      y: (map['y'] as num).toDouble(),
      z: (map['z'] as num).toDouble(),
      predictedPrice: (map['predicted_price'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Converte para Map (para inserção no SQLite)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'company_id': companyId,
      'carat': carat,
      'cut': cut,
      'color': color,
      'clarity': clarity,
      'depth': depth,
      'table_value': table, // 'table' é palavra reservada no SQL
      'x': x,
      'y': y,
      'z': z,
      'predicted_price': predictedPrice,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Copia o modelo com novas propriedades
  PredictionHistoryModel copyWith({
    int? id,
    int? userId,
    String? companyId,
    double? carat,
    String? cut,
    String? color,
    String? clarity,
    double? depth,
    double? table,
    double? x,
    double? y,
    double? z,
    double? predictedPrice,
    DateTime? createdAt,
  }) {
    return PredictionHistoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
      carat: carat ?? this.carat,
      cut: cut ?? this.cut,
      color: color ?? this.color,
      clarity: clarity ?? this.clarity,
      depth: depth ?? this.depth,
      table: table ?? this.table,
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      predictedPrice: predictedPrice ?? this.predictedPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Retorna uma descrição resumida do diamante
  String get diamondSummary => '${carat}ct $cut $color $clarity';

  /// Formata o preço para exibição
  String get formattedPrice => '\$${predictedPrice.toStringAsFixed(2)}';

  @override
  String toString() {
    return 'PredictionHistoryModel(id: $id, diamondSummary: $diamondSummary, price: $formattedPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PredictionHistoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Modelo para requisição de predição à API
class PredictionRequest {
  final double carat;
  final String cut;
  final String color;
  final String clarity;
  final double depth;
  final double table;
  final double x;
  final double y;
  final double z;

  const PredictionRequest({
    required this.carat,
    required this.cut,
    required this.color,
    required this.clarity,
    required this.depth,
    required this.table,
    required this.x,
    required this.y,
    required this.z,
  });

  Map<String, dynamic> toJson() {
    return {
      'carat': carat,
      'cut': cut,
      'color': color,
      'clarity': clarity,
      'depth': depth,
      'table': table,
      'x': x,
      'y': y,
      'z': z,
    };
  }
}

/// Modelo de resposta da API de predição
class PredictionResponse {
  final double price;

  const PredictionResponse({required this.price});

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    // A API pode retornar 'price', 'predicted_price' ou 'prediction'
    final priceValue = json['price'] ?? json['predicted_price'] ?? json['prediction'];
    if (priceValue == null) {
      throw FormatException('Campo de preço não encontrado na resposta: $json');
    }
    return PredictionResponse(price: (priceValue as num).toDouble());
  }
}
