import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'history_view_model.dart';
import 'history_delegate.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../core/data/models/prediction_model.dart';

class HistoryView extends StatefulWidget {
  final HistoryDelegate delegate;

  const HistoryView({super.key, required this.delegate});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.delegate.loadHistory();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      widget.delegate.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryViewModel>(
      builder: (context, viewModel, child) {
        final colorScheme = Theme.of(context).colorScheme;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => widget.delegate.navigateBack(),
            ),
            title: const Text('Historico'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => widget.delegate.refresh(),
                tooltip: 'Atualizar',
              ),
            ],
          ),
          body: _buildBody(context, viewModel, colorScheme),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HistoryViewModel viewModel, ColorScheme colorScheme) {
    if (viewModel.isLoading && viewModel.predictions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null && viewModel.predictions.isEmpty) {
      return _buildErrorState(context, viewModel, colorScheme);
    }

    if (viewModel.predictions.isEmpty) {
      return _buildEmptyState(context, colorScheme);
    }

    return RefreshIndicator(
      onRefresh: () => widget.delegate.refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.predictions.length + (viewModel.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == viewModel.predictions.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _buildPredictionCard(context, viewModel.predictions[index], colorScheme);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, HistoryViewModel viewModel, ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ?? 'Erro desconhecido',
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ShadcnButton(
              text: 'Tentar Novamente',
              onPressed: () => widget.delegate.loadHistory(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'Nenhuma predicao encontrada',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Suas predicoes salvas aparecerao aqui.',
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionCard(BuildContext context, PredictionHistoryModel prediction, ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ShadcnCard(
        variant: ShadcnCardVariant.outlined,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.diamond, color: colorScheme.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${prediction.carat.toStringAsFixed(2)} quilates',
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${prediction.cut} - ${prediction.color} - ${prediction.clarity}',
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${prediction.predictedPrice.toStringAsFixed(2)}',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      _formatDate(prediction.createdAt),
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildDetailChip('Depth: ${prediction.depth.toStringAsFixed(1)}%', colorScheme),
                      const SizedBox(width: 8),
                      _buildDetailChip('Table: ${prediction.table.toStringAsFixed(1)}%', colorScheme),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: colorScheme.error, size: 20),
                  onPressed: () => _showDeleteDialog(context, prediction),
                  tooltip: 'Excluir',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(String text, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'Hoje';
    if (difference.inDays == 1) return 'Ontem';
    if (difference.inDays < 7) return 'Ha ${difference.inDays} dias';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteDialog(BuildContext context, PredictionHistoryModel prediction) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Predicao'),
        content: const Text('Deseja realmente excluir esta predicao do historico?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (prediction.id != null) {
                widget.delegate.deletePrediction(prediction.id!);
              }
            },
            child: Text('Excluir', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}
