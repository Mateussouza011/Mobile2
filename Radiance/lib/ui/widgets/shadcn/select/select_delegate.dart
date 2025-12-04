abstract class ShadcnSelectDelegate<T> {
  void onChanged(T? value);
  void onOpen();
  void onClose();
  void onSearchChanged(String query);
  void onFocusChanged(bool hasFocus);
}

class DefaultShadcnSelectDelegate<T> implements ShadcnSelectDelegate<T> {
  @override
  void onChanged(T? value) {}

  @override
  void onOpen() {}

  @override
  void onClose() {}

  @override
  void onSearchChanged(String query) {}

  @override
  void onFocusChanged(bool hasFocus) {}
}
