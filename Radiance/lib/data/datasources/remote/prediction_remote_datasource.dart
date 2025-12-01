import '../../../core/errors/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../models/diamond_prediction_model.dart';
import 'api_endpoints.dart';
abstract class PredictionRemoteDataSource {
  Future<DiamondPredictionModel> getPrediction({
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
}
class PredictionRemoteDataSourceImpl implements PredictionRemoteDataSource {
  final ApiClient apiClient;

  PredictionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DiamondPredictionModel> getPrediction({
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
    final requestData = {
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

    try {
      final response = await apiClient.post(
        ApiEndpoints.predict,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DiamondPredictionModel.fromApiResponse(
          response.data as Map<String, dynamic>,
          requestData,
        );
      } else {
        throw ServerException(
          'Erro ao obter predição',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is ConnectionException) {
        rethrow;
      }
      throw ServerException('Erro ao processar resposta: $e');
    }
  }
}
