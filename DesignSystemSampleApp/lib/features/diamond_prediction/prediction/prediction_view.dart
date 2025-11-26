import 'package:flutter/material.dart';
import '../../../DesignSystem/Theme/app_theme.dart';
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
    return Scaffold(
      backgroundColor: AppColors.zinc50,
      appBar: AppBar(
        title: const Text(
          'Nova Predição',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.zinc900,
          onPressed: () => widget.viewModel.onBackRequested(
            sender: widget.viewModel,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            color: AppColors.zinc900,
            onPressed: () => widget.viewModel.onResetRequested(
              sender: widget.viewModel,
            ),
            tooltip: 'Limpar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.blue500, AppColors.purple500],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue500.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.diamond_outlined, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calcular Preço',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.zinc900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Insira as características do diamante',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.zinc500,
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carat (Slider)
          _buildSliderField(
            context,
            label: 'Peso do Diamante',
            description: 'Quilates (1 ct = 0.2g)',
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
                  label: 'Profundidade',
                  description: 'Altura relativa do diamante',
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
              const SizedBox(width: 24),
              Expanded(
                child: _buildSliderField(
                  context,
                  label: 'Topo',
                  description: 'Largura da face superior',
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
    String? description,
    required double value,
    required double min,
    required double max,
    required String suffix,
    required ValueChanged<double> onChanged,
  }) {
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
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.zinc900,
                    ),
                  ),
                  if (description != null)
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.zinc400,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.zinc100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.toStringAsFixed(2)}$suffix',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.zinc900,
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
          label: 'Qualidade do Corte',
          placeholder: 'Selecione o corte',
          value: viewModel.cut,
          options: _buildCutOptions(),
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
                label: 'Cor',
                placeholder: 'Cor',
                value: viewModel.color,
                options: _buildColorOptions(),
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
                label: 'Pureza',
                placeholder: 'Pureza',
                value: viewModel.clarity,
                options: _buildClarityOptions(),
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
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dimensões do Diamante',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.zinc900,
          ),
        ),
        const Text(
          'Medidas em milímetros (mm)',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.zinc400,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDimensionSlider(
                context,
                label: 'Compr.',
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
                label: 'Largura',
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
                label: 'Altura',
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
    return Column(
      children: [
        Text(
          '$label: ${value.toStringAsFixed(1)}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.zinc500,
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
      size: ShadcnButtonSize.lg,
      leadingIcon: viewModel.isLoading
          ? null
          : const Icon(Icons.calculate_outlined, size: 20),
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
              gradient: const LinearGradient(
                colors: [AppColors.emerald500, AppColors.teal500],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.emerald500.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Preço Estimado',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.zinc500,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Preço principal
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.blue600, AppColors.purple600],
            ).createShader(bounds),
            child: Text(
              viewModel.formatPrice(price),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
          ),
          
          // Detalhes dos modelos
          if (details != null) ...[
            const SizedBox(height: 24),
            const Divider(color: AppColors.zinc200),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildModelDetail(
                  context,
                  'Modelo 1',
                  viewModel.formatPrice((details['model1'] as num).toDouble()),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.zinc200,
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
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.zinc500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.zinc900,
          ),
        ),
      ],
    );
  }
  
  Widget _buildErrorCard(BuildContext context) {
    return ShadcnCard(
      backgroundColor: AppColors.red50,
      borderColor: AppColors.red200,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.red600,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Erro na Predição',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.red900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.viewModel.errorMessage!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.red700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Opções de corte com descrições amigáveis para leigos
  List<ShadcnSelectOption<String>> _buildCutOptions() {
    const descriptions = {
      'Fair': 'Básico - Brilho reduzido',
      'Good': 'Bom - Brilho adequado',
      'Very Good': 'Muito Bom - Ótimo brilho',
      'Premium': 'Premium - Brilho excepcional',
      'Ideal': 'Ideal - Máximo brilho ✨',
    };
    
    return widget.viewModel.cutOptions.map((cut) {
      return ShadcnSelectOption(
        value: cut,
        label: descriptions[cut] ?? cut,
      );
    }).toList();
  }
  
  /// Opções de cor com descrições amigáveis para leigos
  List<ShadcnSelectOption<String>> _buildColorOptions() {
    const descriptions = {
      'D': 'D - Incolor (Raro) 💎',
      'E': 'E - Incolor',
      'F': 'F - Incolor',
      'G': 'G - Quase incolor',
      'H': 'H - Quase incolor',
      'I': 'I - Levemente amarelado',
      'J': 'J - Amarelado',
    };
    
    return widget.viewModel.colorOptions.map((color) {
      return ShadcnSelectOption(
        value: color,
        label: descriptions[color] ?? color,
      );
    }).toList();
  }
  
  /// Opções de pureza com descrições amigáveis para leigos
  List<ShadcnSelectOption<String>> _buildClarityOptions() {
    const descriptions = {
      'IF': 'IF - Perfeito (Raro) 💎',
      'VVS1': 'VVS1 - Quase perfeito',
      'VVS2': 'VVS2 - Mínimas inclusões',
      'VS1': 'VS1 - Pequenas inclusões',
      'VS2': 'VS2 - Inclusões leves',
      'SI1': 'SI1 - Inclusões visíveis',
      'SI2': 'SI2 - Inclusões notáveis',
      'I1': 'I1 - Inclusões óbvias',
    };
    
    return widget.viewModel.clarityOptions.map((clarity) {
      return ShadcnSelectOption(
        value: clarity,
        label: descriptions[clarity] ?? clarity,
      );
    }).toList();
  }
}
