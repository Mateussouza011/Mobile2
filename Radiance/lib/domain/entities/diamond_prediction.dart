import 'package:equatable/equatable.dart';
class DiamondPrediction extends Equatable {
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

  const DiamondPrediction({
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
  String get diamondSummary => '${carat}ct $cut $color $clarity';
  String get formattedPrice => '\$${predictedPrice.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [
        carat,
        cut,
        color,
        clarity,
        depth,
        table,
        x,
        y,
        z,
        predictedPrice,
        timestamp,
      ];
}
class PredictionHistory extends Equatable {
  final int id;
  final int userId;
  final DiamondPrediction prediction;

  const PredictionHistory({
    required this.id,
    required this.userId,
    required this.prediction,
  });

  @override
  List<Object?> get props => [id, userId, prediction];
}
