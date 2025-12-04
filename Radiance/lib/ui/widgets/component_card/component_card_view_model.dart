import 'package:flutter/material.dart';

class ComponentCardViewModel extends ChangeNotifier {
  String _title;
  String? _description;
  IconData _icon;
  bool _isHovered;
  bool _isPressed;

  ComponentCardViewModel({
    required String title,
    String? description,
    required IconData icon,
  })  : _title = title,
        _description = description,
        _icon = icon,
        _isHovered = false,
        _isPressed = false;

  String get title => _title;
  String? get description => _description;
  IconData get icon => _icon;
  bool get isHovered => _isHovered;
  bool get isPressed => _isPressed;

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

  set icon(IconData value) {
    if (_icon != value) {
      _icon = value;
      notifyListeners();
    }
  }

  void setHovered(bool value) {
    if (_isHovered != value) {
      _isHovered = value;
      notifyListeners();
    }
  }

  void setPressed(bool value) {
    if (_isPressed != value) {
      _isPressed = value;
      notifyListeners();
    }
  }

  void update({
    String? title,
    String? description,
    IconData? icon,
  }) {
    bool changed = false;
    
    if (title != null && _title != title) {
      _title = title;
      changed = true;
    }
    if (description != _description) {
      _description = description;
      changed = true;
    }
    if (icon != null && _icon != icon) {
      _icon = icon;
      changed = true;
    }
    
    if (changed) notifyListeners();
  }
}
