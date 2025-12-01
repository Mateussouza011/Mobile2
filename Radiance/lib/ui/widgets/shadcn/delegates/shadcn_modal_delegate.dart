import 'package:flutter/material.dart';
abstract class ShadcnModalDelegate {
  Future<bool> willShow() async {
    return true;
  }
  void didShow() {}
  Future<bool> willClose<T>(T? result) async {
    return true;
  }
  void didClose<T>(T? result) {}
  bool canDismissWithBackdrop() {
    return true;
  }
  bool canDismissWithBackButton() {
    return true;
  }
  Color getBackdropColor(ColorScheme colorScheme) {
    return Colors.black54;
  }
  double getBackdropOpacity() {
    return 0.5;
  }
  Duration getEnterAnimationDuration() {
    return const Duration(milliseconds: 300);
  }
  Duration getExitAnimationDuration() {
    return const Duration(milliseconds: 200);
  }
  Curve getEnterAnimationCurve() {
    return Curves.easeOut;
  }
  Curve getExitAnimationCurve() {
    return Curves.easeIn;
  }
  Widget buildEnterTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
        child: child,
      ),
    );
  }
  bool shouldShowCloseButton() {
    return true;
  }
  Alignment getCloseButtonAlignment() {
    return Alignment.topRight;
  }
  Widget? getCustomCloseButton() {
    return null;
  }
}
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
    final confirmed = await _showConfirmationDialog();
    
    if (confirmed) {
      onConfirmed?.call();
    } else {
      onCancelled?.call();
    }
    
    return confirmed;
  }
  
  Future<bool> _showConfirmationDialog() async {
    return true;
  }
  
  @override
  bool canDismissWithBackdrop() {
    return !hasUnsavedChanges;
  }
  
  @override
  bool canDismissWithBackButton() {
    return !hasUnsavedChanges;
  }
}
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
  }
}
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
enum SlideDirection {
  top,
  bottom,
  left,
  right,
}
class NoBackdropModalDelegate extends DefaultShadcnModalDelegate {
  @override
  double getBackdropOpacity() => 0.0;
  
  @override
  bool canDismissWithBackdrop() => false;
}
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
    });
  }
}
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
