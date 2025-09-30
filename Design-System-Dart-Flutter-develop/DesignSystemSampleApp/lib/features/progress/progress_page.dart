import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_progress.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  double _progress = 0.6;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Progress',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Básico',
            '',
            [
              const SizedBox(height: 20),
              ShadcnProgress(value: _progress),
              const SizedBox(height: 8),
              Text(
                '${(_progress * 100).round()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Tamanhos',
            '',
            [
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pequeno', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  ShadcnProgress(value: 0.4, height: 4),
                  const SizedBox(height: 16),
                  
                  Text('Médio', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  ShadcnProgress(value: 0.6, height: 8),
                  const SizedBox(height: 16),
                  
                  Text('Grande', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  ShadcnProgress(value: 0.8, height: 12),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Cores',
            '',
            [
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Primário', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  ShadcnProgress(value: 0.5, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  
                  Text('Sucesso', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  ShadcnProgress(value: 0.7, color: Colors.green),
                  const SizedBox(height: 16),
                  
                  Text('Aviso', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  ShadcnProgress(value: 0.3, color: Colors.orange),
                ],
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
        ...children,
      ],
    );
  }
}