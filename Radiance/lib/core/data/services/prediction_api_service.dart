import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';
import '../../constants/api_constants.dart';
class PredictionApiService {
  final http.Client _client;

  PredictionApiService({http.Client? client}) 
      : _client = client ?? http.Client();
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
        const Duration(seconds: ApiConstants.defaultTimeout),
        onTimeout: () => throw const PredictionException(
          'Request timeout. Check your connection.',
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
            'Error processing API response: ${e.toString()}',
          );
        }
      } else if (response.statusCode == 400) {
        return PredictionResult.failure(
          'Invalid data. Check the parameters provided.',
        );
      } else if (response.statusCode == 500) {
        return PredictionResult.failure(
          'Server error. Try again later.',
        );
      } else {
        return PredictionResult.failure(
          'Request error (${response.statusCode}). Try again.',
        );
      }
    } on PredictionException catch (e) {
      debugPrint('[PredictionAPI] PredictionException: ${e.message}');
      return PredictionResult.failure(e.message);
    } catch (e) {
      debugPrint('[PredictionAPI] Exception: $e');
      if (kIsWeb && e.toString().contains('XMLHttpRequest')) {
        return PredictionResult.failure(
          'CORS error. The API does not allow browser requests. '
          'Try running the app in native mode or use a proxy.',
        );
      }
      return PredictionResult.failure(
        'Connection error. Check your internet and try again.',
      );
    }
  }
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
  void dispose() {
    _client.close();
  }
}
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
class PredictionException implements Exception {
  final String message;
  
  const PredictionException(this.message);
  
  @override
  String toString() => 'PredictionException: $message';
}
