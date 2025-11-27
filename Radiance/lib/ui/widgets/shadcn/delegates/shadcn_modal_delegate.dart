import 'package:flutter/material.dart';

/// Delegate para customizar o comportamento de modais do Shadcn
/// 
/// Este delegate permite centralizar toda a lógica de modais,
/// incluindo lifecycle hooks, animações, backdrop behavior e validação,
/// seguindo o padrão Delegate para desacoplamento e reutilização.
abstract class ShadcnModalDelegate {
  /// Chamado imediatamente antes do modal ser exibido
  /// 
  /// Retorna false para cancelar a exibição do modal
  Future<bool> willShow() async {
    return true;
  }
  
  /// Chamado imediatamente após o modal ser exibido
  void didShow() {}
  
  /// Chamado quando o usuário tenta fechar o modal
  /// 
  /// [result] é o valor que será retornado ao fechar
  /// Retorna false para impedir o fechamento
  Future<bool> willClose<T>(T? result) async {
    return true;
  }
  
  /// Chamado após o modal ser fechado
  /// 
  /// [result] é o valor retornado pelo modal
  void didClose<T>(T? result) {}
  
  /// Define se o modal pode ser fechado tocando no backdrop
  bool canDismissWithBackdrop() {
    return true;
  }
  
  /// Define se o modal pode ser fechado com o botão de voltar
  bool canDismissWithBackButton() {
    return true;
  }
  
  /// Define a cor do backdrop
  Color getBackdropColor(ColorScheme colorScheme) {
    return Colors.black54;
  }
  
  /// Define a opacidade do backdrop (0.0 a 1.0)
  double getBackdropOpacity() {
    return 0.5;
  }
  
  /// Define a duração da animação de entrada
  Duration getEnterAnimationDuration() {
    return const Duration(milliseconds: 300);
  }
  
  /// Define a duração da animação de saída
  Duration getExitAnimationDuration() {
    return const Duration(milliseconds: 200);
  }
  
  /// Define a curva de animação de entrada
  Curve getEnterAnimationCurve() {
    return Curves.easeOut;
  }
  
  /// Define a curva de animação de saída
  Curve getExitAnimationCurve() {
    return Curves.easeIn;
  }
  
  /// Constrói a animação customizada para entrada
  /// 
  /// [animation] é a animação principal
  /// [child] é o conteúdo do modal
  Widget buildEnterTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
        child: child,
      ),
    );
  }
  
  /// Define se deve exibir o botão de fechar padrão
  bool shouldShowCloseButton() {
    return true;
  }
  
  /// Define a posição do botão de fechar
  Alignment getCloseButtonAlignment() {
    return Alignment.topRight;
  }
  
  /// Widget customizado para o botão de fechar
  Widget? getCustomCloseButton() {
    return null;
  }
}

/// Implementação padrão do ShadcnModalDelegate
/// 
/// Fornece comportamento básico sem customizações.
class DefaultShadcnModalDelegate implements ShadcnModalDelegate {
  @override
  Future<bool> willShow() async => true;
  
  @override
  void didShow() {}
  
  @override
  Future<bool> willClose<T>(T? result) async => true;
  
  @override
  void didClose<T>(T? result) {}
  
  @override
  bool canDismissWithBackdrop() => true;
  
  @override
  bool canDismissWithBackButton() => true;
  
  @override
  Color getBackdropColor(ColorScheme colorScheme) => Colors.black54;
  
  @override
  double getBackdropOpacity() => 0.5;
  
  @override
  Duration getEnterAnimationDuration() => const Duration(milliseconds: 300);
  
  @override
  Duration getExitAnimationDuration() => const Duration(milliseconds: 200);
  
  @override
  Curve getEnterAnimationCurve() => Curves.easeOut;
  
  @override
  Curve getExitAnimationCurve() => Curves.easeIn;
  
  @override
  Widget buildEnterTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
        child: child,
      ),
    );
  }
  
  @override
  bool shouldShowCloseButton() => true;
  
  @override
  Alignment getCloseButtonAlignment() => Alignment.topRight;
  
  @override
  Widget? getCustomCloseButton() => null;
}

