import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_progress.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> with TickerProviderStateMixin {
  double _progress = 0.6;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
            'Progress Linear',
            'Diferentes estilos de barras de progresso',
            [
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Básico', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  ShadcnProgress.linear(value: 50),
                  const SizedBox(height: 16),
                  
                  Text('Com animação', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return ShadcnProgress.linear(
                        value: _animation.value * 100,
                        animated: true,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  Text('Indeterminado', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  const ShadcnProgress.indeterminate(
                    type: ShadcnProgressType.linear,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Progress Circular',
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
                      ShadcnProgress.circular(value: 65),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Com texto', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ShadcnProgress.circular(value: 80),
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
                  ShadcnProgress.linear(value: 40, size: ShadcnProgressSize.sm),
                  const SizedBox(height: 16),
                  
                  Text('Padrão', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  ShadcnProgress.linear(value: 60, size: ShadcnProgressSize.default_),
                  const SizedBox(height: 16),
                  
                  Text('Grande', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  ShadcnProgress.linear(value: 80, size: ShadcnProgressSize.lg),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Progress por Etapas',
            'Progresso dividido em etapas específicas',
            [
              const SizedBox(height: 20),
              ShadcnStepProgress(
                totalSteps: 4,
                stepLabels: const [
                  'Informações Pessoais',
                  'Endereço',
                  'Pagamento',
                  'Confirmação',
                ],
                currentStep: 2,
              ),
              const SizedBox(height: 20),
              ShadcnStepProgress(
                totalSteps: 4,
                stepLabels: const [
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
          
          _buildSection(
            context,
            'Controle Interativo',
            'Controle manual do progresso',
            [
              const SizedBox(height: 20),
              Column(
                children: [
                  ShadcnProgress.linear(
                    value: _progress * 100,
                    showPercentage: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _progress = (_progress - 0.1).clamp(0.0, 1.0);
                          });
                        },
                        child: const Text('-10%'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _progress = 0.0;
                          });
                        },
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _progress = (_progress + 0.1).clamp(0.0, 1.0);
                          });
                        },
                        child: const Text('+10%'),
                      ),
                    ],
                  ),
                ],
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