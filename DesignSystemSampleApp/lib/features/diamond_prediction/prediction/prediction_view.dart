import 'package:flutter/material.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import '../../../ui/widgets/shadcn/shadcn_select.dart';
import '../../../ui/widgets/shadcn/shadcn_slider.dart';
import '../../../core/constants/api_constants.dart';
import 'prediction_view_model.dart';

/// PredictionView - Tela de nova predição de preço de diamante
/// 
/// Permite ao usuário inserir características do diamante
/// e obter uma predição de preço via API de machine learning.
class PredictionView extends StatefulWidget {
  final PredictionViewModel viewModel;
  
  const PredictionView({
    super.key,
    required this.viewModel,
  });
  
  @override
  State<PredictionView> createState() => _PredictionViewState();
}

class _PredictionViewState extends State<PredictionView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.onStateChanged = () {
      if (mounted) {
        setState(() {});
      }
    };
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
        title: const Text('Nova Predição'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.viewModel.onBackRequested(
            sender: widget.viewModel,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => widget.viewModel.onResetRequested(
              sender: widget.viewModel,
            ),
            tooltip: 'Limpar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Descrição
            _buildHeader(context),
            
            const SizedBox(height: 24),
            
            // Formulário
            _buildForm(context),
            
            const SizedBox(height: 24),
            
            // Botão de calcular
            _buildCalculateButton(context),
            
            const SizedBox(height: 24),
            
            // Resultado ou erro
            if (widget.viewModel.hasResult)
              _buildResultCard(context),
            
            if (widget.viewModel.errorMessage != null)
              _buildErrorCard(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.diamond, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calcular Preço',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Insira as características do diamante',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildForm(BuildContext context) {
    final viewModel = widget.viewModel;
    
    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carat (Slider)
          _buildSliderField(
            context,
            label: 'Carat (Peso)',
            value: viewModel.carat,
            min: ApiConstants.minCarat,
            max: ApiConstants.maxCarat,
            suffix: ' ct',
            onChanged: (value) => viewModel.onCaratChanged(
              sender: viewModel,
              value: value,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Cut, Color, Clarity (Selects)
          _buildSelectsRow(context),
          
          const SizedBox(height: 24),
          
          // Depth e Table
          Row(
            children: [
              Expanded(
                child: _buildSliderField(
                  context,
                  label: 'Depth (%)',
                  value: viewModel.depth,
                  min: ApiConstants.minDepth,
                  max: ApiConstants.maxDepth,
                  suffix: '%',
                  onChanged: (value) => viewModel.onDepthChanged(
                    sender: viewModel,
                    value: value,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSliderField(
                  context,
                  label: 'Table (%)',
                  value: viewModel.table,
                  min: ApiConstants.minTable,
                  max: ApiConstants.maxTable,
                  suffix: '%',
                  onChanged: (value) => viewModel.onTableChanged(
                    sender: viewModel,
                    value: value,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Dimensões X, Y, Z
          _buildDimensionsSection(context),
        ],
      ),
    );
  }
  
  Widget _buildSliderField(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required String suffix,
    required ValueChanged<double> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${value.toStringAsFixed(2)}$suffix',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ShadcnSlider.single(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          showLabels: false,
        ),
      ],
    );
  }
  
  Widget _buildSelectsRow(BuildContext context) {
    final viewModel = widget.viewModel;
    
    return Column(
      children: [
        // Cut
        ShadcnSelect<String>(
          label: 'Cut (Corte)',
          placeholder: 'Selecione o corte',
          value: viewModel.cut,
          options: viewModel.cutOptions
              .map((e) => ShadcnSelectOption(value: e, label: e))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              viewModel.onCutChanged(sender: viewModel, value: value);
            }
          },
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            // Color
            Expanded(
              child: ShadcnSelect<String>(
                label: 'Color (Cor)',
                placeholder: 'Cor',
                value: viewModel.color,
                options: viewModel.colorOptions
                    .map((e) => ShadcnSelectOption(value: e, label: e))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    viewModel.onColorChanged(sender: viewModel, value: value);
                  }
                },
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Clarity
            Expanded(
              child: ShadcnSelect<String>(
                label: 'Clarity (Claridade)',
                placeholder: 'Claridade',
                value: viewModel.clarity,
                options: viewModel.clarityOptions
                    .map((e) => ShadcnSelectOption(value: e, label: e))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    viewModel.onClarityChanged(sender: viewModel, value: value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildDimensionsSection(BuildContext context) {
    final viewModel = widget.viewModel;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dimensões (mm)',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDimensionSlider(
                context,
                label: 'X',
                value: viewModel.x,
                onChanged: (value) => viewModel.onDimensionsChanged(
                  sender: viewModel,
                  x: value,
                  y: viewModel.y,
                  z: viewModel.z,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDimensionSlider(
                context,
                label: 'Y',
                value: viewModel.y,
                onChanged: (value) => viewModel.onDimensionsChanged(
                  sender: viewModel,
                  x: viewModel.x,
                  y: value,
                  z: viewModel.z,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDimensionSlider(
                context,
                label: 'Z',
                value: viewModel.z,
                onChanged: (value) => viewModel.onDimensionsChanged(
                  sender: viewModel,
                  x: viewModel.x,
                  y: viewModel.y,
                  z: value,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildDimensionSlider(
    BuildContext context, {
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        Text(
          '$label: ${value.toStringAsFixed(1)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        ShadcnSlider.single(
          value: value,
          min: ApiConstants.minDimension,
          max: ApiConstants.maxDimension,
          onChanged: onChanged,
          showLabels: false,
        ),
      ],
    );
  }
  
  Widget _buildCalculateButton(BuildContext context) {
    final viewModel = widget.viewModel;
    
    return ShadcnButton(
      text: viewModel.isLoading ? 'Calculando...' : 'Calcular Preço',
      leadingIcon: viewModel.isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.calculate, size: 18),
      onPressed: viewModel.isLoading
          ? null
          : () => viewModel.onCalculateRequested(sender: viewModel),
      loading: viewModel.isLoading,
    );
  }
  
  Widget _buildResultCard(BuildContext context) {
    final viewModel = widget.viewModel;
    final result = viewModel.result!;
    final price = (result['predicted_price'] as num).toDouble();
    final details = result['details'] as Map<String, dynamic>?;
    
    return ShadcnCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Ícone de sucesso
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.teal.shade400],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 32,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Preço Estimado',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Preço principal
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.blue.shade400, Colors.purple.shade400],
            ).createShader(bounds),
            child: Text(
              viewModel.formatPrice(price),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          // Detalhes dos modelos
          if (details != null) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildModelDetail(
                  context,
                  'Modelo 1',
                  viewModel.formatPrice((details['model1'] as num).toDouble()),
                ),
                _buildModelDetail(
                  context,
                  'Modelo 2',
                  viewModel.formatPrice((details['model2'] as num).toDouble()),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildModelDetail(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
  
  Widget _buildErrorCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ShadcnCard(
      backgroundColor: colorScheme.errorContainer,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Erro na Predição',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.viewModel.errorMessage!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
