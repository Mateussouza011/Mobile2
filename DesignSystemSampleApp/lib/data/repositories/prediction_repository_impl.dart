import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/diamond_prediction.dart';
import '../../domain/repositories/prediction_repository.dart';
import '../datasources/local/prediction_local_datasource.dart';
import '../datasources/remote/prediction_remote_datasource.dart';
import '../models/diamond_prediction_model.dart';

/// Implementação do repositório de predições
class PredictionRepositoryImpl implements PredictionRepository {
  final PredictionRemoteDataSource remoteDataSource;
  final PredictionLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PredictionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final predictionModel = await remoteDataSource.getPrediction(
          carat: carat,
          cut: cut,
          color: color,
          clarity: clarity,
          depth: depth,
          table: table,
          x: x,
          y: y,
          z: z,
        );
        
        return Right(predictionModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ConnectionException catch (e) {
        return Left(ConnectionFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure('Erro inesperado: $e'));
      }
    } else {
      return const Left(ConnectionFailure('Sem conexão com a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> savePredictionToHistory(
    DiamondPrediction prediction,
    int userId,
  ) async {
    try {
      final model = DiamondPredictionModel.fromEntity(prediction);
      await localDataSource.savePrediction(model, userId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Erro ao salvar histórico: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PredictionHistory>>> getPredictionHistory(
    int userId,
  ) async {
    try {
      final historyModels = await localDataSource.getPredictionHistory(userId);
      final history = historyModels
          .map((model) => PredictionHistory(
                id: model.id,
                userId: model.userId,
                prediction: model.prediction.toEntity(),
              ))
          .toList();
      return Right(history);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Erro ao buscar histórico: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory(int userId) async {
    try {
      await localDataSource.clearHistory(userId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Erro ao limpar histórico: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePrediction(int predictionId) async {
    try {
      await localDataSource.deletePrediction(predictionId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Erro ao deletar predição: $e'));
    }
  }
}
