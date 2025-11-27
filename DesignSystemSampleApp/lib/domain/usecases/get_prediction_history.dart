import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/diamond_prediction.dart';
import '../repositories/prediction_repository.dart';

/// Use case para obter histórico de predições
class GetPredictionHistoryUseCase {
  final PredictionRepository repository;

  GetPredictionHistoryUseCase(this.repository);

  Future<Either<Failure, List<PredictionHistory>>> call(int userId) async {
    return await repository.getPredictionHistory(userId);
  }
}
