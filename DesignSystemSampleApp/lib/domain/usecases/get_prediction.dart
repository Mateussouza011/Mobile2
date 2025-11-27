import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/diamond_prediction.dart';
import '../repositories/prediction_repository.dart';

/// Use case para obter predição de preço
class GetPredictionUseCase {
  final PredictionRepository repository;

  GetPredictionUseCase(this.repository);

  Future<Either<Failure, DiamondPrediction>> call(PredictionParams params) async {
    // Validações
    final validation = _validate(params);
    if (validation != null) {
      return Left(ValidationFailure(validation));
    }

    return await repository.getPrediction(
      carat: params.carat,
      cut: params.cut,
      color: params.color,
      clarity: params.clarity,
      depth: params.depth,
      table: params.table,
      x: params.x,
      y: params.y,
      z: params.z,
    );
  }

  String? _validate(PredictionParams params) {
    if (params.carat <= 0) return 'Quilates deve ser maior que 0';
    if (params.depth <= 0 || params.depth > 100) return 'Profundidade inválida';
    if (params.table <= 0 || params.table > 100) return 'Mesa inválida';
    if (params.x <= 0 || params.y <= 0 || params.z <= 0) {
      return 'Dimensões devem ser maiores que 0';
    }
    if (params.cut.isEmpty) return 'Corte é obrigatório';
    if (params.color.isEmpty) return 'Cor é obrigatória';
    if (params.clarity.isEmpty) return 'Claridade é obrigatória';
    return null;
  }
}

/// Parâmetros para predição
class PredictionParams {
  final double carat;
  final String cut;
  final String color;
  final String clarity;
  final double depth;
  final double table;
  final double x;
  final double y;
  final double z;

  const PredictionParams({
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
}
