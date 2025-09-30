import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_checkbox.dart';
import '../../ui/widgets/shadcn/shadcn_switch.dart';

class FormsPage extends StatefulWidget {
  const FormsPage({super.key});

  @override
  State<FormsPage> createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  bool _checkbox1 = false;
  bool _checkbox2 = true;
  bool _checkbox3 = false;
  
  bool _switch1 = false;
  bool _switch2 = true;
  bool _switch3 = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Formulários',
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
            'Checkboxes',
            '',
            [
              const SizedBox(height: 20),
              Column(
                children: [
                  ShadcnCheckbox(
                    value: _checkbox1,
                    label: 'Aceito os termos e condições',
                    onChanged: (value) => setState(() => _checkbox1 = value ?? false),
                  ),
                  ShadcnCheckbox(
                    value: _checkbox2,
                    label: 'Receber notificações por email',
                    onChanged: (value) => setState(() => _checkbox2 = value ?? false),
                  ),
                  ShadcnCheckbox(
                    value: _checkbox3,
                    label: 'Lembrar-me neste dispositivo',
                    onChanged: (value) => setState(() => _checkbox3 = value ?? false),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Switches',
            '',
            [
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Modo escuro',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      ShadcnSwitch(
                        value: _switch1,
                        onChanged: (value) => setState(() => _switch1 = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notificações push',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      ShadcnSwitch(
                        value: _switch2,
                        onChanged: (value) => setState(() => _switch2 = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sincronização automática',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      ShadcnSwitch(
                        value: _switch3,
                        onChanged: (value) => setState(() => _switch3 = value),
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
            'Estados',
            '',
            [
              const SizedBox(height: 20),
              Column(
                children: [
                  // Estados dos checkboxes
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Checkboxes',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ShadcnCheckbox(
                          value: false,
                          label: 'Não marcado',
                          onChanged: (_) {},
                        ),
                        ShadcnCheckbox(
                          value: true,
                          label: 'Marcado',
                          onChanged: (_) {},
                        ),
                        ShadcnCheckbox(
                          value: false,
                          label: 'Desabilitado',
                          onChanged: null,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Estados dos switches
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Switches',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Desligado', style: Theme.of(context).textTheme.bodySmall),
                            ShadcnSwitch(value: false, onChanged: (_) {}),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ligado', style: Theme.of(context).textTheme.bodySmall),
                            ShadcnSwitch(value: true, onChanged: (_) {}),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Desabilitado', style: Theme.of(context).textTheme.bodySmall),
                            ShadcnSwitch(value: false, onChanged: null),
                          ],
                        ),
                      ],
                    ),
                  ),
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