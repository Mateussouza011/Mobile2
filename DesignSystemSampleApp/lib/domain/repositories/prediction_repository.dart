import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/diamond_prediction.dart';

/// Interface do repositório de predições
abstract class PredictionRepository {
  /// Obtém predição de preço da API
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

  /// Salva predição no histórico local
  Future<Either<Failure, void>> savePredictionToHistory(
    DiamondPrediction prediction,
    int userId,
  );

  /// Obtém histórico de predições do usuário
  Future<Either<Failure, List<PredictionHistory>>> getPredictionHistory(int userId);

  /// Limpa histórico de predições
  Future<Either<Failure, void>> clearHistory(int userId);

  /// Deleta uma predição específica do histórico
  Future<Either<Failure, void>> deletePrediction(int predictionId);
}
