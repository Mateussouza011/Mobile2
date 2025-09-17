import 'package:flutter/material.dart';

/// Página que demonstra diferentes tipos de sliders
class SlidersPage extends StatefulWidget {
  const SlidersPage({super.key});

  @override
  State<SlidersPage> createState() => _SlidersPageState();
}

class _SlidersPageState extends State<SlidersPage> {
  double _simpleSlider = 50;
  RangeValues _rangeSlider = const RangeValues(20, 80);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sliders',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Sliders e controles deslizantes',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Slider Simples',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Valor: ${_simpleSlider.round()}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Slider(
                    value: _simpleSlider,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: _simpleSlider.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _simpleSlider = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Range Slider',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Faixa: ${_rangeSlider.start.round()} - ${_rangeSlider.end.round()}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  RangeSlider(
                    values: _rangeSlider,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    labels: RangeLabels(
                      _rangeSlider.start.round().toString(),
                      _rangeSlider.end.round().toString(),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _rangeSlider = values;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
