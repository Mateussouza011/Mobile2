import 'package:flutter/material.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import 'history_view_model.dart';

/// HistoryView - Tela de histórico de predições
/// 
/// Exibe uma lista de todas as predições realizadas.
class HistoryView extends StatefulWidget {
  final HistoryViewModel viewModel;
  
  const HistoryView({
    super.key,
    required this.viewModel,
  });
  
  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.onStateChanged = () {
      if (mounted) {
        setState(() {});
      }
    };
    // Carrega histórico ao iniciar
    widget.viewModel.loadHistory();
  }
  
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.viewModel.onBackRequested(
            sender: widget.viewModel,
          ),
        ),
        actions: [
          if (!widget.viewModel.isEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearConfirmation(context),
              tooltip: 'Limpar histórico',
            ),
        ],
      ),
      body: _buildBody(context),
    );
  }
  
  Widget _buildBody(BuildContext context) {
    final viewModel = widget.viewModel;
    
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (viewModel.isEmpty) {
      return _buildEmptyState(context);
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        viewModel.onRefreshRequested(sender: viewModel);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: viewModel.predictions.length,
        itemBuilder: (context, index) {
          final prediction = viewModel.predictions[index];
          return _buildPredictionCard(context, prediction, index);
        },
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history,
                size: 64,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhuma predição ainda',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Faça sua primeira predição para ver o histórico aqui',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ShadcnButton(
              text: 'Fazer Predição',
              leadingIcon: const Icon(Icons.add, size: 18),
              onPressed: () => widget.viewModel.onBackRequested(
                sender: widget.viewModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPredictionCard(
    BuildContext context,
    Map<String, dynamic> prediction,
    int index,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = widget.viewModel;
    
    final price = (prediction['predicted_price'] as num?)?.toDouble() ?? 0.0;
    final input = prediction['input'] as Map<String, dynamic>?;
    final timestamp = prediction['timestamp'] as String?;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ShadcnCard(
        onTap: () => viewModel.onPredictionTapped(
          sender: viewModel,
          prediction: prediction,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com número e data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#${index + 1}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                if (timestamp != null)
                  Text(
                    viewModel.formatDate(timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Preço
            Row(
              children: [
                Icon(
                  Icons.diamond,
                  color: Colors.purple.shade400,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Preço Estimado:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.purple.shade400],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    viewModel.formatPrice(price),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            // Características
            if (input != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag(context, '${input['carat']} ct'),
                  _buildTag(context, '${input['cut']}'),
                  _buildTag(context, 'Color ${input['color']}'),
                  _buildTag(context, '${input['clarity']}'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildTag(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  void _showClearConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: const Text('Limpar Histórico'),
        content: const Text(
          'Tem certeza que deseja apagar todo o histórico de predições? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.viewModel.onClearHistoryRequested(
                sender: widget.viewModel,
              );
            },
            child: Text(
              'Limpar',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
