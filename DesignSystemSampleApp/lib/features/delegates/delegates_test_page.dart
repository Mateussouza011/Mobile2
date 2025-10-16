import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/delegates/shadcn_input_delegate.dart';
import '../../ui/widgets/shadcn/delegates/shadcn_card_delegate.dart';
import '../../ui/widgets/shadcn/delegates/shadcn_progress_delegate.dart';
import '../../ui/widgets/shadcn/delegates/shadcn_slider_delegate.dart';
import '../../ui/widgets/shadcn/delegates/shadcn_modal_delegate.dart';

/// Página para testar todos os delegates implementados
class DelegatesTestPage extends StatefulWidget {
  const DelegatesTestPage({super.key});

  @override
  State<DelegatesTestPage> createState() => _DelegatesTestPageState();
}

class _DelegatesTestPageState extends State<DelegatesTestPage> {
  // Controllers para inputs
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Delegates
  late final CPFInputDelegate _cpfDelegate;
  late final EmailInputDelegate _emailDelegate;
  late final PhoneInputDelegate _phoneDelegate;
  late final PasswordInputDelegate _passwordDelegate;
  
  // Estados para cards
  bool _isCardSelected = false;
  bool _isCardExpanded = false;
  
  // Estados para progress
  double _progress = 0.0;
  
  // Estados para sliders
  double _volumeValue = 0.5;
  double _temperatureValue = 22.0;
  double _priceValue = 100.0;
  double _brightnessValue = 0.7;
  
  @override
  void initState() {
    super.initState();
    _startProgressSimulation();
  }
  
