import '../../../application/app_coordinator.dart';
import '../../../core/constants/api_constants.dart';
import '../home/home_service.dart';
import 'prediction_service.dart';

/// PredictionDelegate - Interface para eventos da tela de predição
/// 
/// Implementa o Delegate Pattern para capturar eventos da View.
abstract class PredictionDelegate {
  /// Chamado quando o usuário solicita calcular o preço
  void onCalculateRequested({required PredictionViewModel sender});
  
  /// Chamado quando o usuário altera o valor do carat
  void onCaratChanged({required PredictionViewModel sender, required double value});
  
  /// Chamado quando o usuário altera o cut
  void onCutChanged({required PredictionViewModel sender, required String value});
  
  /// Chamado quando o usuário altera a cor
  void onColorChanged({required PredictionViewModel sender, required String value});
  
  /// Chamado quando o usuário altera a claridade
  void onClarityChanged({required PredictionViewModel sender, required String value});
  
  /// Chamado quando o usuário altera o depth
  void onDepthChanged({required PredictionViewModel sender, required double value});
  
  /// Chamado quando o usuário altera o table
  void onTableChanged({required PredictionViewModel sender, required double value});
  
  /// Chamado quando o usuário altera as dimensões
  void onDimensionsChanged({
    required PredictionViewModel sender,
    required double x,
    required double y,
    required double z,
  });
  
  /// Chamado quando o usuário quer voltar
  void onBackRequested({required PredictionViewModel sender});
  
  /// Chamado para limpar o formulário
  void onResetRequested({required PredictionViewModel sender});
}

/// PredictionViewModel - ViewModel para a tela de nova predição
/// 
/// Gerencia o estado do formulário e faz a chamada à API.
class PredictionViewModel implements PredictionDelegate {
  final PredictionService service;
  final AppCoordinator coordinator;
  final HomeService homeService;
  
  // Estado do formulário
  double _carat = 1.0;
  String _cut = 'Good';
  String _color = 'G';
  String _clarity = 'VS1';
  double _depth = 61.0;
  double _table = 57.0;
  double _x = 6.0;
  double _y = 6.0;
  double _z = 4.0;
  
  // Estado da UI
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _result;
  
  // Callback para atualização da UI
  void Function()? onStateChanged;
  
  PredictionViewModel({
    required this.service,
    required this.coordinator,
    required this.homeService,
  });
  
  // Getters para valores do formulário
  double get carat => _carat;
  String get cut => _cut;
  String get color => _color;
  String get clarity => _clarity;
  double get depth => _depth;
  double get table => _table;
  double get x => _x;
  double get y => _y;
  double get z => _z;
  
  // Getters para estado da UI
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get result => _result;
  bool get hasResult => _result != null;
  
  // Getters para opções dos dropdowns
  List<String> get cutOptions => ApiConstants.cutOptions;
  List<String> get colorOptions => ApiConstants.colorOptions;
  List<String> get clarityOptions => ApiConstants.clarityOptions;
  
  /// Realiza a predição de preço
  Future<void> calculatePrice() async {
    _isLoading = true;
    _errorMessage = null;
    _result = null;
    _notifyStateChanged();
    
    try {
      final result = await service.predictPrice(
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
      
      _result = result;
      _isLoading = false;
      
      // Adiciona ao histórico
      homeService.addPrediction({
        ...result,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      _notifyStateChanged();
      
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _notifyStateChanged();
    }
  }
  
  /// Reseta o formulário para valores padrão
  void resetForm() {
    _carat = 1.0;
    _cut = 'Good';
    _color = 'G';
    _clarity = 'VS1';
    _depth = 61.0;
    _table = 57.0;
    _x = 6.0;
    _y = 6.0;
    _z = 4.0;
    _result = null;
    _errorMessage = null;
    _notifyStateChanged();
  }
  
  // Implementação do PredictionDelegate
  
  @override
  void onCalculateRequested({required PredictionViewModel sender}) {
    calculatePrice();
  }
  
  @override
  void onCaratChanged({required PredictionViewModel sender, required double value}) {
    _carat = value;
    _notifyStateChanged();
  }
  
  @override
  void onCutChanged({required PredictionViewModel sender, required String value}) {
    _cut = value;
    _notifyStateChanged();
  }
  
  @override
  void onColorChanged({required PredictionViewModel sender, required String value}) {
    _color = value;
    _notifyStateChanged();
  }
  
  @override
  void onClarityChanged({required PredictionViewModel sender, required String value}) {
    _clarity = value;
    _notifyStateChanged();
  }
  
  @override
  void onDepthChanged({required PredictionViewModel sender, required double value}) {
    _depth = value;
    _notifyStateChanged();
  }
  
  @override
  void onTableChanged({required PredictionViewModel sender, required double value}) {
    _table = value;
    _notifyStateChanged();
  }
  
  @override
  void onDimensionsChanged({
    required PredictionViewModel sender,
    required double x,
    required double y,
    required double z,
  }) {
    _x = x;
    _y = y;
    _z = z;
    _notifyStateChanged();
  }
  
  @override
  void onBackRequested({required PredictionViewModel sender}) {
    coordinator.goBack();
  }
  
  @override
  void onResetRequested({required PredictionViewModel sender}) {
    resetForm();
  }
  
  void _notifyStateChanged() {
    onStateChanged?.call();
  }
  
  /// Formata preço para exibição
  String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }
  
  /// Limpa recursos
  void dispose() {
    onStateChanged = null;
    service.dispose();
  }
}
