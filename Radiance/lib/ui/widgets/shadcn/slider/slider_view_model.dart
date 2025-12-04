import 'package:flutter/material.dart';

enum ShadcnSliderType {
  single,
  range,
  stepped,
}

class ShadcnSliderViewModel extends ChangeNotifier {
  double _value;
  RangeValues _rangeValues;
  double _min;
  double _max;
  int? _divisions;
  ShadcnSliderType _type;
  bool _enabled;
  bool _isDragging;

  ShadcnSliderViewModel({
    double value = 0.0,
    RangeValues? rangeValues,
    double min = 0.0,
    double max = 100.0,
    int? divisions,
    ShadcnSliderType type = ShadcnSliderType.single,
    bool enabled = true,
  })  : _value = value.clamp(min, max),
        _rangeValues = rangeValues ?? RangeValues(min, max),
        _min = min,
        _max = max,
        _divisions = divisions,
        _type = type,
        _enabled = enabled,
        _isDragging = false;

  double get value => _value;
  RangeValues get rangeValues => _rangeValues;
  double get min => _min;
  double get max => _max;
  int? get divisions => _divisions;
  ShadcnSliderType get type => _type;
  bool get enabled => _enabled;
  bool get isDragging => _isDragging;
  double get percentage => (_value - _min) / (_max - _min);

  (double, double) get rangePercentages => (
        (_rangeValues.start - _min) / (_max - _min),
        (_rangeValues.end - _min) / (_max - _min),
      );

  set value(double newValue) {
    final clampedValue = newValue.clamp(_min, _max);
    if (_value != clampedValue) {
      _value = clampedValue;
      notifyListeners();
    }
  }

  set rangeValues(RangeValues newValues) {
    final clampedValues = RangeValues(
      newValues.start.clamp(_min, _max),
      newValues.end.clamp(_min, _max),
    );
    if (_rangeValues != clampedValues) {
      _rangeValues = clampedValues;
      notifyListeners();
    }
  }

  set min(double newMin) {
    if (_min != newMin) {
      _min = newMin;
      _value = _value.clamp(_min, _max);
      _rangeValues = RangeValues(
        _rangeValues.start.clamp(_min, _max),
        _rangeValues.end.clamp(_min, _max),
      );
      notifyListeners();
    }
  }

  set max(double newMax) {
    if (_max != newMax) {
      _max = newMax;
      _value = _value.clamp(_min, _max);
      _rangeValues = RangeValues(
        _rangeValues.start.clamp(_min, _max),
        _rangeValues.end.clamp(_min, _max),
      );
      notifyListeners();
    }
  }

  set divisions(int? newDivisions) {
    if (_divisions != newDivisions) {
      _divisions = newDivisions;
      notifyListeners();
    }
  }

  set type(ShadcnSliderType newType) {
    if (_type != newType) {
      _type = newType;
      notifyListeners();
    }
  }

  set enabled(bool newEnabled) {
    if (_enabled != newEnabled) {
      _enabled = newEnabled;
      notifyListeners();
    }
  }

  void startDrag() {
    _isDragging = true;
    notifyListeners();
  }

  void endDrag() {
    _isDragging = false;
    notifyListeners();
  }

  void setFromPercentage(double percentage) {
    value = _min + (percentage.clamp(0.0, 1.0) * (_max - _min));
  }

  void increment([double step = 1.0]) {
    value = _value + step;
  }

  void decrement([double step = 1.0]) {
    value = _value - step;
  }

  void setToMin() {
    value = _min;
  }

  void setToMax() {
    value = _max;
  }

  void setToCenter() {
    value = (_min + _max) / 2;
  }

  void reset({double? initialValue, RangeValues? initialRange}) {
    _value = initialValue ?? _min;
    _rangeValues = initialRange ?? RangeValues(_min, _max);
    notifyListeners();
  }
}
