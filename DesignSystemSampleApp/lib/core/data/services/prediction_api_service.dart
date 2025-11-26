import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';
import '../../constants/api_constants.dart';

/// Serviço para chamadas à API de predição de preços de diamantes
class PredictionApiService {
  final http.Client _client;

  PredictionApiService({http.Client? client}) 
      : _client = client ?? http.Client();

  /// Realiza a predição do preço do diamante
  Future<PredictionResult> predictPrice(PredictionRequest request) async {
    try {
      final url = Uri.parse(ApiConstants.predictUrl);
      final body = jsonEncode(request.toJson());
      
      debugPrint('[PredictionAPI] URL: $url');
      debugPrint('[PredictionAPI] Body: $body');
      
      final response = await _client.post(
        url,
        headers: ApiConstants.defaultHeaders,
        body: body,
      ).timeout(
        Duration(seconds: ApiConstants.defaultTimeout),
        onTimeout: () => throw PredictionException(
          'Tempo limite da requisição excedido. Verifique sua conexão.',
        ),
      );

      debugPrint('[PredictionAPI] Status: ${response.statusCode}');
      debugPrint('[PredictionAPI] Response: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          final predictionResponse = PredictionResponse.fromJson(json);
          return PredictionResult.success(predictionResponse.price);
        } catch (e) {
          debugPrint('[PredictionAPI] Parse error: $e');
          return PredictionResult.failure(
            'Erro ao processar resposta da API: ${e.toString()}',
          );
        }
      } else if (response.statusCode == 400) {
        return PredictionResult.failure(
          'Dados inválidos. Verifique os parâmetros informados.',
        );
      } else if (response.statusCode == 500) {
        return PredictionResult.failure(
          'Erro no servidor. Tente novamente mais tarde.',
        );
      } else {
        return PredictionResult.failure(
          'Erro na requisição (${response.statusCode}). Tente novamente.',
        );
      }
    } on PredictionException catch (e) {
      debugPrint('[PredictionAPI] PredictionException: ${e.message}');
      return PredictionResult.failure(e.message);
    } catch (e) {
      debugPrint('[PredictionAPI] Exception: $e');
      // Em web, erros de CORS aparecem como XMLHttpRequest error
      if (kIsWeb && e.toString().contains('XMLHttpRequest')) {
        return PredictionResult.failure(
          'Erro de CORS. A API não permite requisições do navegador. '
          'Tente executar o app em modo nativo ou use um proxy.',
        );
      }
      return PredictionResult.failure(
        'Erro de conexão. Verifique sua internet e tente novamente.',
      );
    }
  }

  /// Verifica se a API está disponível
  Future<bool> isApiAvailable() async {
    try {
      final url = Uri.parse(ApiConstants.baseUrl);
      final response = await _client.get(url).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode < 500;
    } catch (e) {
      return false;
    }
  }

  /// Fecha o cliente HTTP
  void dispose() {
    _client.close();
  }
}

/// Resultado da operação de predição
class PredictionResult {
  final bool isSuccess;
  final double? price;
  final String? errorMessage;

  const PredictionResult._({
    required this.isSuccess,
    this.price,
    this.errorMessage,
  });

  factory PredictionResult.success(double price) {
    return PredictionResult._(isSuccess: true, price: price);
  }

  factory PredictionResult.failure(String message) {
    return PredictionResult._(isSuccess: false, errorMessage: message);
  }
}

/// Exceção específica para erros de predição
class PredictionException implements Exception {
  final String message;
  
  const PredictionException(this.message);
  
  @override
  String toString() => 'PredictionException: $message';
}
