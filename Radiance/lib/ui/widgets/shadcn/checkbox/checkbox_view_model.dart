import 'package:flutter/material.dart';

class ShadcnCheckboxViewModel extends ChangeNotifier {
  bool _value;
  bool _enabled;
  String? _label;
  bool _isIndeterminate;

  ShadcnCheckboxViewModel({
    bool value = false,
    bool enabled = true,
    String? label,
    bool isIndeterminate = false,
  })  : _value = value,
        _enabled = enabled,
        _label = label,
        _isIndeterminate = isIndeterminate;

  bool get value => _value;
  bool get enabled => _enabled;
  String? get label => _label;
  bool get isIndeterminate => _isIndeterminate;

  set value(bool newValue) {
    if (_value != newValue) {
      _value = newValue;
      _isIndeterminate = false;
      notifyListeners();
    }
  }

  set enabled(bool newEnabled) {
    if (_enabled != newEnabled) {
      _enabled = newEnabled;
      notifyListeners();
    }
  }

  set label(String? newLabel) {
    if (_label != newLabel) {
      _label = newLabel;
      notifyListeners();
    }
  }

  set isIndeterminate(bool newValue) {
    if (_isIndeterminate != newValue) {
      _isIndeterminate = newValue;
      notifyListeners();
    }
  }

  void toggle() {
    if (_enabled) {
      _value = !_value;
      _isIndeterminate = false;
      notifyListeners();
    }
  }

  void check() {
    if (_enabled && !_value) {
      _value = true;
      _isIndeterminate = false;
      notifyListeners();
    }
  }

  void uncheck() {
    if (_enabled && _value) {
      _value = false;
      _isIndeterminate = false;
      notifyListeners();
    }
  }

  void setIndeterminate() {
    if (_enabled && !_isIndeterminate) {
      _isIndeterminate = true;
      notifyListeners();
    }
  }

  void reset() {
    _value = false;
    _isIndeterminate = false;
    notifyListeners();
  }
}

class ShadcnCheckboxGroupViewModel extends ChangeNotifier {
  final List<ShadcnCheckboxViewModel> _checkboxes;
  bool _enabled;

  ShadcnCheckboxGroupViewModel({
    List<ShadcnCheckboxViewModel>? checkboxes,
    bool enabled = true,
  })  : _checkboxes = checkboxes ?? [],
        _enabled = enabled;

  List<ShadcnCheckboxViewModel> get checkboxes => _checkboxes;
  bool get enabled => _enabled;
  List<bool> get values => _checkboxes.map((c) => c.value).toList();
  bool get allSelected => _checkboxes.every((c) => c.value);
  bool get noneSelected => _checkboxes.every((c) => !c.value);
  bool get someSelected => !allSelected && !noneSelected;
  int get selectedCount => _checkboxes.where((c) => c.value).length;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      for (var checkbox in _checkboxes) {
        checkbox.enabled = value;
      }
      notifyListeners();
    }
  }

  void add(ShadcnCheckboxViewModel checkbox) {
    checkbox.addListener(notifyListeners);
    _checkboxes.add(checkbox);
    notifyListeners();
  }

  void remove(ShadcnCheckboxViewModel checkbox) {
    checkbox.removeListener(notifyListeners);
    _checkboxes.remove(checkbox);
    notifyListeners();
  }

  void selectAll() {
    for (var checkbox in _checkboxes) {
      checkbox.check();
    }
  }

  void deselectAll() {
    for (var checkbox in _checkboxes) {
      checkbox.uncheck();
    }
  }

  void toggleAll() {
    if (allSelected) {
      deselectAll();
    } else {
      selectAll();
    }
  }

  @override
  void dispose() {
    for (var checkbox in _checkboxes) {
      checkbox.removeListener(notifyListeners);
    }
    super.dispose();
  }
}
