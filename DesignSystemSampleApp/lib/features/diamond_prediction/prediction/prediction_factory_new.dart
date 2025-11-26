import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'prediction_view_model_new.dart';
import 'prediction_view_new.dart';

/// Factory para criar a tela de Prediction
/// 
/// Responsável por montar a tela com todas as dependências
/// seguindo o padrão Factory + MVVM + Delegate.
class PredictionFactory {
  /// Cria a tela de Prediction completa com ViewModel injetado
  static Widget create(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PredictionViewModel(
        delegate: _PredictionDelegateImpl(context),
      ),
      child: const PredictionView(),
    );
  }
}

/// Implementação do Delegate da Prediction
class _PredictionDelegateImpl implements PredictionViewDelegate {
  final BuildContext context;
  
  _PredictionDelegateImpl(this.context);
  
  @override
  void onPredictionSuccess(double price, Map<String, dynamic> details) {
    // Feedback tátil
    // HapticFeedback.mediumImpact();
    
    // Mostra snackbar de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text('Predição realizada com sucesso!'),
          ],
        ),
        backgroundColor: const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  @override
  void onPredictionError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  @override
  void onBackTapped() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/diamond-home');
    }
  }
}
