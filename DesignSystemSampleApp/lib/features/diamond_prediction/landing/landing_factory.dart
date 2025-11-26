import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'landing_view_model.dart';
import 'landing_view.dart';

/// Factory para criar a Landing Page
/// 
/// Responsável por montar a tela com todas as dependências
/// seguindo o padrão Factory + MVVM + Delegate.
class LandingFactory {
  /// Cria a Landing Page completa com ViewModel injetado
  static Widget create(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LandingViewModel(
        delegate: _LandingDelegateImpl(context),
      ),
      child: const LandingView(),
    );
  }
}

/// Implementação do Delegate da Landing
class _LandingDelegateImpl implements LandingDelegate {
  final BuildContext context;
  
  _LandingDelegateImpl(this.context);
  
  @override
  void onGetStartedTapped() {
    context.go('/diamond-login');
  }
  
  @override
  void onLearnMoreTapped() {
    // Pode abrir um modal ou navegar para uma página de informações
    _showInfoBottomSheet();
  }
  
  void _showInfoBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE4E4E7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(
              Icons.auto_awesome_outlined,
              size: 48,
              color: Color(0xFF18181B),
            ),
            const SizedBox(height: 16),
            const Text(
              'Como Funciona',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF18181B),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Nossa IA analisa as características do seu diamante '
              '(quilates, corte, cor, claridade e dimensões) para '
              'prever o preço de mercado com alta precisão.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF71717A),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF18181B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Entendi'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
