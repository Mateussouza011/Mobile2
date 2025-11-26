import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'home_view_model_new.dart';
import 'home_view_new.dart';

/// Factory para criar a Home/Dashboard
/// 
/// Responsável por montar a tela com todas as dependências
/// seguindo o padrão Factory + MVVM + Delegate.
class HomeFactory {
  /// Cria a Home completa com ViewModel injetado
  static Widget create(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(
        delegate: _HomeDelegateImpl(context),
      ),
      child: const HomeView(),
    );
  }
}

/// Implementação do Delegate da Home
class _HomeDelegateImpl implements HomeViewDelegate {
  final BuildContext context;
  
  _HomeDelegateImpl(this.context);
  
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
    // Futuro: abrir perfil
  }
  
  @override
  void onLogoutTapped() {
    _showLogoutConfirmation();
  }
  
  @override
  void onRecentPredictionTapped(PredictionSummary prediction) {
    // Futuro: abrir detalhes da predição
    _showPredictionDetails(prediction);
  }
  
  void _showLogoutConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
              Icons.logout_rounded,
              size: 48,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sair da conta',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF18181B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tem certeza que deseja sair?',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF71717A),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE4E4E7)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Color(0xFF71717A)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.go('/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Sair'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  void _showPredictionDetails(PredictionSummary prediction) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.diamond_outlined,
                size: 32,
                color: Color(0xFF18181B),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '\$${prediction.predictedPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF18181B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${prediction.carat} quilates • ${prediction.cut}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF71717A),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF18181B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Fechar'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
