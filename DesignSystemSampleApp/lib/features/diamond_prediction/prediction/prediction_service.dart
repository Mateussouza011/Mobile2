import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';

/// PredictionService - Serviço para chamadas à API de predição de diamantes
/// 
/// Responsável por fazer requisições HTTP para a API FastAPI
/// que contém os modelos de machine learning treinados.
class PredictionService {
  final http.Client _client;
  final String _baseUrl;
  
  PredictionService({
    http.Client? client,
    String? baseUrl,
  }) : _client = client ?? http.Client(),
       _baseUrl = baseUrl ?? ApiConstants.baseUrl;
  
  /// Realiza a predição de preço do diamante
  /// 
  /// Parâmetros:
  /// - [carat] - Peso do diamante em quilates
  /// - [cut] - Qualidade do corte (Fair, Good, Very Good, Premium, Ideal)
  /// - [color] - Cor do diamante (D, E, F, G, H, I, J)
  /// - [clarity] - Claridade (I1, SI2, SI1, VS2, VS1, VVS2, VVS1, IF)
  /// - [depth] - Profundidade total percentual
  /// - [table] - Largura do topo percentual
  /// - [x] - Comprimento em mm
  /// - [y] - Largura em mm
  /// - [z] - Profundidade em mm
  /// 
  /// Retorna um Map contendo:
  /// - predicted_price: preço estimado
  /// - details: detalhes dos modelos
  /// - input: dados de entrada enviados
  Future<Map<String, dynamic>> predictPrice({
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
    final url = Uri.parse('$_baseUrl${ApiConstants.predictEndpoint}');
    
    // Prepara o payload conforme contrato da API
    final payload = {
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
      final response = await _client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(
            const Duration(seconds: ApiConstants.requestTimeout),
            onTimeout: () {
              throw Exception('Timeout: A API não respondeu a tempo');
            },
          );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else if (response.statusCode == 503) {
        throw Exception('Serviço indisponível: Os modelos não estão carregados');
      } else {
        final errorData = jsonDecode(response.body);
        final detail = errorData['detail'] ?? 'Erro desconhecido';
        throw Exception('Erro na API ($response.statusCode): $detail');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Erro de conexão: Verifique se a API está rodando em $_baseUrl');
    }
  }
  
  /// Verifica se a API está online
  Future<bool> checkApiHealth() async {
    try {
      final url = Uri.parse('$_baseUrl${ApiConstants.healthEndpoint}');
      final response = await _client.get(url).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  /// Libera recursos do cliente HTTP
  void dispose() {
    _client.close();
  }
}
