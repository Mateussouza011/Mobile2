import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';

/// Delegate para a tela de Prediction
abstract class PredictionViewDelegate {
  void onPredictionSuccess(double price, Map<String, dynamic> details);
  void onPredictionError(String message);
  void onBackTapped();
}

/// ViewModel para a tela de Prediction
/// 
/// Gerencia estado e lógica da predição seguindo MVVM + Delegate
class PredictionViewModel extends ChangeNotifier {
  final PredictionViewDelegate delegate;
  
  PredictionViewModel({required this.delegate});
  
  // Estado
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool _hasResult = false;
  bool get hasResult => _hasResult;
  
  double? _predictedPrice;
  double? get predictedPrice => _predictedPrice;
  
  Map<String, dynamic>? _predictionDetails;
  Map<String, dynamic>? get predictionDetails => _predictionDetails;
  
  // Valores dos campos
  double _carat = 1.0;
  double get carat => _carat;
  
  int _cutIndex = 4; // Ideal
  int get cutIndex => _cutIndex;
  String get cut => ApiConstants.cutOptions[_cutIndex];
  
  int _colorIndex = 0; // D
  int get colorIndex => _colorIndex;
  String get color => ApiConstants.colorOptions[_colorIndex];
  
  int _clarityIndex = 7; // IF
  int get clarityIndex => _clarityIndex;
  String get clarity => ApiConstants.clarityOptions[_clarityIndex];
  
  double _depth = 61.5;
  double get depth => _depth;
  
  double _table = 57.0;
  double get table => _table;
  
  double _x = 5.0;
  double get x => _x;
  
  double _y = 5.0;
  double get y => _y;
  
  double _z = 3.0;
  double get z => _z;
  
  // Atualiza valores
  void updateCarat(double value) {
    _carat = value;
    _clearResult();
    notifyListeners();
  }
  
  void updateCut(int index) {
    _cutIndex = index;
    _clearResult();
    notifyListeners();
  }
  
  void updateColor(int index) {
    _colorIndex = index;
    _clearResult();
    notifyListeners();
  }
  
  void updateClarity(int index) {
    _clarityIndex = index;
    _clearResult();
    notifyListeners();
  }
  
  void updateDepth(double value) {
    _depth = value;
    _clearResult();
    notifyListeners();
  }
  
  void updateTable(double value) {
    _table = value;
    _clearResult();
    notifyListeners();
  }
  
  void updateX(double value) {
    _x = value;
    _clearResult();
    notifyListeners();
  }
  
  void updateY(double value) {
    _y = value;
    _clearResult();
    notifyListeners();
  }
  
  void updateZ(double value) {
    _z = value;
    _clearResult();
    notifyListeners();
  }
  
  void _clearResult() {
    _hasResult = false;
    _predictedPrice = null;
    _predictionDetails = null;
  }
  
  /// Executa a predição
  Future<void> predict() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.predictEndpoint}');
      
      final payload = {
        'carat': _carat,
        'cut': cut,
        'color': color,
        'clarity': clarity,
        'depth': _depth,
        'table': _table,
        'x': _x,
        'y': _y,
        'z': _z,
      };
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      ).timeout(
        const Duration(seconds: ApiConstants.requestTimeout),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _predictedPrice = (data['predicted_price'] as num).toDouble();
        _predictionDetails = data['details'] as Map<String, dynamic>?;
        _hasResult = true;
        delegate.onPredictionSuccess(_predictedPrice!, data);
      } else {
        final errorData = jsonDecode(response.body);
        final detail = errorData['detail'] ?? 'Erro desconhecido';
        delegate.onPredictionError('Erro: $detail');
      }
    } catch (e) {
      delegate.onPredictionError('Erro de conexão. Verifique se a API está rodando.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Volta para a tela anterior
  void goBack() {
    delegate.onBackTapped();
  }
  
  /// Reseta para nova predição
  void reset() {
    _carat = 1.0;
    _cutIndex = 4;
    _colorIndex = 0;
    _clarityIndex = 7;
    _depth = 61.5;
    _table = 57.0;
    _x = 5.0;
    _y = 5.0;
    _z = 3.0;
    _clearResult();
    notifyListeners();
  }
  
  /// Formata preço
  String formatPrice(double value) {
    return '\$${value.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    )}';
  }
}
