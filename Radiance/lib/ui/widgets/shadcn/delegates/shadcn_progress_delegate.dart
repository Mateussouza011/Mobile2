import 'package:flutter/material.dart';
abstract class ShadcnProgressDelegate {
  void onProgressChanged(double value) {}
  void onProgressCompleted() {}
  Color getProgressColor(double value, ColorScheme colorScheme) {
    return colorScheme.primary;
  }
  Color getBackgroundColor(double value, ColorScheme colorScheme) {
    return colorScheme.surfaceContainerHighest;
  }
  String getProgressText(double value) {
    return '${(value * 100).toInt()}%';
  }
  bool shouldAnimate() {
    return true;
  }
  Duration getIndeterminateAnimationDuration() {
    return const Duration(seconds: 2);
  }
  Duration getValueChangeAnimationDuration() {
    return const Duration(milliseconds: 300);
  }
  bool shouldShowText() {
    return false;
  }
  IconData? getCompletionIcon() {
    return Icons.check_circle;
  }
}
class DefaultShadcnProgressDelegate implements ShadcnProgressDelegate {
  @override
  void onProgressChanged(double value) {}
  
  @override
  void onProgressCompleted() {}
  
  @override
  Color getProgressColor(double value, ColorScheme colorScheme) {
    return colorScheme.primary;
  }
  
  @override
  Color getBackgroundColor(double value, ColorScheme colorScheme) {
    return colorScheme.surfaceContainerHighest;
  }
  
  @override
  String getProgressText(double value) {
    return '${(value * 100).toInt()}%';
  }
  
  @override
  bool shouldAnimate() => true;
  
  @override
  Duration getIndeterminateAnimationDuration() {
    return const Duration(seconds: 2);
  }
  
  @override
  Duration getValueChangeAnimationDuration() {
    return const Duration(milliseconds: 300);
  }
  
  @override
  bool shouldShowText() => false;
  
  @override
  IconData? getCompletionIcon() => Icons.check_circle;
}
class DownloadProgressDelegate extends DefaultShadcnProgressDelegate {
  final Function()? onDownloadComplete;
  final double totalSizeMB;
  
  DownloadProgressDelegate({
    this.onDownloadComplete,
    this.totalSizeMB = 100.0,
  });
  
  @override
  void onProgressCompleted() {
    onDownloadComplete?.call();
  }
  
  @override
  Color getProgressColor(double value, ColorScheme colorScheme) {
    if (value >= 1.0) return Colors.green;
    if (value >= 0.5) return colorScheme.primary;
    return Colors.orange;
  }
  
  @override
  String getProgressText(double value) {
    final downloadedMB = (value * totalSizeMB).toStringAsFixed(1);
    return 'Baixando... $downloadedMB / ${totalSizeMB.toStringAsFixed(1)} MB';
  }
  
  @override
  bool shouldShowText() => true;
  
  @override
  void onProgressChanged(double value) {
    if (value >= 1.0) {
      onProgressCompleted();
    }
  }
}
class UploadProgressDelegate extends DefaultShadcnProgressDelegate {
  final Function()? onUploadComplete;
  final Function(String error)? onUploadError;
  final String fileName;
  
  UploadProgressDelegate({
    this.onUploadComplete,
    this.onUploadError,
    this.fileName = 'arquivo',
  });
  
  @override
  void onProgressCompleted() {
    onUploadComplete?.call();
  }
  
  @override
  Color getProgressColor(double value, ColorScheme colorScheme) {
    if (value >= 1.0) return Colors.green;
    return colorScheme.primary;
  }
  
  @override
  String getProgressText(double value) {
    if (value >= 1.0) return 'Upload completo!';
    return 'Enviando $fileName... ${(value * 100).toInt()}%';
  }
  
  @override
  bool shouldShowText() => true;
  
  @override
  IconData? getCompletionIcon() => Icons.cloud_done;
}
class GradualColorProgressDelegate extends DefaultShadcnProgressDelegate {
  @override
  Color getProgressColor(double value, ColorScheme colorScheme) {
    if (value >= 0.9) return Colors.green;
    if (value >= 0.7) return Colors.lightGreen;
    if (value >= 0.5) return Colors.orange;
    if (value >= 0.3) return Colors.deepOrange;
    return Colors.red;
  }
  
  @override
  String getProgressText(double value) {
    if (value >= 0.9) return 'Quase lá! ${(value * 100).toInt()}%';
    if (value >= 0.5) return 'Metade feita! ${(value * 100).toInt()}%';
    if (value >= 0.3) return 'Progredindo... ${(value * 100).toInt()}%';
    return 'Iniciando... ${(value * 100).toInt()}%';
  }
  
  @override
  bool shouldShowText() => true;
}
class PageLoadingProgressDelegate extends DefaultShadcnProgressDelegate {
  final VoidCallback? onLoadComplete;
  
  PageLoadingProgressDelegate({this.onLoadComplete});
  
  @override
  void onProgressCompleted() {
    onLoadComplete?.call();
  }
  
  @override
  Color getProgressColor(double value, ColorScheme colorScheme) {
    return colorScheme.primary;
  }
  
  @override
  Duration getValueChangeAnimationDuration() {
    return const Duration(milliseconds: 150); 
  }
  
  @override
  bool shouldShowText() => false; 
}
class StepProgressDelegate extends DefaultShadcnProgressDelegate {
  final int totalSteps;
  final List<String> stepNames;
  
  StepProgressDelegate({
    required this.totalSteps,
    this.stepNames = const [],
  });
  
  @override
  String getProgressText(double value) {
    final currentStep = (value * totalSteps).ceil();
    if (currentStep >= totalSteps) {
      return 'Etapa $totalSteps de $totalSteps - Completo!';
    }
    
    if (stepNames.isNotEmpty && currentStep > 0 && currentStep <= stepNames.length) {
      return 'Etapa $currentStep de $totalSteps - ${stepNames[currentStep - 1]}';
    }
    
    return 'Etapa $currentStep de $totalSteps';
  }
  
  @override
  bool shouldShowText() => true;
  
  @override
  Color getProgressColor(double value, ColorScheme colorScheme) {
    final currentStep = (value * totalSteps).ceil();
    if (currentStep >= totalSteps) return Colors.green;
    return colorScheme.primary;
  }
}
class TrackedProgressDelegate extends DefaultShadcnProgressDelegate {
  final String progressId;
  final Function(String event, Map<String, dynamic> data)? onAnalyticsEvent;
  
  TrackedProgressDelegate({
    required this.progressId,
    this.onAnalyticsEvent,
  });
  
  @override
  void onProgressChanged(double value) {
    if (value == 0.25 || value == 0.5 || value == 0.75 || value == 1.0) {
      onAnalyticsEvent?.call('progress_milestone', {
        'progress_id': progressId,
        'value': value,
        'percentage': (value * 100).toInt(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }
  
  @override
  void onProgressCompleted() {
    onAnalyticsEvent?.call('progress_completed', {
      'progress_id': progressId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
