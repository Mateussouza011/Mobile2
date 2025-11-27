import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'prediction_view_model.dart';
import 'prediction_delegate.dart';
import '../../../core/data/models/prediction_model.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import '../../../ui/widgets/shadcn/shadcn_alert.dart';
import '../../../ui/widgets/shadcn/shadcn_select.dart';
import '../../../ui/widgets/shadcn/shadcn_slider.dart';

class PredictionView extends StatelessWidget {
  final PredictionDelegate delegate;

  const PredictionView({super.key, required this.delegate});

  @override
  Widget build(BuildContext context) {
    return Consumer<PredictionViewModel>(
      builder: (context, viewModel, child) {
        final colorScheme = Theme.of(context).colorScheme;

        // Mostrar modal quando tiver resultado
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (viewModel.showResult && viewModel.result != null) {
            _showResultModal(context, viewModel);
          }
        });

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => delegate.navigateBack(),
            ),
            title: const Text('Nova Predicao'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => delegate.resetForm(),
                tooltip: 'Resetar',
              ),
            ],
          ),
          body: SafeArea(
            child: _FormView(viewModel: viewModel, delegate: delegate),
          ),
        );
      },
    );
  }

  void _showResultModal(BuildContext context, PredictionViewModel viewModel) {
    final result = viewModel.result;
    if (result == null) return;

    // Limpar o resultado para evitar reabrir o modal
    viewModel.clearResult();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _ResultModal(
        result: result,
        viewModel: viewModel,
        onNewPrediction: () {
          Navigator.of(dialogContext).pop();
        },
        onGoHome: () {
          Navigator.of(dialogContext).pop();
          delegate.navigateBack();
        },
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  final PredictionViewModel viewModel;
  final PredictionDelegate delegate;

  const _FormView({required this.viewModel, required this.delegate});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Caracteristicas do Diamante',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preencha os dados abaixo para calcular o preco estimado.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              if (viewModel.errorMessage != null) ...[
                ShadcnAlert(
                  variant: ShadcnAlertVariant.destructive,
                  title: 'Erro',
                  description: viewModel.errorMessage!,
                ),
                const SizedBox(height: 24),
              ],
              _SliderField(
                label: 'Peso em Quilates (Carat)',
                description: 'Quanto maior, mais valioso',
                value: viewModel.carat,
                min: 0.2,
                max: 5.0,
                suffix: ' ct',
                onChanged: viewModel.setCarat,
              ),
              const SizedBox(height: 20),
              _SelectField(
                label: 'Qualidade do Corte (Cut)',
                description: 'Define o brilho do diamante',
                value: viewModel.cut,
                options: PredictionViewModel.cutOptions,
                optionLabels: const {
                  'Fair': 'Regular',
                  'Good': 'Bom',
                  'Very Good': 'Muito Bom',
                  'Premium': 'Premium',
                  'Ideal': 'Ideal',
                },
                onChanged: viewModel.setCut,
              ),
              const SizedBox(height: 20),
              _SelectField(
                label: 'Cor (Color)',
                description: 'D = Mais transparente, J = Levemente amarelado',
                value: viewModel.color,
                options: PredictionViewModel.colorOptions,
                optionLabels: const {
                  'D': 'D - Incolor',
                  'E': 'E - Incolor',
                  'F': 'F - Incolor',
                  'G': 'G - Quase Incolor',
                  'H': 'H - Quase Incolor',
                  'I': 'I - Leve Tonalidade',
                  'J': 'J - Leve Tonalidade',
                },
                onChanged: viewModel.setColor,
              ),
              const SizedBox(height: 20),
              _SelectField(
                label: 'Pureza (Clarity)',
                description: 'Nivel de imperfeicoes internas',
                value: viewModel.clarity,
                options: PredictionViewModel.clarityOptions,
                optionLabels: const {
                  'I1': 'I1 - Inclusoes Visiveis',
                  'SI2': 'SI2 - Pequenas Inclusoes',
                  'SI1': 'SI1 - Pequenas Inclusoes',
                  'VS2': 'VS2 - Muito Pequenas',
                  'VS1': 'VS1 - Muito Pequenas',
                  'VVS2': 'VVS2 - Minusculas',
                  'VVS1': 'VVS1 - Minusculas',
                  'IF': 'IF - Internamente Perfeito',
                },
                onChanged: viewModel.setClarity,
              ),
              const SizedBox(height: 20),
              _SliderField(
                label: 'Profundidade (Depth %)',
                description: 'Altura relativa do diamante',
                value: viewModel.depth,
                min: 43.0,
                max: 79.0,
                suffix: '%',
                onChanged: viewModel.setDepth,
              ),
              const SizedBox(height: 20),
              _SliderField(
                label: 'Tamanho da Mesa (Table %)',
                description: 'Face superior do diamante',
                value: viewModel.table,
                min: 43.0,
                max: 95.0,
                suffix: '%',
                onChanged: viewModel.setTable,
              ),
              const SizedBox(height: 20),
              Text(
                'Dimensoes Fisicas (mm)',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _DimensionField(label: 'X', value: viewModel.x, onChanged: viewModel.setX)),
                  const SizedBox(width: 12),
                  Expanded(child: _DimensionField(label: 'Y', value: viewModel.y, onChanged: viewModel.setY)),
                  const SizedBox(width: 12),
                  Expanded(child: _DimensionField(label: 'Z', value: viewModel.z, onChanged: viewModel.setZ)),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ShadcnButton(
                  text: 'Calcular Preco',
                  loading: viewModel.isLoading,
                  leadingIcon: const Icon(Icons.calculate, size: 18),
                  onPressed: viewModel.isLoading ? null : () => delegate.predict(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliderField extends StatelessWidget {
  final String label;
  final String? description;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final ValueChanged<double> onChanged;

  const _SliderField({
    required this.label,
    this.description,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              '${value.toStringAsFixed(2)}$suffix',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ShadcnSlider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}

class _SelectField extends StatelessWidget {
  final String label;
  final String? description;
  final String value;
  final List<String> options;
  final Map<String, String>? optionLabels;
  final ValueChanged<String> onChanged;

  const _SelectField({
    required this.label,
    this.description,
    required this.value,
    required this.options,
    this.optionLabels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)),
        if (description != null) ...[
          const SizedBox(height: 2),
          Text(
            description!,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
        const SizedBox(height: 8),
        ShadcnSelect<String>(
          value: value,
          options: options.map((o) => ShadcnSelectOption(
            value: o,
            label: optionLabels?[o] ?? o,
          )).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}

class _DimensionField extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _DimensionField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    final labelMap = {
      'X': 'Largura (X)',
      'Y': 'Comprimento (Y)',
      'Z': 'Altura (Z)',
    };

    return ShadcnCard(
      variant: ShadcnCardVariant.outlined,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labelMap[label] ?? label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value.toStringAsFixed(2),
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: value,
              min: 0.0,
              max: 10.0,
              onChanged: onChanged,
              activeColor: colorScheme.primary,
              inactiveColor: colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

/// Modal com o resultado da predição
class _ResultModal extends StatelessWidget {
  final PredictionResponse result;
  final PredictionViewModel viewModel;
  final VoidCallback onNewPrediction;
  final VoidCallback onGoHome;

  const _ResultModal({
    required this.result,
    required this.viewModel,
    required this.onNewPrediction,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone de diamante
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.diamond, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 20),
              
              // Título
              Text(
                'Preco Estimado',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              
              // Preço
              Text(
                '\$${result.price.toStringAsFixed(2)}',
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(height: 8),
              
              // Badge de salvo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Colors.green.shade600),
                    const SizedBox(width: 6),
                    Text(
                      'Salvo no historico',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Resumo das características
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _ModalSummaryRow(label: 'Quilates', value: '${viewModel.carat.toStringAsFixed(2)} ct'),
                    const SizedBox(height: 8),
                    _ModalSummaryRow(label: 'Corte', value: viewModel.cut),
                    const SizedBox(height: 8),
                    _ModalSummaryRow(label: 'Cor', value: viewModel.color),
                    const SizedBox(height: 8),
                    _ModalSummaryRow(label: 'Pureza', value: viewModel.clarity),
                    const SizedBox(height: 8),
                    _ModalSummaryRow(
                      label: 'Dimensoes',
                      value: '${viewModel.x.toStringAsFixed(1)} x ${viewModel.y.toStringAsFixed(1)} x ${viewModel.z.toStringAsFixed(1)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Botões
              SizedBox(
                width: double.infinity,
                child: ShadcnButton(
                  text: 'Nova Predicao',
                  leadingIcon: const Icon(Icons.add, size: 18),
                  onPressed: onNewPrediction,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ShadcnButton(
                  text: 'Voltar ao Inicio',
                  variant: ShadcnButtonVariant.outline,
                  onPressed: onGoHome,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModalSummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _ModalSummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
