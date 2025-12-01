import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_badge.dart';
import '../../ui/widgets/shadcn/shadcn_chip.dart';
import '../../ui/widgets/theme_toggle_button.dart';

class BadgesPage extends StatefulWidget {
  const BadgesPage({super.key});

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  final Set<String> _selectedChips = {};
  final List<String> _inputChips = ['Flutter', 'Dart', 'Mobile'];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Badges',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
          
          _buildSection(
            context,
            'Variantes',
            'Diferentes estilos de badges',
            [
              const SizedBox(height: 20),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ShadcnBadge(
                    text: 'Padrão',
                    variant: ShadcnBadgeVariant.default_,
                  ),
                  ShadcnBadge(
                    text: 'Secundário',
                    variant: ShadcnBadgeVariant.secondary,
                  ),
                  ShadcnBadge(
                    text: 'Destrutivo',
                    variant: ShadcnBadgeVariant.destructive,
                  ),
                  ShadcnBadge(
                    text: 'Contorno',
                    variant: ShadcnBadgeVariant.outline,
                  ),
                  ShadcnBadge(
                    text: 'Sucesso',
                    variant: ShadcnBadgeVariant.success,
                  ),
                  ShadcnBadge(
                    text: 'Aviso',
                    variant: ShadcnBadgeVariant.warning,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Tamanhos',
            'Diferentes tamanhos de badges',
            [
              const SizedBox(height: 20),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ShadcnBadge(
                    text: 'Pequeno',
                    size: ShadcnBadgeSize.sm,
                  ),
                  ShadcnBadge(
                    text: 'Médio',
                    size: ShadcnBadgeSize.md,
                  ),
                  ShadcnBadge(
                    text: 'Grande',
                    size: ShadcnBadgeSize.lg,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Com Ícones',
            'Badges com ícones',
            [
              const SizedBox(height: 20),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ShadcnBadge(
                    text: 'Novo',
                    icon: Icon(Icons.star),
                    variant: ShadcnBadgeVariant.default_,
                  ),
                  ShadcnBadge(
                    text: 'Online',
                    icon: Icon(Icons.circle),
                    variant: ShadcnBadgeVariant.success,
                  ),
                  ShadcnBadge(
                    text: 'Erro',
                    icon: Icon(Icons.warning),
                    variant: ShadcnBadgeVariant.destructive,
                  ),
                  ShadcnBadge(
                    text: 'Beta',
                    icon: Icon(Icons.science),
                    variant: ShadcnBadgeVariant.outline,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Badges Interativos',
            'Badges clicáveis e com botão de fechar',
            [
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ShadcnBadge(
                    text: 'Clicável',
                    variant: ShadcnBadgeVariant.default_,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Badge clicado!')),
                      );
                    },
                  ),
                  ShadcnBadge(
                    text: 'Tag removível',
                    variant: ShadcnBadgeVariant.secondary,
                    showCloseButton: true,
                    onClose: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tag removida!')),
                      );
                    },
                  ),
                  ShadcnBadge(
                    text: 'Flutter',
                    icon: const Icon(Icons.code),
                    variant: ShadcnBadgeVariant.outline,
                    showCloseButton: true,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tecnologia Flutter!')),
                      );
                    },
                    onClose: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tag Flutter removida!')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Badges de Status',
            'Badges para indicar status',
            [
              const SizedBox(height: 20),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ShadcnStatusBadge(
                    status: 'Online',
                    isOnline: true,
                  ),
                  ShadcnStatusBadge(
                    status: 'Offline',
                    isOnline: false,
                  ),
                  ShadcnStatusBadge(
                    status: 'Ativo',
                    isOnline: true,
                    size: ShadcnBadgeSize.lg,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Badges Numéricos',
            'Badges com números e contadores',
            [
              const SizedBox(height: 20),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ShadcnNumberBadge(number: 5),
                  ShadcnNumberBadge(number: 42, variant: ShadcnBadgeVariant.success),
                  ShadcnNumberBadge(number: 150, maxCount: 99, variant: ShadcnBadgeVariant.destructive),
                  ShadcnNumberBadge(number: 1, size: ShadcnBadgeSize.sm),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Badges com Ponto (Dot Badge)',
            'Badges que aparecem sobre outros elementos',
            [
              const SizedBox(height: 20),
              const Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ShadcnDotBadge(
                    count: '3',
                    child: Icon(Icons.notifications, size: 32),
                  ),
                  ShadcnDotBadge(
                    count: '12',
                    badgeColor: Colors.green,
                    child: Icon(Icons.message, size: 32),
                  ),
                  ShadcnDotBadge(
                    count: '99+',
                    badgeColor: Colors.orange,
                    child: Icon(Icons.shopping_cart, size: 32),
                  ),
                  ShadcnDotBadge(
                    showBadge: true,
                    child: CircleAvatar(
                      radius: 20,
                      child: Text('JD'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Chips & Tags',
            'Componentes interativos para seleção e filtros',
            [
              const SizedBox(height: 20),
              const Text('Chips de Filtro:'),
              const SizedBox(height: 12),
              ShadcnChipGroup(
                chips: [
                  ShadcnChip.filter(
                    label: 'Todos',
                    selected: _selectedChips.contains('all'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedChips.add('all');
                        } else {
                          _selectedChips.remove('all');
                        }
                      });
                    },
                  ),
                  ShadcnChip.filter(
                    label: 'Frontend',
                    icon: const Icon(Icons.web, size: 16),
                    selected: _selectedChips.contains('frontend'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedChips.add('frontend');
                        } else {
                          _selectedChips.remove('frontend');
                        }
                      });
                    },
                  ),
                  ShadcnChip.filter(
                    label: 'Backend',
                    variant: ShadcnChipVariant.secondary,
                    selected: _selectedChips.contains('backend'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedChips.add('backend');
                        } else {
                          _selectedChips.remove('backend');
                        }
                      });
                    },
                  ),
                  ShadcnChip.filter(
                    label: 'Design',
                    variant: ShadcnChipVariant.outline,
                    selected: _selectedChips.contains('design'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedChips.add('design');
                        } else {
                          _selectedChips.remove('design');
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Tags Removíveis:'),
              const SizedBox(height: 12),
              ShadcnChipGroup(
                chips: _inputChips.map((chip) => ShadcnChip.input(
                  label: chip,
                  onDeleted: () {
                    setState(() {
                      _inputChips.remove(chip);
                    });
                    _showMessage('Tag "$chip" removida');
                  },
                )).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Chips de Ação:'),
              const SizedBox(height: 12),
              ShadcnChipGroup(
                chips: [
                  ShadcnChip.action(
                    label: 'Adicionar Tag',
                    icon: const Icon(Icons.add, size: 16),
                    variant: ShadcnChipVariant.outline,
                    onPressed: () {
                      setState(() {
                        _inputChips.add('Nova Tag ${_inputChips.length + 1}');
                      });
                      _showMessage('Nova tag adicionada!');
                    },
                  ),
                  ShadcnChip.action(
                    label: 'Sucesso',
                    variant: ShadcnChipVariant.success,
                    onPressed: () => _showMessage('Ação de sucesso!'),
                  ),
                  ShadcnChip.action(
                    label: 'Aviso',
                    variant: ShadcnChipVariant.warning,
                    onPressed: () => _showMessage('Aviso acionado!'),
                  ),
                  ShadcnChip.action(
                    label: 'Erro',
                    variant: ShadcnChipVariant.destructive,
                    onPressed: () => _showMessage('Erro simulado!'),
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