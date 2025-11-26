import '../../../application/app_coordinator.dart';
import 'login_service.dart';

/// LoginDelegate - Interface para eventos do componente Login
/// 
/// Implementa o Delegate Pattern para capturar eventos da View
/// sem usar callbacks diretamente. Todos os eventos interativos
/// passam por esta interface.
abstract class LoginDelegate {
  /// Chamado quando o usuário solicita login
  void onLoginRequested({
    required LoginViewModel sender,
    required String email,
    required String password,
  });
  
  /// Chamado quando há mudança no campo de email
  void onEmailChanged({
    required LoginViewModel sender,
    required String email,
  });
  
  /// Chamado quando há mudança no campo de senha
  void onPasswordChanged({
    required LoginViewModel sender,
    required String password,
  });
}

/// LoginViewModel - ViewModel para a tela de Login
/// 
/// Contém a lógica de apresentação e gerencia o estado da tela.
/// Implementa LoginDelegate para responder aos eventos da View.
class LoginViewModel implements LoginDelegate {
  final LoginService service;
  final AppCoordinator coordinator;
  
  // Estado atual
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  
  // Callbacks para atualização da UI
  void Function()? onStateChanged;
  
  LoginViewModel({
    required this.service,
    required this.coordinator,
  });
  
  // Getters
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get canSubmit => _email.isNotEmpty && _password.isNotEmpty && !_isLoading;
  
  /// Realiza o login
  Future<void> performLogin() async {
    if (!canSubmit) return;
    
    _isLoading = true;
    _errorMessage = null;
    _notifyStateChanged();
    
    try {
      final result = await service.login(
        email: _email,
        password: _password,
      );
      
      _isLoading = false;
      _notifyStateChanged();
      
      // Navega para Home com os dados do usuário
      coordinator.goToHome(
        name: result['name'] as String,
        email: result['email'] as String,
      );
      
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _notifyStateChanged();
    }
  }
  
  // Implementação do LoginDelegate
  
  @override
  void onLoginRequested({
    required LoginViewModel sender,
    required String email,
    required String password,
  }) {
    performLogin();
  }
  
  @override
  void onEmailChanged({
    required LoginViewModel sender,
    required String email,
  }) {
    _email = email;
    _errorMessage = null;
    _notifyStateChanged();
  }
  
  @override
  void onPasswordChanged({
    required LoginViewModel sender,
    required String password,
  }) {
    _password = password;
    _errorMessage = null;
    _notifyStateChanged();
  }
  
  void _notifyStateChanged() {
    onStateChanged?.call();
  }
  
  /// Limpa o estado do ViewModel
  void dispose() {
    onStateChanged = null;
  }
}
