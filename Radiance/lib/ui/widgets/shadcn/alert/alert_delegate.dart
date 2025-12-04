abstract class ShadcnAlertDelegate {
  void onDismiss();
  void onAction();
  void onShow();
  void onHide();
  void onAutoDismiss();
}

class DefaultShadcnAlertDelegate implements ShadcnAlertDelegate {
  @override
  void onDismiss() {}

  @override
  void onAction() {}

  @override
  void onShow() {}

  @override
  void onHide() {}

  @override
  void onAutoDismiss() {}
}
