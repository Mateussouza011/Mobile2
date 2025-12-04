import 'package:flutter/material.dart';

enum ShadcnAlertType {
  info,
  success,
  warning,
  error,
}

enum ShadcnAlertVariant {
  default_,
  destructive,
  filled,
  outlined,
  minimal,
}

class ShadcnAlertViewModel extends ChangeNotifier {
  ShadcnAlertType _type;
  ShadcnAlertVariant _variant;
  String _title;
  String? _description;
  bool _isVisible;
  bool _isDismissible;
  bool _showIcon;

  ShadcnAlertViewModel({
    ShadcnAlertType type = ShadcnAlertType.info,
    ShadcnAlertVariant variant = ShadcnAlertVariant.default_,
    required String title,
    String? description,
    bool isVisible = true,
    bool isDismissible = false,
    bool showIcon = true,
  })  : _type = type,
        _variant = variant,
        _title = title,
        _description = description,
        _isVisible = isVisible,
        _isDismissible = isDismissible,
        _showIcon = showIcon;

  ShadcnAlertType get type => _type;
  ShadcnAlertVariant get variant => _variant;
  String get title => _title;
  String? get description => _description;
  bool get isVisible => _isVisible;
  bool get isDismissible => _isDismissible;
  bool get showIcon => _showIcon;

  set type(ShadcnAlertType value) {
    if (_type != value) {
      _type = value;
      notifyListeners();
    }
  }

  set variant(ShadcnAlertVariant value) {
    if (_variant != value) {
      _variant = value;
      notifyListeners();
    }
  }

  set title(String value) {
    if (_title != value) {
      _title = value;
      notifyListeners();
    }
  }

  set description(String? value) {
    if (_description != value) {
      _description = value;
      notifyListeners();
    }
  }

  set isVisible(bool value) {
    if (_isVisible != value) {
      _isVisible = value;
      notifyListeners();
    }
  }

  set isDismissible(bool value) {
    if (_isDismissible != value) {
      _isDismissible = value;
      notifyListeners();
    }
  }

  set showIcon(bool value) {
    if (_showIcon != value) {
      _showIcon = value;
      notifyListeners();
    }
  }

  void show() {
    isVisible = true;
  }

  void hide() {
    isVisible = false;
  }

  void toggle() {
    isVisible = !_isVisible;
  }

  void updateContent({
    String? title,
    String? description,
    ShadcnAlertType? type,
    ShadcnAlertVariant? variant,
  }) {
    if (title != null) _title = title;
    if (description != null) _description = description;
    if (type != null) _type = type;
    if (variant != null) _variant = variant;
    notifyListeners();
  }

  void showInfo(String title, {String? description}) {
    updateContent(
      title: title,
      description: description,
      type: ShadcnAlertType.info,
    );
    show();
  }

  void showSuccess(String title, {String? description}) {
    updateContent(
      title: title,
      description: description,
      type: ShadcnAlertType.success,
    );
    show();
  }

  void showWarning(String title, {String? description}) {
    updateContent(
      title: title,
      description: description,
      type: ShadcnAlertType.warning,
    );
    show();
  }

  void showError(String title, {String? description}) {
    updateContent(
      title: title,
      description: description,
      type: ShadcnAlertType.error,
    );
    show();
  }

  IconData get defaultIcon {
    switch (_type) {
      case ShadcnAlertType.info:
        return Icons.info_outline;
      case ShadcnAlertType.success:
        return Icons.check_circle_outline;
      case ShadcnAlertType.warning:
        return Icons.warning_amber_outlined;
      case ShadcnAlertType.error:
        return Icons.error_outline;
    }
  }
}
