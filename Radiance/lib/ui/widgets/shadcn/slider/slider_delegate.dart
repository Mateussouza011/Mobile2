import 'package:flutter/material.dart';

abstract class ShadcnSliderDelegate {
  void onChanged(double value);
  void onRangeChanged(RangeValues values);
  void onChangeStart(double value);
  void onChangeEnd(double value);
  void onRangeChangeStart(RangeValues values);
  void onRangeChangeEnd(RangeValues values);
}

class DefaultShadcnSliderDelegate implements ShadcnSliderDelegate {
  @override
  void onChanged(double value) {}

  @override
  void onRangeChanged(RangeValues values) {}

  @override
  void onChangeStart(double value) {}

  @override
  void onChangeEnd(double value) {}

  @override
  void onRangeChangeStart(RangeValues values) {}

  @override
  void onRangeChangeEnd(RangeValues values) {}
}
