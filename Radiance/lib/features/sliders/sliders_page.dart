import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_slider.dart';
import '../../ui/widgets/theme_toggle_button.dart';

class SlidersPage extends StatefulWidget {
  const SlidersPage({super.key});

  @override
  State<SlidersPage> createState() => _SlidersPageState();
}

class _SlidersPageState extends State<SlidersPage> {
  double _basicSlider = 50;
  double _labeledSlider = 30;
  double _volumeValue = 50.0;
  double _temperatureValue = 22.0;
  RangeValues _priceRange = const RangeValues(100, 500);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Controles Deslizantes',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: const [ThemeToggleButton(size: 36), SizedBox(width: 8)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const SizedBox(height: 32),
          _buildBasicSlider(context),
          
          const SizedBox(height: 24),
          _buildLabeledSlider(context),
          
          const SizedBox(height: 32),
          _buildSection(
            context,
            'Sliders e Controles',
            'Controles deslizantes para valores numéricos',
            [
              const SizedBox(height: 20),
              ShadcnVolumeSlider(
                value: _volumeValue,
                onChanged: (value) {
                  setState(() {
                    _volumeValue = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              ShadcnTemperatureSlider(
                value: _temperatureValue,
                onChanged: (value) {
                  setState(() {
                    _temperatureValue = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              ShadcnPriceRangeSlider(
                values: _priceRange,
                min: 0,
                max: 1000,
                onChanged: (values) {
                  setState(() {
                    _priceRange = values;
                  });
                },
              ),
              const SizedBox(height: 24),
              ShadcnSlider.single(
                value: 75,
                onChanged: (value) {},
                min: 0,
                max: 100,
                divisions: 10,
                label: 'Progresso',
                labelFormatter: (value) => '${value.toInt()}%',
                showTicks: true,
                leadingWidget: Icon(Icons.speed, color: colorScheme.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        ...children,
      ],
    );
  }

  Widget _buildBasicSlider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Card(
      color: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Slider Básico',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Valor: ${_basicSlider.round()}',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: colorScheme.primary,
                inactiveTrackColor: colorScheme.primary.withValues(alpha: 0.2),
                thumbColor: colorScheme.primary,
                overlayColor: colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Slider(
                value: _basicSlider,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    _basicSlider = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledSlider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Card(
      color: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Slider com Label',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Valor: ${_labeledSlider.round()}%',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: colorScheme.primary,
                inactiveTrackColor: colorScheme.primary.withValues(alpha: 0.2),
                thumbColor: colorScheme.primary,
                overlayColor: colorScheme.primary.withValues(alpha: 0.1),
                valueIndicatorColor: colorScheme.primary,
                valueIndicatorTextStyle: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: Slider(
                value: _labeledSlider,
                min: 0,
                max: 100,
                divisions: 100,
                label: '${_labeledSlider.round()}%',
                onChanged: (value) {
                  setState(() {
                    _labeledSlider = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}