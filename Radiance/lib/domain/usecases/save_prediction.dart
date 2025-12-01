import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/diamond_prediction.dart';
import '../repositories/prediction_repository.dart';
class SavePredictionUseCase {
  final PredictionRepository repository;

  SavePredictionUseCase(this.repository);

  Future<Either<Failure, void>> call(
    DiamondPrediction prediction,
    int userId,
  ) async {
    return await repository.savePredictionToHistory(prediction, userId);
  }
}
