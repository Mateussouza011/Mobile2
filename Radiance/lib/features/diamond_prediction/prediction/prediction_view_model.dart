import 'package:flutter/foundation.dart';
import '../../../core/data/models/prediction_model.dart';

class PredictionViewModel extends ChangeNotifier {
  double _carat = 1.0;
  String? _cut;
  String? _color;
  String? _clarity;
  double _depth = 61.5;
  double _table = 57.0;
  double _x = 5.0;
  double _y = 5.0;
  double _z = 3.0;
  bool _isLoading = false;
  String? _errorMessage;
  PredictionResponse? _result;
  bool _showResult = false;
  double get carat => _carat;
  String? get cut => _cut;
  String? get color => _color;
  String? get clarity => _clarity;
  double get depth => _depth;
  double get table => _table;
  double get x => _x;
  double get y => _y;
  double get z => _z;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PredictionResponse? get result => _result;
  bool get showResult => _showResult;
  
  static const List<String> cutOptions = ['Ideal', 'Premium', 'Very Good', 'Good', 'Fair'];
  
  static const List<String> colorOptions = ['D', 'E', 'F', 'G', 'H', 'I', 'J'];
  
  static const List<String> clarityOptions = ['IF', 'VVS1', 'VVS2', 'VS1', 'VS2', 'SI1', 'SI2', 'I1'];
  
  void setCarat(double value) {
    _carat = value;
    notifyListeners();
  }

  void setCut(String? value) {
    _cut = value;
    notifyListeners();
  }

  void setColor(String? value) {
    _color = value;
    notifyListeners();
  }

  void setClarity(String? value) {
    _clarity = value;
    notifyListeners();
  }

  void setDepth(double value) {
    _depth = value;
    notifyListeners();
  }

  void setTable(double value) {
    _table = value;
    notifyListeners();
  }

  void setX(double value) {
    _x = value;
    notifyListeners();
  }

  void setY(double value) {
    _y = value;
    notifyListeners();
  }

  void setZ(double value) {
    _z = value;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void setResult(PredictionResponse? result) {
    _result = result;
    _showResult = result != null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearResult() {
    _result = null;
    _showResult = false;
    notifyListeners();
  }

  void reset() {
    _carat = 1.0;
    _cut = null;
    _color = null;
    _clarity = null;
    _depth = 61.5;
    _table = 57.0;
    _x = 5.0;
    _y = 5.0;
    _z = 3.0;
    _isLoading = false;
    _errorMessage = null;
    _result = null;
    _showResult = false;
    notifyListeners();
  }
  
  bool get isFormValid => _cut != null && _color != null && _clarity != null;

  PredictionRequest? buildRequest() {
    if (_cut == null || _color == null || _clarity == null) {
      return null;
    }
    return PredictionRequest(
      carat: _carat,
      cut: _cut!,
      color: _color!,
      clarity: _clarity!,
      depth: _depth,
      table: _table,
      x: _x,
      y: _y,
      z: _z,
    );
  }
}
