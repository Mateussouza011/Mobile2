import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';
import '../../ui/widgets/shadcn/shadcn_input.dart';
import '../../ui/widgets/shadcn/shadcn_select.dart';
import '../../ui/widgets/shadcn/shadcn_card.dart';
import '../viewmodels/diamond_prediction_viewmodel.dart';

/// Tela de predição de preço de diamantes
class DiamondPredictionView extends StatefulWidget {
  const DiamondPredictionView({super.key});

  @override
  State<DiamondPredictionView> createState() => _DiamondPredictionViewState();
}

class _DiamondPredictionViewState extends State<DiamondPredictionView> {
  @override
  void initState() {
    super.initState();
    // Carrega histórico ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiamondPredictionViewModel>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Predição de Diamantes',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: Consumer<DiamondPredictionViewModel>(
        builder: (context, viewModel, child) {
          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Título
              Text(
                'Características do Diamante',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preencha as informações para prever o preço',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Formulário
              _buildForm(context, viewModel),
              
              const SizedBox(height: 24),

              // Botão de predição
              _buildPredictButton(context, viewModel),

              const SizedBox(height: 32),

              // Resultado
              if (viewModel.hasResult) ...[
                _buildResult(context, viewModel),
                const SizedBox(height: 32),
              ],

              // Erro
              if (viewModel.hasError) ...[
                _buildError(context, viewModel),
                const SizedBox(height: 32),
              ],

              // Histórico
              if (viewModel.history.isNotEmpty) ...[
                _buildHistory(context, viewModel),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, DiamondPredictionViewModel viewModel) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Carat (Quilates)
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quilates (carat)', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  Slider(
                    value: viewModel.carat,
                    min: 0.2,
                    max: 5.0,
                    divisions: 48,
                    label: viewModel.carat.toStringAsFixed(2),
                    onChanged: viewModel.setCarat,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 80,
              child: ShadcnInput(
                placeholder: '0.00',
                initialValue: viewModel.carat.toStringAsFixed(2),
                inputType: ShadcnInputType.number,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null && parsed >= 0.2 && parsed <= 5.0) {
                    viewModel.setCarat(parsed);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Cut, Color, Clarity
        Row(
          children: [
            Expanded(
              child: ShadcnSelect<String>(
                label: 'Corte',
                value: viewModel.cut,
                options: const [
                  ShadcnSelectOption(value: 'Fair', label: 'Fair'),
                  ShadcnSelectOption(value: 'Good', label: 'Good'),
                  ShadcnSelectOption(value: 'Very Good', label: 'Very Good'),
                  ShadcnSelectOption(value: 'Premium', label: 'Premium'),
                  ShadcnSelectOption(value: 'Ideal', label: 'Ideal'),
                ],
                onChanged: (value) => viewModel.setCut(value!),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ShadcnSelect<String>(
                label: 'Cor',
                value: viewModel.color,
                options: const [
                  ShadcnSelectOption(value: 'D', label: 'D'),
                  ShadcnSelectOption(value: 'E', label: 'E'),
                  ShadcnSelectOption(value: 'F', label: 'F'),
                  ShadcnSelectOption(value: 'G', label: 'G'),
                  ShadcnSelectOption(value: 'H', label: 'H'),
                  ShadcnSelectOption(value: 'I', label: 'I'),
                  ShadcnSelectOption(value: 'J', label: 'J'),
                ],
                onChanged: (value) => viewModel.setColor(value!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ShadcnSelect<String>(
          label: 'Claridade',
          value: viewModel.clarity,
          options: const [
            ShadcnSelectOption(value: 'I1', label: 'I1'),
            ShadcnSelectOption(value: 'SI2', label: 'SI2'),
            ShadcnSelectOption(value: 'SI1', label: 'SI1'),
            ShadcnSelectOption(value: 'VS2', label: 'VS2'),
            ShadcnSelectOption(value: 'VS1', label: 'VS1'),
            ShadcnSelectOption(value: 'VVS2', label: 'VVS2'),
            ShadcnSelectOption(value: 'VVS1', label: 'VVS1'),
            ShadcnSelectOption(value: 'IF', label: 'IF'),
          ],
          onChanged: (value) => viewModel.setClarity(value!),
        ),
        const SizedBox(height: 16),

        // Depth e Table
        Row(
          children: [
            Expanded(
              child: ShadcnInput(
                label: 'Profundidade (%)',
                placeholder: '0.0',
                initialValue: viewModel.depth.toStringAsFixed(1),
                inputType: ShadcnInputType.number,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) viewModel.setDepth(parsed);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ShadcnInput(
                label: 'Mesa (%)',
                placeholder: '0.0',
                initialValue: viewModel.table.toStringAsFixed(1),
                inputType: ShadcnInputType.number,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) viewModel.setTable(parsed);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Dimensões X, Y, Z
        Row(
          children: [
            Expanded(
              child: ShadcnInput(
                label: 'X (mm)',
                placeholder: '0.0',
                initialValue: viewModel.x.toStringAsFixed(1),
                inputType: ShadcnInputType.number,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) viewModel.setX(parsed);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ShadcnInput(
                label: 'Y (mm)',
                placeholder: '0.0',
                initialValue: viewModel.y.toStringAsFixed(1),
                inputType: ShadcnInputType.number,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) viewModel.setY(parsed);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ShadcnInput(
                label: 'Z (mm)',
                placeholder: '0.0',
                initialValue: viewModel.z.toStringAsFixed(1),
                inputType: ShadcnInputType.number,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) viewModel.setZ(parsed);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPredictButton(BuildContext context, DiamondPredictionViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: ShadcnButton(
            onPressed: viewModel.isLoading ? null : viewModel.predict,
            child: viewModel.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Prever Preço'),
          ),
        ),
        const SizedBox(width: 12),
        ShadcnButton(
          variant: ShadcnButtonVariant.outline,
          onPressed: viewModel.resetForm,
          child: const Text('Limpar'),
        ),
      ],
    );
  }

  Widget _buildResult(BuildContext context, DiamondPredictionViewModel viewModel) {
    final theme = Theme.of(context);
    final prediction = viewModel.currentPrediction!;

    return ShadcnCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.diamond, size: 32, color: Colors.blue),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preço Estimado',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      prediction.formattedPrice,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              prediction.diamondSummary,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, DiamondPredictionViewModel viewModel) {
    final theme = Theme.of(context);

    return ShadcnCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                viewModel.errorMessage ?? 'Erro desconhecido',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory(BuildContext context, DiamondPredictionViewModel viewModel) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Histórico de Predições',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...viewModel.history.take(5).map((history) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ShadcnCard(
              onTap: () => viewModel.loadFromHistory(history),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            history.prediction.diamondSummary,
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            history.prediction.formattedPrice,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
