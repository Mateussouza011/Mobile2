import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/data/services/auth_service.dart';
import 'home_view_model.dart';
import 'home_view.dart';

/// HomeFactory - Factory para criação da tela Home/Dashboard
/// 
/// Implementa o Factory Pattern para criar e conectar:
/// ViewModel → View
class HomeFactory {
  /// Cria uma instância usando o usuário logado do AuthService
  static Widget create(BuildContext context) {
    final authService = AuthService.instance;
    final user = authService.currentUser;
    
    if (user == null) {
      // Se não há usuário logado, mostra erro
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Usuário não autenticado'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Voltar ao Login'),
              ),
            ],
          ),
        ),
      );
    }
    
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(
        delegate: _HomeDelegateImpl(context, user.fullName),
      ),
      child: const HomeView(),
    );
  }
}

/// Implementação do Delegate da Home
class _HomeDelegateImpl implements HomeViewDelegate {
  final BuildContext context;
  final String userName;
  
  _HomeDelegateImpl(this.context, this.userName);
  
  @override
  void onNewPredictionTapped() {
    context.push('/diamond-prediction');
  }
  
  @override
  void onHistoryTapped() {
    context.push('/diamond-history');
  }
  
  @override
  void onProfileTapped() {
    // TODO: Navegar para perfil
  }
  
  @override
  void onLogoutTapped() {
    AuthService.instance.logout();
    context.go('/');
  }
  
  @override
  void onRecentPredictionTapped(PredictionSummary prediction) {
    // TODO: Ver detalhes da predição
  }
}
