abstract class ShadcnCheckboxDelegate {
  void onChanged(bool? value);
  void onFocus();
  void onBlur();
  void onTap();
}

class DefaultShadcnCheckboxDelegate implements ShadcnCheckboxDelegate {
  @override
  void onChanged(bool? value) {}

  @override
  void onFocus() {}

  @override
  void onBlur() {}

  @override
  void onTap() {}
}
