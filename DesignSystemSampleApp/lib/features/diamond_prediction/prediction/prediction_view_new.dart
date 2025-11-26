import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/api_constants.dart';
import 'prediction_view_model_new.dart';

/// PredictionView - Formulário moderno e minimalista
/// 
/// Design inspirado no shadcn/iOS com:
/// - Sliders elegantes
/// - Chips selecionáveis
/// - Card de resultado animado
class PredictionView extends StatefulWidget {
  const PredictionView({super.key});

  @override
  State<PredictionView> createState() => _PredictionViewState();
}

class _PredictionViewState extends State<PredictionView> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    final viewModel = context.watch<PredictionViewModel>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              _buildHeader(viewModel),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      
                      // Result Card (se tiver resultado)
                      if (viewModel.hasResult) ...[
                        _buildResultCard(viewModel),
                        const SizedBox(height: 24),
                      ],
                      
                      // Form Sections
                      _buildSection(
                        title: 'Quilates',
                        child: _buildCaratSlider(viewModel),
                      ),
                      
                      _buildSection(
                        title: 'Qualidade do Corte',
                        child: _buildChipSelector(
                          options: ApiConstants.cutOptions,
                          selectedIndex: viewModel.cutIndex,
                          onSelected: viewModel.updateCut,
                        ),
                      ),
                      
                      _buildSection(
                        title: 'Cor',
                        subtitle: 'D = melhor, J = pior',
                        child: _buildChipSelector(
                          options: ApiConstants.colorOptions,
                          selectedIndex: viewModel.colorIndex,
                          onSelected: viewModel.updateColor,
                        ),
                      ),
                      
                      _buildSection(
                        title: 'Claridade',
                        child: _buildChipSelector(
                          options: ApiConstants.clarityOptions,
                          selectedIndex: viewModel.clarityIndex,
                          onSelected: viewModel.updateClarity,
                        ),
                      ),
                      
                      _buildSection(
                        title: 'Dimensões',
                        child: _buildDimensionsGrid(viewModel),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Predict Button
                      _buildPredictButton(viewModel),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(PredictionViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: viewModel.goBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E4E7)),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: Color(0xFF18181B),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Nova Predição',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF18181B),
              ),
            ),
          ),
          if (viewModel.hasResult)
            GestureDetector(
              onTap: viewModel.reset,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Limpar',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF71717A),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultCard(PredictionViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.diamond_outlined,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Valor Estimado',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            viewModel.formatPrice(viewModel.predictedPrice ?? 0),
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          if (viewModel.predictionDetails != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${viewModel.carat.toStringAsFixed(2)} ct • ${viewModel.cut} • ${viewModel.color} • ${viewModel.clarity}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF18181B),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF71717A),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildCaratSlider(PredictionViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${viewModel.carat.toStringAsFixed(2)} ct',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF18181B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '0.2 - 5.0',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF71717A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              activeTrackColor: const Color(0xFF18181B),
              inactiveTrackColor: const Color(0xFFE4E4E7),
              thumbColor: const Color(0xFF18181B),
              overlayColor: const Color(0xFF18181B).withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: viewModel.carat,
              min: 0.2,
              max: 5.0,
              onChanged: viewModel.updateCarat,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipSelector({
    required List<String> options,
    required int selectedIndex,
    required Function(int) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.asMap().entries.map((entry) {
        final isSelected = entry.key == selectedIndex;
        return GestureDetector(
          onTap: () => onSelected(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF18181B) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected 
                    ? const Color(0xFF18181B) 
                    : const Color(0xFFE4E4E7),
              ),
            ),
            child: Text(
              entry.value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF52525B),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDimensionsGrid(PredictionViewModel viewModel) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _DimensionInput(
                label: 'Depth %',
                value: viewModel.depth,
                min: 50,
                max: 80,
                onChanged: viewModel.updateDepth,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DimensionInput(
                label: 'Table %',
                value: viewModel.table,
                min: 50,
                max: 80,
                onChanged: viewModel.updateTable,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _DimensionInput(
                label: 'X (mm)',
                value: viewModel.x,
                min: 0,
                max: 15,
                onChanged: viewModel.updateX,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DimensionInput(
                label: 'Y (mm)',
                value: viewModel.y,
                min: 0,
                max: 15,
                onChanged: viewModel.updateY,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DimensionInput(
                label: 'Z (mm)',
                value: viewModel.z,
                min: 0,
                max: 10,
                onChanged: viewModel.updateZ,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPredictButton(PredictionViewModel viewModel) {
    return GestureDetector(
      onTap: viewModel.isLoading ? null : viewModel.predict,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: viewModel.isLoading
              ? const Color(0xFF52525B)
              : const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: viewModel.isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Calcular Valor',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Input de Dimensão compacto
class _DimensionInput extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final Function(double) onChanged;

  const _DimensionInput({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF71717A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toStringAsFixed(1),
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF18181B),
            ),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: const Color(0xFF18181B),
              inactiveTrackColor: const Color(0xFFE4E4E7),
              thumbColor: const Color(0xFF18181B),
              overlayColor: const Color(0xFF18181B).withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
