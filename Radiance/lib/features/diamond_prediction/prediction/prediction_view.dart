import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'prediction_view_model.dart';
import 'prediction_delegate.dart';
import '../../../core/data/models/prediction_model.dart';
import '../../../core/theme/colors.dart';
import '../../../ui/widgets/shadcn/shadcn.dart';
import '../../../ui/widgets/theme_toggle/theme_toggle.dart';

class PredictionView extends StatelessWidget {
  final PredictionDelegate delegate;

  const PredictionView({super.key, required this.delegate});

  @override
  Widget build(BuildContext context) {
    return Consumer<PredictionViewModel>(
      builder: (context, viewModel, child) {
        final colorScheme = Theme.of(context).colorScheme;
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
            title: const Text('New Prediction'),
            actions: [
              const ThemeToggleButton(size: 36),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => delegate.resetForm(),
                tooltip: 'Reset',
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
                'Diamond Characteristics',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in the details below to calculate the estimated price.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              if (viewModel.errorMessage != null) ...[
                ShadcnAlert(
                  variant: ShadcnAlertVariant.destructive,
                  title: 'Error',
                  description: viewModel.errorMessage!,
                ),
                const SizedBox(height: 24),
              ],
              _SliderField(
                label: 'Carat Weight',
                description: 'The larger, the more valuable',
                value: viewModel.carat,
                min: 0.2,
                max: 5.0,
                suffix: ' ct',
                onChanged: viewModel.setCarat,
              ),
              const SizedBox(height: 20),
              _SelectField(
                label: 'Cut Quality',
                description: 'Defines the diamond brilliance',
                value: viewModel.cut,
                placeholder: 'Select cut quality',
                options: PredictionViewModel.cutOptions,
                optionLabels: const {
                  'Ideal': 'Ideal - Best',
                  'Premium': 'Premium - Excellent',
                  'Very Good': 'Very Good',
                  'Good': 'Good',
                  'Fair': 'Fair - Basic',
                },
                onChanged: viewModel.setCut,
              ),
              const SizedBox(height: 20),
              _SelectField(
                label: 'Color',
                description: 'D = Most transparent, J = Slightly yellow',
                value: viewModel.color,
                placeholder: 'Select color grade',
                options: PredictionViewModel.colorOptions,
                optionLabels: const {
                  'D': 'D - Colorless (Best)',
                  'E': 'E - Colorless',
                  'F': 'F - Colorless',
                  'G': 'G - Near Colorless',
                  'H': 'H - Near Colorless',
                  'I': 'I - Faint Tint',
                  'J': 'J - Faint Tint (Lower)',
                },
                onChanged: viewModel.setColor,
              ),
              const SizedBox(height: 20),
              _SelectField(
                label: 'Clarity',
                description: 'Level of internal imperfections',
                value: viewModel.clarity,
                placeholder: 'Select clarity grade',
                options: PredictionViewModel.clarityOptions,
                optionLabels: const {
                  'IF': 'IF - Internally Flawless (Best)',
                  'VVS1': 'VVS1 - Very Very Slight 1',
                  'VVS2': 'VVS2 - Very Very Slight 2',
                  'VS1': 'VS1 - Very Slight 1',
                  'VS2': 'VS2 - Very Slight 2',
                  'SI1': 'SI1 - Slight Inclusions 1',
                  'SI2': 'SI2 - Slight Inclusions 2',
                  'I1': 'I1 - Visible Inclusions (Lower)',
                },
                onChanged: viewModel.setClarity,
              ),
              const SizedBox(height: 20),
              _SliderField(
                label: 'Depth Percentage',
                description: 'Relative height of the diamond',
                value: viewModel.depth,
                min: 43.0,
                max: 79.0,
                suffix: '%',
                onChanged: viewModel.setDepth,
              ),
              const SizedBox(height: 20),
              _SliderField(
                label: 'Table Percentage',
                description: 'Top face of the diamond',
                value: viewModel.table,
                min: 43.0,
                max: 95.0,
                suffix: '%',
                onChanged: viewModel.setTable,
              ),
              const SizedBox(height: 20),
              Text(
                'Physical Dimensions (mm)',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: _DimensionField(
                          label: 'X',
                          value: viewModel.x,
                          onChanged: viewModel.setX)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _DimensionField(
                          label: 'Y',
                          value: viewModel.y,
                          onChanged: viewModel.setY)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _DimensionField(
                          label: 'Z',
                          value: viewModel.z,
                          onChanged: viewModel.setZ)),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ShadcnButtonView.withLeadingIcon(
                  text: 'Calculate Price',
                  leadingIcon: const Icon(Icons.calculate, size: 18),
                  variant: ShadcnButtonVariant.default_,
                  size: ShadcnButtonSize.lg,
                  loading: viewModel.isLoading,
                  disabled: viewModel.isLoading,
                  onPressed:
                      viewModel.isLoading ? null : () => delegate.predict(),
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
                  Text(label,
                      style: textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w500)),
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
  final String? value;
  final List<String> options;
  final Map<String, String>? optionLabels;
  final ValueChanged<String?> onChanged;
  final String placeholder;

  const _SelectField({
    required this.label,
    this.description,
    required this.value,
    required this.options,
    this.optionLabels,
    required this.onChanged,
    this.placeholder = 'Select an option',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)),
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
          placeholder: placeholder,
          options: options
              .map((o) => ShadcnSelectOption(
                    value: o,
                    label: optionLabels?[o] ?? o,
                  ))
              .toList(),
          onChanged: (v) {
            onChanged(v);
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
      'X': 'Width (X)',
      'Y': 'Length (Y)',
      'Z': 'Height (Z)',
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
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, ShadcnColors.chart[0]],
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
              Text(
                'Estimated Price',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${result.price.toStringAsFixed(2)}',
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ShadcnColors.chart[2],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ShadcnColors.chart[2].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: ShadcnColors.chart[2].withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle,
                        size: 16, color: ShadcnColors.chart[2]),
                    const SizedBox(width: 6),
                    Text(
                      'Saved to history',
                      style: textTheme.bodySmall?.copyWith(
                        color: ShadcnColors.chart[2],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _ModalSummaryRow(
                        label: 'Carats',
                        value: '${viewModel.carat.toStringAsFixed(2)} ct'),
                    const SizedBox(height: 8),
                    _ModalSummaryRow(label: 'Cut', value: viewModel.cut ?? '-'),
                    const SizedBox(height: 8),
                    _ModalSummaryRow(
                        label: 'Color', value: viewModel.color ?? '-'),
                    const SizedBox(height: 8),
                    _ModalSummaryRow(
                        label: 'Clarity', value: viewModel.clarity ?? '-'),
                    const SizedBox(height: 8),
                    _ModalSummaryRow(
                      label: 'Dimensions',
                      value:
                          '${viewModel.x.toStringAsFixed(1)} x ${viewModel.y.toStringAsFixed(1)} x ${viewModel.z.toStringAsFixed(1)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _HighlightedButton(
                text: 'New Prediction',
                icon: Icons.add_circle_outline,
                onPressed: onNewPrediction,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ShadcnButtonView(
                  text: 'Back to Home',
                  variant: ShadcnButtonVariant.outline,
                  size: ShadcnButtonSize.lg,
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
          style: textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _HighlightedButtonViewModel extends ChangeNotifier {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get isHovered => _isHovered;
  bool get isPressed => _isPressed;

  void setHovered(bool value) {
    if (_isHovered != value) {
      _isHovered = value;
      notifyListeners();
    }
  }

  void setPressed(bool value) {
    if (_isPressed != value) {
      _isPressed = value;
      notifyListeners();
    }
  }

  double get scale => _isPressed ? 0.95 : (_isHovered ? 1.02 : 1.0);

  double get elevation => _isPressed ? 2 : (_isHovered ? 12 : 8);

  double get glowOpacity => _isPressed ? 0.3 : (_isHovered ? 0.6 : 0.4);
}

class _HighlightedButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const _HighlightedButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_HighlightedButton> createState() => _HighlightedButtonState();
}

class _HighlightedButtonState extends State<_HighlightedButton> {
  late final _HighlightedButtonViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = _HighlightedButtonViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => _viewModel.setPressed(true),
          onTapUp: (_) {
            _viewModel.setPressed(false);
            widget.onPressed();
          },
          onTapCancel: () => _viewModel.setPressed(false),
          child: MouseRegion(
            onEnter: (_) => _viewModel.setHovered(true),
            onExit: (_) => _viewModel.setHovered(false),
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              transform: Matrix4.identity()..scale(_viewModel.scale),
              transformAlignment: Alignment.center,
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.8),
                      colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary
                          .withOpacity(_viewModel.glowOpacity),
                      blurRadius: _viewModel.elevation,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.text,
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
