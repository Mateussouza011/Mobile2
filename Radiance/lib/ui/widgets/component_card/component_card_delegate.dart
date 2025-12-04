abstract class ComponentCardDelegate {
  void onTap();
  void onHoverEnter();
  void onHoverExit();
  void onPressDown();
  void onPressUp();
}

class DefaultComponentCardDelegate implements ComponentCardDelegate {
  @override
  void onTap() {}

  @override
  void onHoverEnter() {}

  @override
  void onHoverExit() {}

  @override
  void onPressDown() {}

  @override
  void onPressUp() {}
}
