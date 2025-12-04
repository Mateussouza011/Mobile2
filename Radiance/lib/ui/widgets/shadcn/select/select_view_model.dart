import 'package:flutter/material.dart';

class ShadcnSelectOption<T> {
  final T value;
  final String label;
  final Widget? icon;
  final bool enabled;

  const ShadcnSelectOption({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });
}

class ShadcnSelectViewModel<T> extends ChangeNotifier {
  List<ShadcnSelectOption<T>> _options;
  T? _value;
  bool _isOpen;
  bool _enabled;
  String _searchQuery;
  List<ShadcnSelectOption<T>> _filteredOptions;

  ShadcnSelectViewModel({
    required List<ShadcnSelectOption<T>> options,
    T? initialValue,
    bool enabled = true,
  })  : _options = options,
        _value = initialValue,
        _isOpen = false,
        _enabled = enabled,
        _searchQuery = '',
        _filteredOptions = options;

  List<ShadcnSelectOption<T>> get options => _options;
  List<ShadcnSelectOption<T>> get filteredOptions => _filteredOptions;
  T? get value => _value;
  bool get isOpen => _isOpen;
  bool get enabled => _enabled;
  String get searchQuery => _searchQuery;

  ShadcnSelectOption<T>? get selectedOption {
    try {
      return _options.firstWhere((option) => option.value == _value);
    } catch (e) {
      return null;
    }
  }

  String? get selectedLabel => selectedOption?.label;

  set options(List<ShadcnSelectOption<T>> value) {
    _options = value;
    _filterOptions();
    notifyListeners();
  }

  set value(T? newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      if (!value) {
        _isOpen = false;
      }
      notifyListeners();
    }
  }

  void open() {
    if (_enabled && !_isOpen) {
      _isOpen = true;
      _searchQuery = '';
      _filterOptions();
      notifyListeners();
    }
  }

  void close() {
    if (_isOpen) {
      _isOpen = false;
      _searchQuery = '';
      notifyListeners();
    }
  }

  void toggle() {
    if (_isOpen) {
      close();
    } else {
      open();
    }
  }

  void select(T value) {
    _value = value;
    close();
  }

  void clear() {
    _value = null;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _filterOptions();
    notifyListeners();
  }

  void _filterOptions() {
    if (_searchQuery.isEmpty) {
      _filteredOptions = _options;
    } else {
      _filteredOptions = _options
          .where((option) =>
              option.label.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void addOption(ShadcnSelectOption<T> option) {
    _options = [..._options, option];
    _filterOptions();
    notifyListeners();
  }

  void removeOption(T value) {
    _options = _options.where((option) => option.value != value).toList();
    if (_value == value) {
      _value = null;
    }
    _filterOptions();
    notifyListeners();
  }

  void setOptions(List<ShadcnSelectOption<T>> newOptions) {
    _options = newOptions;
    if (_value != null && !newOptions.any((o) => o.value == _value)) {
      _value = null;
    }
    _filterOptions();
    notifyListeners();
  }
}
