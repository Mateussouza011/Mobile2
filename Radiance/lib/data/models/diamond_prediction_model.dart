import '../../../domain/entities/diamond_prediction.dart';
class DiamondPredictionModel {
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
  final DateTime timestamp;

  const DiamondPredictionModel({
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
    required this.timestamp,
  });
  factory DiamondPredictionModel.fromEntity(DiamondPrediction entity) {
    return DiamondPredictionModel(
      carat: entity.carat,
      cut: entity.cut,
      color: entity.color,
      clarity: entity.clarity,
      depth: entity.depth,
      table: entity.table,
      x: entity.x,
      y: entity.y,
      z: entity.z,
      predictedPrice: entity.predictedPrice,
      timestamp: entity.timestamp,
    );
  }
  DiamondPrediction toEntity() {
    return DiamondPrediction(
      carat: carat,
      cut: cut,
      color: color,
      clarity: clarity,
      depth: depth,
      table: table,
      x: x,
      y: y,
      z: z,
      predictedPrice: predictedPrice,
      timestamp: timestamp,
    );
  }
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
  factory DiamondPredictionModel.fromApiResponse(
    Map<String, dynamic> json,
    Map<String, dynamic> requestData,
  ) {
    final price = (json['price'] ?? json['predicted_price'] ?? json['prediction']) as num;
    
    return DiamondPredictionModel(
      carat: (requestData['carat'] as num).toDouble(),
      cut: requestData['cut'] as String,
      color: requestData['color'] as String,
      clarity: requestData['clarity'] as String,
      depth: (requestData['depth'] as num).toDouble(),
      table: (requestData['table'] as num).toDouble(),
      x: (requestData['x'] as num).toDouble(),
      y: (requestData['y'] as num).toDouble(),
      z: (requestData['z'] as num).toDouble(),
      predictedPrice: price.toDouble(),
      timestamp: DateTime.now(),
    );
  }
  factory DiamondPredictionModel.fromMap(Map<String, dynamic> map) {
    return DiamondPredictionModel(
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
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'carat': carat,
      'cut': cut,
      'color': color,
      'clarity': clarity,
      'depth': depth,
      'table_value': table, 
      'x': x,
      'y': y,
      'z': z,
      'predicted_price': predictedPrice,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
class PredictionHistoryModel {
  final int id;
  final int userId;
  final DiamondPredictionModel prediction;

  const PredictionHistoryModel({
    required this.id,
    required this.userId,
    required this.prediction,
  });

  factory PredictionHistoryModel.fromMap(Map<String, dynamic> map) {
    return PredictionHistoryModel(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      prediction: DiamondPredictionModel.fromMap(map),
    );
  }

  Map<String, dynamic> toMap() {
    final predictionMap = prediction.toMap();
    return {
      if (id != 0) 'id': id,
      'user_id': userId,
      ...predictionMap,
    };
  }
}
