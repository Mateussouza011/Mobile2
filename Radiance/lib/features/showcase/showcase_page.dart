import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';
import '../../ui/widgets/shadcn/shadcn_input.dart';
import '../../ui/widgets/shadcn/shadcn_card.dart';
import '../../ui/widgets/shadcn/shadcn_chip.dart';
import '../../ui/widgets/shadcn/shadcn_progress.dart';
import '../../ui/widgets/shadcn/shadcn_skeleton.dart';
import '../../ui/widgets/shadcn/shadcn_separator.dart';
import '../../ui/widgets/shadcn/shadcn_accordion.dart';
import '../../ui/widgets/theme_toggle_button.dart';

class ComponentShowcasePage extends StatefulWidget {
  const ComponentShowcasePage({super.key});

  @override
  State<ComponentShowcasePage> createState() => _ComponentShowcasePageState();
}

class _ComponentShowcasePageState extends State<ComponentShowcasePage> {
  bool _isExpanded = false;
  bool _isCardSelected = false;
  bool _isLoading = false;
  bool _showSkeleton = true;
  double _progressValue = 25.0;
  final Set<String> _selectedChips = {};
  final List<String> _inputChips = ['Flutter', 'Dart', 'Mobile'];
  int _currentStep = 1;

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Showcase Avançado',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: const [
          ThemeToggleButton(size: 36),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryContainer.withValues(alpha: 0.1),
                    colorScheme.secondaryContainer.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎨 Design System Showcase',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore a biblioteca completa de componentes Shadcn/UI para Flutter',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '15+ Componentes',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Interativo',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF166534).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Responsivo',
                          style: textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF166534),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Botões Genéricos',
              [
                ShadcnButton(
                  text: 'Botão Padrão',
                  onPressed: () => _showMessage(context, 'Botão padrão pressionado!'),
                ),
                const SizedBox(height: 12),
                ShadcnButton(
                  text: 'Botão Outline',
                  variant: ShadcnButtonVariant.outline,
                  onPressed: () => _showMessage(context, 'Botão outline pressionado!'),
                ),
                const SizedBox(height: 12),
                ShadcnButton(
                  text: 'Botão Secondary',
                  variant: ShadcnButtonVariant.secondary,
                  onPressed: () => _showMessage(context, 'Botão secondary pressionado!'),
                ),
                const SizedBox(height: 12),
                ShadcnButton(
                  text: 'Botão Ghost',
                  variant: ShadcnButtonVariant.ghost,
                  onPressed: () => _showMessage(context, 'Botão ghost pressionado!'),
                ),
                const SizedBox(height: 12),
                ShadcnButton(
                  text: 'Botão Destructive',
                  variant: ShadcnButtonVariant.destructive,
                  onPressed: () => _showMessage(context, 'Ação destrutiva executada!'),
                ),
                const SizedBox(height: 12),
                ShadcnButton.withLeadingIcon(
                  text: 'Download',
                  leadingIcon: const Icon(Icons.download),
                  onPressed: () => _showMessage(context, 'Iniciando download...'),
                ),
                const SizedBox(height: 12),
                ShadcnButton(
                  text: _isLoading ? null : 'Processar',
                  loading: _isLoading,
                  onPressed: _isLoading ? null : () {
                    setState(() => _isLoading = true);
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() => _isLoading = false);
                      _showMessage(context, 'Processamento concluído!');
                    });
                  },
                ),
                const SizedBox(height: 12),
                ShadcnButton.icon(
                  icon: const Icon(Icons.favorite),
                  onPressed: () => _showMessage(context, 'Favoritado!'),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildSection(
              'Inputs Genéricos',
              [
                const ShadcnInput(
                  label: 'Nome',
                  placeholder: 'Digite seu nome',
                ),
                const SizedBox(height: 16),
                const ShadcnInput.email(
                  label: 'Email',
                ),
                const SizedBox(height: 16),
                const ShadcnInput.password(
                  label: 'Senha',
                  helperText: 'Mínimo 8 caracteres',
                ),
                const SizedBox(height: 16),
                const ShadcnInput.search(
                  placeholder: 'Buscar...',
                ),
                const SizedBox(height: 16),
                const ShadcnInput(
                  label: 'Localização',
                  placeholder: 'Digite seu endereço',
                  prefixIcon: Icon(Icons.location_on),
                ),
                const SizedBox(height: 16),
                ShadcnInput(
                  label: 'CEP',
                  placeholder: '00000-000',
                  inputType: ShadcnInputType.text,
                  prefixIcon: const Icon(Icons.location_on),
                  customValidator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final cepRegex = RegExp(r'^\d{5}-?\d{3}$');
                    if (!cepRegex.hasMatch(value)) {
                      return 'CEP inválido. Use o formato 00000-000';
                    }
                    return null;
                  },
                  validateOnChange: true,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildSection(
              'Cards Genéricos',
              [
                ShadcnCard.simple(
                  child: const Text('Este é um card simples com conteúdo básico.'),
                  onTap: () => _showMessage(context, 'Card simples tocado!'),
                ),
                const SizedBox(height: 16),
                ShadcnCard(
                  title: 'Notificações',
                  description: 'Você tem 3 mensagens não lidas.',
                  header: const Row(
                    children: [
                      Icon(Icons.notifications_outlined),
                      SizedBox(width: 8),
                      Text('Sistema'),
                    ],
                  ),
                  footer: Row(
                    children: [
                      ShadcnButton(
                        text: 'Marcar como lidas',
                        variant: ShadcnButtonVariant.ghost,
                        size: ShadcnButtonSize.sm,
                        onPressed: () => _showMessage(context, 'Notificações marcadas!'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ShadcnCard.expandable(
                  title: 'Card Expansível',
                  subtitle: 'Toque para expandir/recolher',
                  leading: const Icon(Icons.info_outline),
                  expanded: _isExpanded,
                  onExpandChanged: (expanded) => setState(() => _isExpanded = expanded),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Conteúdo expandido aqui!'),
                      const SizedBox(height: 8),
                      Text(
                        'Este conteúdo só aparece quando o card está expandido.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      ShadcnButton(
                        text: 'Ação',
                        size: ShadcnButtonSize.sm,
                        variant: ShadcnButtonVariant.outline,
                        onPressed: () => _showMessage(context, 'Ação executada!'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ShadcnCard(
                  title: 'Card Selecionável',
                  description: 'Toque para selecionar/deselecionar',
                  selectable: true,
                  selected: _isCardSelected,
                  onSelectionChanged: (selected) => setState(() => _isCardSelected = selected),
                  variant: _isCardSelected ? ShadcnCardVariant.filled : ShadcnCardVariant.outlined,
                  leading: Icon(
                    _isCardSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: _isCardSelected ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
                const SizedBox(height: 16),
                ShadcnCard(
                  layout: ShadcnCardLayout.horizontal,
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 30,
                    ),
                  ),
                  title: 'João Silva',
                  subtitle: 'Desenvolvedor Flutter',
                  description: 'Especialista em desenvolvimento mobile',
                  trailing: Column(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(
                        '4.9',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  actions: [
                    ShadcnButton.icon(
                      icon: const Icon(Icons.message),
                      size: ShadcnButtonSize.sm,
                      variant: ShadcnButtonVariant.ghost,
                      onPressed: () => _showMessage(context, 'Enviando mensagem...'),
                    ),
                    const SizedBox(width: 8),
                    ShadcnButton.icon(
                      icon: const Icon(Icons.phone),
                      size: ShadcnButtonSize.sm,
                      variant: ShadcnButtonVariant.ghost,
                      onPressed: () => _showMessage(context, 'Fazendo ligação...'),
                    ),
                  ],
                  onTap: () => _showMessage(context, 'Perfil de João Silva'),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildSection(
              'Chips & Tags',
              [
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
                      _showMessage(context, 'Tag "$chip" removida');
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
                        _showMessage(context, 'Nova tag adicionada!');
                      },
                    ),
                    ShadcnChip.action(
                      label: 'Sucesso',
                      variant: ShadcnChipVariant.success,
                      onPressed: () => _showMessage(context, 'Ação de sucesso!'),
                    ),
                    ShadcnChip.action(
                      label: 'Aviso',
                      variant: ShadcnChipVariant.warning,
                      onPressed: () => _showMessage(context, 'Aviso acionado!'),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildSection(
              'Progress & Loading',
              [
                const Text('Progress Linear:'),
                const SizedBox(height: 12),
                ShadcnProgress.linear(
                  value: _progressValue,
                  label: 'Upload Progress',
                  showPercentage: true,
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _progressValue,
                  max: 100,
                  onChanged: (value) => setState(() => _progressValue = value),
                  label: '${_progressValue.toInt()}%',
                ),
                const SizedBox(height: 20),
                const Text('Progress Circular:'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ShadcnProgress.circular(
                      value: _progressValue,
                      size: ShadcnProgressSize.sm,
                    ),
                    const SizedBox(width: 16),
                    ShadcnProgress.circular(
                      value: _progressValue,
                      variant: ShadcnProgressVariant.secondary,
                    ),
                    const SizedBox(width: 16),
                    ShadcnProgress.circular(
                      value: _progressValue,
                      size: ShadcnProgressSize.lg,
                      variant: ShadcnProgressVariant.success,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Loading Indeterminado:'),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    ShadcnProgress.indeterminate(
                      type: ShadcnProgressType.linear,
                    ),
                    SizedBox(width: 16),
                    ShadcnProgress.indeterminate(
                      type: ShadcnProgressType.circular,
                      size: ShadcnProgressSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Progress em Etapas:'),
                const SizedBox(height: 12),
                ShadcnStepProgress(
                  currentStep: _currentStep,
                  totalSteps: 4,
                  stepLabels: const ['Início', 'Processando', 'Validando', 'Concluído'],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ShadcnButton(
                      text: 'Anterior',
                      variant: ShadcnButtonVariant.outline,
                      size: ShadcnButtonSize.sm,
                      onPressed: _currentStep > 0 ? () {
                        setState(() => _currentStep--);
                      } : null,
                    ),
                    const SizedBox(width: 8),
                    ShadcnButton(
                      text: 'Próximo',
                      size: ShadcnButtonSize.sm,
                      onPressed: _currentStep < 3 ? () {
                        setState(() => _currentStep++);
                      } : null,
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildSection(
              'Skeleton & Placeholders',
              [
                Row(
                  children: [
                    const Text('Mostrar Skeleton:'),
                    const SizedBox(width: 16),
                    Switch(
                      value: _showSkeleton,
                      onChanged: (value) => setState(() => _showSkeleton = value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (_showSkeleton) ...[
                  ShadcnSkeletonTemplates.listItem(),
                  const SizedBox(height: 16),
                  ShadcnSkeletonTemplates.userProfile(),
                  const SizedBox(height: 16),
                  ShadcnSkeletonTemplates.productCard(),
                ] else ...[
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('João Silva', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('Desenvolvedor Flutter experiente'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.favorite, color: Colors.red.shade300),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Conteúdo carregado com sucesso!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 32),
            _buildSection(
              'Layout & Separators',
              [
                const Text('Separadores Horizontais:'),
                const SizedBox(height: 12),
                const ShadcnSeparator.horizontal(),
                const SizedBox(height: 12),
                const ShadcnSeparator.dashed(),
                const SizedBox(height: 12),
                const ShadcnSeparator.dotted(),
                const SizedBox(height: 12),
                ShadcnSeparator.gradient(
                  gradientColors: [
                    Colors.transparent,
                    Theme.of(context).colorScheme.primary,
                    Colors.transparent,
                  ],
                ),
                const SizedBox(height: 20),
                
                const Text('Separadores com Labels:'),
                const SizedBox(height: 12),
                const ShadcnSeparator.horizontal(
                  label: 'OU',
                ),
                const SizedBox(height: 12),
                const ShadcnSeparator.horizontal(
                  label: 'CONTINUAR COM',
                  variant: ShadcnSeparatorVariant.dashed,
                ),
                const SizedBox(height: 20),
                const ShadcnSection(
                  title: 'Configurações de Conta',
                  subtitle: 'Gerencie suas preferências pessoais',
                  showTopSeparator: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Perfil'),
                          subtitle: Text('Editar informações pessoais'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                        ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text('Notificações'),
                          subtitle: Text('Configurar alertas'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildSection(
              'Navigation & Accordion',
              [
                const Text('FAQ Accordion:'),
                const SizedBox(height: 12),
                const ShadcnFAQAccordion(
                  faqs: [
                    (question: 'Como usar o Design System?', answer: 'O Design System Flutter fornece componentes reutilizáveis que seguem as diretrizes do Shadcn/UI.'),
                    (question: 'Os componentes são customizáveis?', answer: 'Sim! Todos os componentes oferecem várias propriedades para personalização de cores, tamanhos e comportamentos.'),
                    (question: 'Como contribuir?', answer: 'Você pode contribuir criando issues, enviando pull requests ou sugerindo melhorias na documentação.'),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Settings Accordion:'),
                const SizedBox(height: 12),
                ShadcnSettingsAccordion(
                  sections: [
                    (
                      title: 'Aparência',
                      description: 'Personalizar tema e layout',
                      settings: [
                        ListTile(
                          title: const Text('Tema Escuro'),
                          trailing: Switch(value: false, onChanged: (_) {}),
                        ),
                        ListTile(
                          title: const Text('Tamanho da Fonte'),
                          trailing: DropdownButton<String>(
                            value: 'Médio',
                            items: ['Pequeno', 'Médio', 'Grande'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),
                        ),
                      ],
                    ),
                    (
                      title: 'Notificações',
                      description: 'Controlar alertas e lembretes',
                      settings: [
                        ListTile(
                          title: const Text('Push Notifications'),
                          trailing: Switch(value: true, onChanged: (_) {}),
                        ),
                        ListTile(
                          title: const Text('Email Notifications'),
                          trailing: Switch(value: false, onChanged: (_) {}),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
