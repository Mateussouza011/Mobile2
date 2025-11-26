import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';

/// PredictionService - Serviço para chamadas à API de predição de diamantes
/// 
/// Responsável por fazer requisições HTTP para a API FastAPI
/// que contém os modelos de machine learning treinados.
/// 
/// Em modo de desenvolvimento (web), usa simulação local.
class PredictionService {
  final http.Client _client;
  final String _baseUrl;
  final bool _useSimulation;
  
  PredictionService({
    http.Client? client,
    String? baseUrl,
    bool? useSimulation,
  }) : _client = client ?? http.Client(),
       _baseUrl = baseUrl ?? ApiConstants.baseUrl,
       _useSimulation = useSimulation ?? kIsWeb; // Simula por padrão na web
  
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
    // Usa simulação na web ou quando a API não está disponível
    if (_useSimulation) {
      return _simulatePrediction(
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
    }
    
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
  
  /// Simula a predição de preço localmente (para web ou quando API não está disponível)
  Map<String, dynamic> _simulatePrediction({
    required double carat,
    required String cut,
    required String color,
    required String clarity,
    required double depth,
    required double table,
    required double x,
    required double y,
    required double z,
  }) {
    // Valores base por qualidade de corte
    final cutMultiplier = {
      'Fair': 0.8,
      'Good': 0.9,
      'Very Good': 1.0,
      'Premium': 1.1,
      'Ideal': 1.2,
    };
    
    // Valores base por cor (D é a melhor, J é a pior)
    final colorMultiplier = {
      'D': 1.4,
      'E': 1.3,
      'F': 1.2,
      'G': 1.1,
      'H': 1.0,
      'I': 0.9,
      'J': 0.8,
    };
    
    // Valores base por claridade
    final clarityMultiplier = {
      'IF': 1.5,    // Internally Flawless
      'VVS1': 1.4,
      'VVS2': 1.3,
      'VS1': 1.2,
      'VS2': 1.1,
      'SI1': 1.0,
      'SI2': 0.9,
      'I1': 0.7,
    };
    
    // Preço base por quilate (aproximação do mercado)
    const basePrice = 3500.0;
    
    // Calcula o preço usando uma fórmula de aproximação
    final cutMult = cutMultiplier[cut] ?? 1.0;
    final colorMult = colorMultiplier[color] ?? 1.0;
    final clarityMult = clarityMultiplier[clarity] ?? 1.0;
    
    // Volume aproximado do diamante
    final volume = x * y * z;
    final volumeFactor = volume > 0 ? (volume / 100).clamp(0.5, 2.0) : 1.0;
    
    // Fator de profundidade/tabela (valores ideais são ~60% depth e ~55% table)
    final depthFactor = 1.0 - (depth - 61.5).abs() * 0.01;
    final tableFactor = 1.0 - (table - 57).abs() * 0.01;
    
    // Adiciona variação aleatória de ±5% para simular diferenças entre modelos
    final random = Random();
    final variance = 0.95 + random.nextDouble() * 0.1;
    
    // Cálculo final do preço
    final predictedPrice = basePrice * 
        carat * carat *  // Preço cresce exponencialmente com quilates
        cutMult * 
        colorMult * 
        clarityMult * 
        volumeFactor *
        depthFactor.clamp(0.8, 1.1) *
        tableFactor.clamp(0.8, 1.1) *
        variance;
    
    // Simula preços de diferentes "modelos"
    final randomForest = predictedPrice * (0.98 + random.nextDouble() * 0.04);
    final gradientBoosting = predictedPrice * (0.97 + random.nextDouble() * 0.06);
    final neuralNetwork = predictedPrice * (0.96 + random.nextDouble() * 0.08);
    
    return {
      'predicted_price': predictedPrice.roundToDouble(),
      'simulated': true,
      'details': {
        'random_forest': {
          'prediction': randomForest.roundToDouble(),
          'weight': 0.4,
        },
        'gradient_boosting': {
          'prediction': gradientBoosting.roundToDouble(),
          'weight': 0.35,
        },
        'neural_network': {
          'prediction': neuralNetwork.roundToDouble(),
          'weight': 0.25,
        },
      },
      'input': {
        'carat': carat,
        'cut': cut,
        'color': color,
        'clarity': clarity,
        'depth': depth,
        'table': table,
        'x': x,
        'y': y,
        'z': z,
      },
    };
  }

  /// Verifica se a API está online
  Future<bool> checkApiHealth() async {
    // Na simulação, retorna true
    if (_useSimulation) return true;
    
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
