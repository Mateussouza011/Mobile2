import 'package:flutter/foundation.dart';
import '../../../domain/entities/diamond_prediction.dart';
import '../../../domain/usecases/get_prediction.dart';
import '../../../domain/usecases/get_prediction_history.dart';
import '../../../domain/usecases/save_prediction.dart';

/// Estados possíveis do ViewModel
enum PredictionState {
  initial,
  loading,
  success,
  error,
}

/// ViewModel para gerenciar predições de diamantes
class DiamondPredictionViewModel extends ChangeNotifier {
  final GetPredictionUseCase getPredictionUseCase;
  final SavePredictionUseCase savePredictionUseCase;
  final GetPredictionHistoryUseCase getPredictionHistoryUseCase;

  DiamondPredictionViewModel({
    required this.getPredictionUseCase,
    required this.savePredictionUseCase,
    required this.getPredictionHistoryUseCase,
  });

  // Estado
  PredictionState _state = PredictionState.initial;
  DiamondPrediction? _currentPrediction;
  List<PredictionHistory> _history = [];
  String? _errorMessage;
  
  // Dados do formulário
  double _carat = 1.0;
  String _cut = 'Ideal';
  String _color = 'D';
  String _clarity = 'IF';
  double _depth = 61.5;
  double _table = 57.0;
  double _x = 5.0;
  double _y = 5.0;
  double _z = 3.0;

  // Getters
  PredictionState get state => _state;
  DiamondPrediction? get currentPrediction => _currentPrediction;
  List<PredictionHistory> get history => _history;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == PredictionState.loading;
  bool get hasError => _state == PredictionState.error;
  bool get hasResult => _currentPrediction != null;
  
  // Form getters
  double get carat => _carat;
  String get cut => _cut;
  String get color => _color;
  String get clarity => _clarity;
  double get depth => _depth;
  double get table => _table;
  double get x => _x;
  double get y => _y;
  double get z => _z;

  // Setters do formulário
  void setCarat(double value) {
    _carat = value;
    notifyListeners();
  }

  void setCut(String value) {
    _cut = value;
    notifyListeners();
  }

  void setColor(String value) {
    _color = value;
    notifyListeners();
  }

  void setClarity(String value) {
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

  /// Obtém predição de preço
  Future<void> predict() async {
    _state = PredictionState.loading;
    _errorMessage = null;
    _currentPrediction = null;
    notifyListeners();

    final params = PredictionParams(
      carat: _carat,
      cut: _cut,
      color: _color,
      clarity: _clarity,
      depth: _depth,
      table: _table,
      x: _x,
      y: _y,
      z: _z,
    );

    final result = await getPredictionUseCase(params);

    result.fold(
      (failure) {
        _state = PredictionState.error;
        _errorMessage = failure.message;
        debugPrint('❌ Erro na predição: ${failure.message}');
        debugPrint('❌ Tipo de falha: ${failure.runtimeType}');
        notifyListeners();
      },
      (prediction) {
        _state = PredictionState.success;
        _currentPrediction = prediction;
        debugPrint('✅ Predição realizada: \$${prediction.predictedPrice}');
        notifyListeners();
        
        // Salva automaticamente no histórico
        _saveToHistory(prediction);
      },
    );
  }

  /// Salva predição no histórico
  Future<void> _saveToHistory(DiamondPrediction prediction) async {
    const userId = 1; // TODO: Implementar sistema de autenticação
    await savePredictionUseCase(prediction, userId);
    await loadHistory(); // Recarrega histórico
  }

  /// Carrega histórico de predições
  Future<void> loadHistory() async {
    const userId = 1; // TODO: Implementar sistema de autenticação
    
    final result = await getPredictionHistoryUseCase(userId);
    
    result.fold(
      (failure) {
        // Erro ao carregar histórico não bloqueia a aplicação
        debugPrint('Erro ao carregar histórico: ${failure.message}');
      },
      (history) {
        _history = history;
        notifyListeners();
      },
    );
  }

  /// Limpa resultado atual
  void clearResult() {
    _currentPrediction = null;
    _state = PredictionState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  /// Reseta formulário para valores padrão
  void resetForm() {
    _carat = 1.0;
    _cut = 'Ideal';
    _color = 'D';
    _clarity = 'IF';
    _depth = 61.5;
    _table = 57.0;
    _x = 5.0;
    _y = 5.0;
    _z = 3.0;
    clearResult();
  }

  /// Carrega dados de uma predição anterior
  void loadFromHistory(PredictionHistory historyItem) {
    final prediction = historyItem.prediction;
    _carat = prediction.carat;
    _cut = prediction.cut;
    _color = prediction.color;
    _clarity = prediction.clarity;
    _depth = prediction.depth;
    _table = prediction.table;
    _x = prediction.x;
    _y = prediction.y;
    _z = prediction.z;
    _currentPrediction = prediction;
    _state = PredictionState.success;
    notifyListeners();
  }
}
