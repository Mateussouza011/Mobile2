import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';
import '../../ui/widgets/shadcn/shadcn_input.dart';
import '../../ui/widgets/shadcn/shadcn_card.dart';

class ComponentShowcasePage extends StatefulWidget {
  const ComponentShowcasePage({super.key});

  @override
  State<ComponentShowcasePage> createState() => _ComponentShowcasePageState();
}

class _ComponentShowcasePageState extends State<ComponentShowcasePage> {
  bool _isExpanded = false;
  bool _isCardSelected = false;
  bool _isLoading = false;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demonstração de Componentes Genéricos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de Botões Genéricos
            _buildSection(
              'Botões Genéricos',
              [
                // Botão padrão
                ShadcnButton(
                  text: 'Botão Padrão',
                  onPressed: () => _showMessage(context, 'Botão padrão pressionado!'),
                ),
                const SizedBox(height: 12),
                
                // Botão outline
                ShadcnButton(
                  text: 'Botão Outline',
                  variant: ShadcnButtonVariant.outline,
                  onPressed: () => _showMessage(context, 'Botão outline pressionado!'),
                ),
                const SizedBox(height: 12),
                
                // Botão secondary
                ShadcnButton(
                  text: 'Botão Secondary',
                  variant: ShadcnButtonVariant.secondary,
                  onPressed: () => _showMessage(context, 'Botão secondary pressionado!'),
                ),
                const SizedBox(height: 12),
                
                // Botão ghost
                ShadcnButton(
                  text: 'Botão Ghost',
                  variant: ShadcnButtonVariant.ghost,
                  onPressed: () => _showMessage(context, 'Botão ghost pressionado!'),
                ),
                const SizedBox(height: 12),
                
                // Botão destructive
                ShadcnButton(
                  text: 'Botão Destructive',
                  variant: ShadcnButtonVariant.destructive,
                  onPressed: () => _showMessage(context, 'Ação destrutiva executada!'),
                ),
                const SizedBox(height: 12),
                
                // Botão com ícone
                ShadcnButton.withLeadingIcon(
                  text: 'Download',
                  leadingIcon: const Icon(Icons.download),
                  onPressed: () => _showMessage(context, 'Iniciando download...'),
                ),
                const SizedBox(height: 12),
                
                // Botão com loading
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
                
                // Botão apenas ícone
                ShadcnButton.icon(
                  icon: const Icon(Icons.favorite),
                  onPressed: () => _showMessage(context, 'Favoritado!'),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção de Inputs Genéricos
            _buildSection(
              'Inputs Genéricos',
              [
                // Input padrão
                const ShadcnInput(
                  label: 'Nome',
                  placeholder: 'Digite seu nome',
                ),
                const SizedBox(height: 16),
                
                // Input para email com validação automática
                const ShadcnInput.email(
                  label: 'Email',
                ),
                const SizedBox(height: 16),
                
                // Input para senha com toggle automático
                const ShadcnInput.password(
                  label: 'Senha',
                  helperText: 'Mínimo 8 caracteres',
                ),
                const SizedBox(height: 16),
                
                // Input de busca
                const ShadcnInput.search(
                  placeholder: 'Buscar...',
                ),
                const SizedBox(height: 16),
                
                // Input com ícones
                const ShadcnInput(
                  label: 'Localização',
                  placeholder: 'Digite seu endereço',
                  prefixIcon: Icon(Icons.location_on),
                ),
                const SizedBox(height: 16),
                
                // Input com validação customizada
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
            
            // Seção de Cards Genéricos
            _buildSection(
              'Cards Genéricos',
              [
                // Card simples
                ShadcnCard.simple(
                  child: const Text('Este é um card simples com conteúdo básico.'),
                  onTap: () => _showMessage(context, 'Card simples tocado!'),
                ),
                const SizedBox(height: 16),
                
                // Card com header e footer
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
                
                // Card expansível
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
                
                // Card selecionável
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
                
                // Card com layout horizontal
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
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