/// Delegate para modais de confirmação
/// 
/// Exige confirmação dupla antes de fechar com alterações não salvas.
class ConfirmationModalDelegate extends DefaultShadcnModalDelegate {
  final bool hasUnsavedChanges;
  final String confirmationMessage;
  final Function()? onConfirmed;
  final Function()? onCancelled;
  
  ConfirmationModalDelegate({
    this.hasUnsavedChanges = false,
    this.confirmationMessage = 'Você tem alterações não salvas. Deseja realmente sair?',
    this.onConfirmed,
    this.onCancelled,
  });
  
  @override
  Future<bool> willClose<T>(T? result) async {
    if (!hasUnsavedChanges) {
      return true;
    }
    
    // Aqui você mostraria um dialog de confirmação
    // Por enquanto, retornamos false para demonstração
    final confirmed = await _showConfirmationDialog();
    
    if (confirmed) {
      onConfirmed?.call();
    } else {
      onCancelled?.call();
    }
    
    return confirmed;
  }
  
  Future<bool> _showConfirmationDialog() async {
    // Implementação simplificada - você usaria showDialog aqui
    return true;
  }
  
  @override
  bool canDismissWithBackdrop() {
    // Não permite fechar com backdrop se houver alterações não salvas
    return !hasUnsavedChanges;
  }
  
  @override
  bool canDismissWithBackButton() {
    // Não permite fechar com botão voltar se houver alterações não salvas
    return !hasUnsavedChanges;
  }
}

/// Delegate para modais com tracking/analytics
/// 
/// Registra eventos de abertura, fechamento e interações.
class TrackedModalDelegate extends DefaultShadcnModalDelegate {
  final String modalName;
  final Map<String, dynamic>? additionalProperties;
  final Function(String, Map<String, dynamic>)? analyticsCallback;
  
  DateTime? _openedAt;
  
  TrackedModalDelegate({
    required this.modalName,
    this.additionalProperties,
    this.analyticsCallback,
  });
  
  @override
  Future<bool> willShow() async {
    _openedAt = DateTime.now();
    
    _trackEvent('modal_opened', {
      'modal_name': modalName,
      'opened_at': _openedAt!.toIso8601String(),
      ...?additionalProperties,
    });
    
    return true;
  }
  
  @override
  void didClose<T>(T? result) {
    final closedAt = DateTime.now();
    final duration = _openedAt != null 
        ? closedAt.difference(_openedAt!).inSeconds 
        : 0;
    
    _trackEvent('modal_closed', {
      'modal_name': modalName,
      'closed_at': closedAt.toIso8601String(),
      'duration_seconds': duration,
      'result': result?.toString(),
      ...?additionalProperties,
    });
  }
  
  void _trackEvent(String eventName, Map<String, dynamic> properties) {
    analyticsCallback?.call(eventName, properties);
    // Exemplo: analytics.logEvent(name: eventName, parameters: properties);
  }
}

/// Delegate para modais com backdrop customizado
/// 
/// Permite backdrop com blur e cores personalizadas.
class CustomBackdropModalDelegate extends DefaultShadcnModalDelegate {
  final Color backdropColor;
  final double backdropOpacity;
  final bool enableBackdropBlur;
  final double blurIntensity;
  
  CustomBackdropModalDelegate({
    this.backdropColor = Colors.black,
    this.backdropOpacity = 0.5,
    this.enableBackdropBlur = false,
    this.blurIntensity = 5.0,
  });
  
  @override
  Color getBackdropColor(ColorScheme colorScheme) => backdropColor;
  
  @override
  double getBackdropOpacity() => backdropOpacity;
}

/// Delegate para modais com animação de slide
/// 
/// Modal entra deslizando de uma direção específica.
class SlideModalDelegate extends DefaultShadcnModalDelegate {
  final SlideDirection slideDirection;
  
  SlideModalDelegate({
    this.slideDirection = SlideDirection.bottom,
  });
  
