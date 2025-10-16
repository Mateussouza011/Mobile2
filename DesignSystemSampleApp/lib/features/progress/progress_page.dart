import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_progress.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Progresso',
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
            'Progresso Linear',
            'Diferentes estilos de barras de progresso',
            [
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Básico', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  const ShadcnProgress.linear(value: 50),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Progresso Circular',
            'Indicadores circulares de progresso',
            [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Básico', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      const ShadcnProgress.circular(value: 65),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Com texto', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const ShadcnProgress.circular(value: 80),
                          Text(
                            '80%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Indeterminado', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      const ShadcnProgress.indeterminate(
                        type: ShadcnProgressType.circular,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Tamanhos',
            'Diferentes tamanhos disponíveis',
            [
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pequeno', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  const ShadcnProgress.linear(value: 40, size: ShadcnProgressSize.sm),
                  const SizedBox(height: 16),
                  
                  Text('Padrão', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  const ShadcnProgress.linear(value: 60, size: ShadcnProgressSize.default_),
                  const SizedBox(height: 16),
                  
                  Text('Grande', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  const ShadcnProgress.linear(value: 80, size: ShadcnProgressSize.lg),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Progresso por Etapas',
            'Progresso dividido em etapas específicas',
            [
              const SizedBox(height: 20),
              const ShadcnStepProgress(
                totalSteps: 4,
                stepLabels: [
                  'Informações Pessoais',
                  'Endereço',
                  'Pagamento',
                  'Confirmação',
                ],
                currentStep: 2,
              ),
              const SizedBox(height: 20),
              const ShadcnStepProgress(
                totalSteps: 4,
                stepLabels: [
                  'Upload',
                  'Processamento',
                  'Validação',
                  'Concluído',
                ],
                currentStep: 1,
                variant: ShadcnProgressVariant.success,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
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
}