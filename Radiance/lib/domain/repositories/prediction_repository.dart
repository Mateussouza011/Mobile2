import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/diamond_prediction.dart';
abstract class PredictionRepository {
  Future<Either<Failure, DiamondPrediction>> getPrediction({
    required double carat,
    required String cut,
    required String color,
    required String clarity,
    required double depth,
    required double table,
    required double x,
    required double y,
    required double z,
  });
  Future<Either<Failure, void>> savePredictionToHistory(
    DiamondPrediction prediction,
    int userId,
  );
  Future<Either<Failure, List<PredictionHistory>>> getPredictionHistory(int userId);
  Future<Either<Failure, void>> clearHistory(int userId);
  Future<Either<Failure, void>> deletePrediction(int predictionId);
}