  @override
  Widget buildEnterTransition(Animation<double> animation, Widget child) {
    Offset beginOffset;
    
    switch (slideDirection) {
      case SlideDirection.top:
        beginOffset = const Offset(0.0, -1.0);
        break;
      case SlideDirection.bottom:
        beginOffset = const Offset(0.0, 1.0);
        break;
      case SlideDirection.left:
        beginOffset = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.right:
        beginOffset = const Offset(1.0, 0.0);
        break;
    }
    
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: child,
    );
  }
  
  @override
  Duration getEnterAnimationDuration() => const Duration(milliseconds: 400);
}

/// Enum para direção do slide
enum SlideDirection {
  top,
  bottom,
  left,
  right,
}

/// Delegate para modais sem backdrop
/// 
/// Modal aparece sem escurecer o fundo.
class NoBackdropModalDelegate extends DefaultShadcnModalDelegate {
  @override
  double getBackdropOpacity() => 0.0;
  
  @override
  bool canDismissWithBackdrop() => false;
}

/// Delegate para modais de loading
/// 
/// Impede fechamento até que uma operação seja concluída.
class LoadingModalDelegate extends DefaultShadcnModalDelegate {
  bool isLoading;
  
  LoadingModalDelegate({this.isLoading = true});
  
  @override
  bool canDismissWithBackdrop() => !isLoading;
  
  @override
  bool canDismissWithBackButton() => !isLoading;
  
  @override
  Future<bool> willClose<T>(T? result) async => !isLoading;
  
  @override
  bool shouldShowCloseButton() => !isLoading;
  
  void setLoading(bool loading) {
    isLoading = loading;
  }
}

/// Delegate para modais com tempo limite
/// 
/// Fecha automaticamente após um período de tempo.
class TimedModalDelegate extends DefaultShadcnModalDelegate {
  final Duration duration;
  final Function()? onTimeout;
  
  TimedModalDelegate({
    required this.duration,
    this.onTimeout,
  });
  
  @override
  void didShow() {
    Future.delayed(duration, () {
      onTimeout?.call();
      // Aqui você chamaria Navigator.pop() ou similar
    });
  }
}

/// Delegate para modais fullscreen
/// 
/// Modal ocupa toda a tela com animação de fade.
class FullscreenModalDelegate extends DefaultShadcnModalDelegate {
  @override
  Widget buildEnterTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
  
  @override
  Duration getEnterAnimationDuration() => const Duration(milliseconds: 200);
  
  @override
  Duration getExitAnimationDuration() => const Duration(milliseconds: 200);
  
  @override
  double getBackdropOpacity() => 0.0;
}

/// Delegate combinado para modais complexos
/// 
/// Combina tracking, confirmação e backdrop customizado.
class ComplexModalDelegate extends DefaultShadcnModalDelegate {
  final String modalName;
  final bool hasUnsavedChanges;
  final Color backdropColor;
  final Function(String, Map<String, dynamic>)? analyticsCallback;
  
  DateTime? _openedAt;
  
  ComplexModalDelegate({
    required this.modalName,
    this.hasUnsavedChanges = false,
    this.backdropColor = Colors.black,
    this.analyticsCallback,
  });
  
  @override
  Future<bool> willShow() async {
    _openedAt = DateTime.now();
    analyticsCallback?.call('modal_opened', {'modal_name': modalName});
    return true;
  }
  
  @override
  Future<bool> willClose<T>(T? result) async {
    if (hasUnsavedChanges) {
      // Mostrar confirmação
      return false;
    }
    return true;
  }
  
  @override
  void didClose<T>(T? result) {
    final duration = _openedAt != null 
        ? DateTime.now().difference(_openedAt!).inSeconds 
        : 0;
    
    analyticsCallback?.call('modal_closed', {
      'modal_name': modalName,
      'duration_seconds': duration,
    });
  }
  
  @override
  Color getBackdropColor(ColorScheme colorScheme) => backdropColor;
  
  @override
  bool canDismissWithBackdrop() => !hasUnsavedChanges;
}
