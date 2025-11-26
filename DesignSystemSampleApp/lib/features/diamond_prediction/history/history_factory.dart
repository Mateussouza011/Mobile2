import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'history_view_model.dart';
import 'history_view.dart';

/// HistoryFactory - Factory para criação da tela de Histórico
/// 
/// Implementa o Factory Pattern para criar e conectar:
/// ViewModel → View
class HistoryFactory {
  /// Cria uma instância completa da tela de Histórico via rota
  static Widget create(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryViewModel(
        delegate: _HistoryDelegateImpl(context),
      ),
      child: const HistoryView(),
    );
  }
}

/// Implementação do Delegate da History
class _HistoryDelegateImpl implements HistoryViewDelegate {
  final BuildContext context;
  
  _HistoryDelegateImpl(this.context);
  
  @override
  void onBackTapped() {
    context.pop();
  }
  
  @override
  void onPredictionTapped(HistoryItem item) {
    // TODO: Abrir detalhes da predição
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Predição: ${item.formatPrice}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  @override
  void onDeleteTapped(HistoryItem item) {
    // A exclusão é tratada no ViewModel
  }
  
  @override
  void onClearAllTapped() {
    // A limpeza é tratada no ViewModel
  }
}

extension on HistoryItem {
  String get formatPrice => '\$${predictedPrice.toStringAsFixed(2)}';
}
