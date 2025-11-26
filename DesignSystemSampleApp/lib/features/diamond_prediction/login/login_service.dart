/// LoginService - Serviço de autenticação para o app Diamond Prediction
/// 
/// Responsável pela lógica de negócio relacionada à autenticação.
/// Em produção, este serviço faria chamadas HTTP para uma API de autenticação.
/// Atualmente simula login para demonstração.
class LoginService {
  /// Realiza o login do usuário
  /// 
  /// [email] - Email do usuário
  /// [password] - Senha do usuário
  /// 
  /// Retorna um Map com os dados do usuário em caso de sucesso.
  /// Lança uma Exception em caso de falha.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Simula delay de rede
    await Future.delayed(const Duration(seconds: 1));
    
    // Validações básicas
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email e senha são obrigatórios');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('Email inválido');
    }
    
    if (password.length < 6) {
      throw Exception('Senha deve ter no mínimo 6 caracteres');
    }
    
    // Simula autenticação bem-sucedida
    // Em produção, aqui seria feita uma chamada HTTP para API de auth
    return {
      'id': '1',
      'name': _extractNameFromEmail(email),
      'email': email,
      'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
    };
  }
  
  /// Valida formato do email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  /// Extrai nome do email para exibição
  String _extractNameFromEmail(String email) {
    final name = email.split('@').first;
    // Capitaliza primeira letra
    return name.isNotEmpty 
        ? name[0].toUpperCase() + name.substring(1)
        : 'Usuário';
  }
  
  /// Verifica se o usuário está logado
  /// Em produção, verificaria token armazenado localmente
  Future<bool> isLoggedIn() async {
    // Simula verificação - sempre retorna false para forçar login
    return false;
  }
  
  /// Realiza logout do usuário
  Future<void> logout() async {
    // Em produção, limparia tokens armazenados
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