  void _startProgressSimulation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _progress < 1.0) {
        setState(() {
          _progress += 0.01;
        });
        _startProgressSimulation();
      }
    });
  }
  
  @override
  void dispose() {
    _cpfController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testes dos Delegates'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputDelegatesSection(colorScheme),
            const SizedBox(height: 32),
            _buildCardDelegatesSection(colorScheme),
            const SizedBox(height: 32),
            _buildProgressDelegatesSection(colorScheme),
            const SizedBox(height: 32),
            _buildSliderDelegatesSection(colorScheme),
            const SizedBox(height: 32),
            _buildModalDelegatesSection(colorScheme),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInputDelegatesSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Input Delegates',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // CPF Input Delegate
        _buildTestCard(
          colorScheme,
          'CPF Input Delegate',
          TestInputWidget(
            controller: _cpfController,
            delegate: CPFInputDelegate(),
            label: 'CPF',
          ),
        ),
        const SizedBox(height: 12),
        
        // Email Input Delegate
        _buildTestCard(
          colorScheme,
          'Email Input Delegate',
          TestInputWidget(
            controller: _emailController,
            delegate: EmailInputDelegate(),
            label: 'Email',
          ),
        ),
        const SizedBox(height: 12),
        
        // Phone Input Delegate
        _buildTestCard(
          colorScheme,
          'Phone Input Delegate',
          TestInputWidget(
            controller: _phoneController,
            delegate: PhoneInputDelegate(),
            label: 'Telefone',
          ),
        ),
        const SizedBox(height: 12),
        
        // Password Input Delegate
        _buildTestCard(
          colorScheme,
          'Password Input Delegate',
          TestInputWidget(
            controller: _passwordController,
            delegate: PasswordInputDelegate(),
            label: 'Senha',
          ),
        ),
      ],
    );
  }
  
  Widget _buildCardDelegatesSection(ColorScheme colorScheme) {
    final selectableDelegate = SelectableCardDelegate(
      isSelected: _isCardSelected,
      onSelectionChanged: (selected) {
        setState(() => _isCardSelected = selected);
      },
    );
    
    final expandableDelegate = ExpandableCardDelegate(
      isExpanded: _isCardExpanded,
      onExpandChanged: (expanded) {
        setState(() => _isCardExpanded = expanded);
      },
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. Card Delegates',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        _buildTestCard(
          colorScheme,
          'Selectable Card',
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selectableDelegate.getBackgroundColor(colorScheme),
              border: Border.all(
                color: selectableDelegate.getBorderColor(colorScheme),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _isCardSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isCardSelected ? 'Card Selecionado' : 'Clique para selecionar',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () => selectableDelegate.onCardTap(),
        ),
        const SizedBox(height: 12),
        
        _buildTestCard(
          colorScheme,
          'Expandable Card',
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Card Expansível',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      _isCardExpanded ? Icons.expand_less : Icons.expand_more,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
                if (_isCardExpanded) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Conteúdo expandido do card. Aqui você pode colocar informações adicionais.',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                ],
              ],
            ),
          ),
          onTap: () => expandableDelegate.onCardTap(),
        ),
      ],
    );
  }
  
  Widget _buildProgressDelegatesSection(ColorScheme colorScheme) {
    final downloadDelegate = DownloadProgressDelegate(
      totalBytes: 104857600, // 100 MB
    );
    
    final gradualColorDelegate = GradualColorProgressDelegate();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3. Progress Delegates',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        _buildTestCard(
          colorScheme,
          'Download Progress',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  downloadDelegate.getProgressColor(_progress, colorScheme),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                downloadDelegate.getProgressText(_progress),
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        _buildTestCard(
          colorScheme,
          'Gradual Color Progress',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  gradualColorDelegate.getProgressColor(_progress, colorScheme),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Progresso: ${(_progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSliderDelegatesSection(ColorScheme colorScheme) {
    final volumeDelegate = VolumeSliderDelegate(
      onVolumeChanged: (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Volume alterado: ${(value * 100).toInt()}%')),
        );
      },
    );
    
    final tempDelegate = TemperatureSliderDelegate(
      onTemperatureChanged: (value) {
        print('Temperatura: ${value.toInt()}°C');
      },
    );
    
    final priceDelegate = PriceRangeSliderDelegate(
      onPriceChanged: (value) {
        print('Preço: R\$ ${value.toStringAsFixed(2)}');
      },
    );
    
    final brightnessDelegate = BrightnessSliderDelegate(
      onBrightnessChanged: (value) {
        print('Brilho: ${(value * 100).toInt()}%');
      },
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '4. Slider Delegates',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        _buildTestCard(
          colorScheme,
          'Volume Slider',
          Row(
            children: [
              if (volumeDelegate.getLeadingWidget(_volumeValue) != null)
                volumeDelegate.getLeadingWidget(_volumeValue)!,
              Expanded(
                child: Slider(
                  value: _volumeValue,
                  divisions: volumeDelegate.getSliderDivisions(0, 1),
                  label: volumeDelegate.formatSliderLabel(_volumeValue),
                  activeColor: volumeDelegate.getSliderColor(_volumeValue, colorScheme),
                  onChangeStart: volumeDelegate.onSliderChangeStart,
                  onChanged: (value) {
                    setState(() => _volumeValue = volumeDelegate.snapValue(value));
                    volumeDelegate.onSliderChanged(value);
                  },
                  onChangeEnd: volumeDelegate.onSliderChangeEnd,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        _buildTestCard(
          colorScheme,
          'Temperature Slider',
          Row(
            children: [
              if (tempDelegate.getLeadingWidget(_temperatureValue) != null)
                tempDelegate.getLeadingWidget(_temperatureValue)!,
              Expanded(
                child: Slider(
                  value: _temperatureValue,
                  min: 0,
                  max: 40,
                  divisions: tempDelegate.getSliderDivisions(0, 40),
                  label: tempDelegate.formatSliderLabel(_temperatureValue),
                  activeColor: tempDelegate.getSliderColor(_temperatureValue, colorScheme),
                  onChanged: (value) {
                    setState(() => _temperatureValue = value);
                    tempDelegate.onSliderChanged(value);
                  },
                  onChangeEnd: tempDelegate.onSliderChangeEnd,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        _buildTestCard(
          colorScheme,
          'Price Range Slider',
          Row(
            children: [
              if (priceDelegate.getLeadingWidget(_priceValue) != null)
                priceDelegate.getLeadingWidget(_priceValue)!,
              Expanded(
                child: Slider(
                  value: _priceValue,
                  min: 0,
                  max: 1000,
                  label: priceDelegate.formatSliderLabel(_priceValue),
                  onChanged: (value) {
                    setState(() => _priceValue = priceDelegate.snapValue(value));
                    priceDelegate.onSliderChanged(value);
                  },
                  onChangeEnd: priceDelegate.onSliderChangeEnd,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        _buildTestCard(
          colorScheme,
          'Brightness Slider',
          Row(
            children: [
              if (brightnessDelegate.getLeadingWidget(_brightnessValue) != null)
                brightnessDelegate.getLeadingWidget(_brightnessValue)!,
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: _brightnessValue,
                  divisions: brightnessDelegate.getSliderDivisions(0, 1),
                  label: brightnessDelegate.formatSliderLabel(_brightnessValue),
                  onChanged: (value) {
                    setState(() => _brightnessValue = value);
                    brightnessDelegate.onSliderChanged(value);
                  },
                  onChangeEnd: brightnessDelegate.onSliderChangeEnd,
                ),
              ),
              const SizedBox(width: 8),
              if (brightnessDelegate.getTrailingWidget(_brightnessValue) != null)
                brightnessDelegate.getTrailingWidget(_brightnessValue)!,
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildModalDelegatesSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5. Modal Delegates',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        _buildTestCard(
          colorScheme,
          'Modal Delegates',
          Column(
            children: [
              ElevatedButton(
                onPressed: () => _showTrackedModal(colorScheme),
                child: const Text('Abrir Modal com Tracking'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _showConfirmationModal(colorScheme),
                child: const Text('Abrir Modal de Confirmação'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _showSlideModal(colorScheme),
                child: const Text('Abrir Modal com Slide'),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _showTrackedModal(ColorScheme colorScheme) {
    final delegate = TrackedModalDelegate(
      modalName: 'test_modal',
      analyticsCallback: (eventName, properties) {
        print('Analytics: $eventName - $properties');
      },
    );
    
    delegate.willShow().then((canShow) {
      if (canShow) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Modal com Tracking'),
            content: const Text('Este modal registra eventos de abertura e fechamento.'),
            actions: [
              TextButton(
                onPressed: () {
                  delegate.willClose(null).then((canClose) {
                    if (canClose) {
                      Navigator.pop(context);
                      delegate.didClose(null);
                    }
                  });
                },
                child: const Text('Fechar'),
              ),
            ],
          ),
        ).then((_) => delegate.didShow());
      }
    });
  }
  
  void _showConfirmationModal(ColorScheme colorScheme) {
    final delegate = ConfirmationModalDelegate(
      hasUnsavedChanges: true,
      onConfirmed: () => print('Confirmado'),
      onCancelled: () => print('Cancelado'),
    );
    
    showDialog(
      context: context,
      barrierDismissible: delegate.canDismissWithBackdrop(),
      builder: (context) => AlertDialog(
        title: const Text('Modal de Confirmação'),
        content: const Text('Este modal exige confirmação para fechar.'),
        actions: [
          TextButton(
            onPressed: () {
              delegate.willClose(false).then((canClose) {
                if (canClose) {
                  Navigator.pop(context);
                }
              });
            },
            child: const Text('Tentar Fechar'),
          ),
        ],
      ),
    );
  }
  
  void _showSlideModal(ColorScheme colorScheme) {
    final delegate = SlideModalDelegate(slideDirection: SlideDirection.bottom);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Modal com Slide',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Este modal entra com animação de slide.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTestCard(
    ColorScheme colorScheme,
    String title,
    Widget child, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Widget de teste para input delegates
class TestInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final ShadcnInputDelegate delegate;
  final String label;
  
  const TestInputWidget({
    super.key,
    required this.controller,
    required this.delegate,
    required this.label,
  });

  @override
  State<TestInputWidget> createState() => _TestInputWidgetState();
}

class _TestInputWidgetState extends State<TestInputWidget> {
  String? _errorText;
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.delegate.getHelperText(widget.controller.text),
        errorText: _errorText,
        prefixIcon: widget.delegate.getPrefixIcon(widget.controller.text),
        suffixIcon: widget.delegate.getSuffixIcon(widget.controller.text),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.delegate.getBorderColor(widget.controller.text, colorScheme),
          ),
        ),
      ),
      obscureText: widget.delegate.shouldObscureText(widget.controller.text),
      keyboardType: widget.delegate.getKeyboardType(),
      onChanged: (value) {
        setState(() {
          final formatted = widget.delegate.formatInput(value);
          if (formatted != value) {
            widget.controller.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }
          
          final validation = widget.delegate.validateInput(value);
          _errorText = validation.isValid ? null : validation.errorMessage;
        });
        
        widget.delegate.onInputChanged(value);
      },
    );
  }
}
