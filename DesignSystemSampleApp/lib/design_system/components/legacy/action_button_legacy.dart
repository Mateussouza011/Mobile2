import 'package:flutter/material.dart';
import '../../core/base_component_view_model.dart';
import '../button/button_view_model.dart' as btn;
import '../button/button.dart';

// Enums legados para compatibilidade
enum ActionButtonSize {
  small,
  medium,
  large,
}

enum ActionButtonStyle {
  primary,
  secondary,
  tertiary,
}

/// ViewModel legado para ActionButton (compatibilidade)
/// Agora herda do sistema refatorado
class ActionButtonViewModel extends InteractiveComponentViewModel {
  final ActionButtonSize size;
  final ActionButtonStyle style;
  final String text;
  final IconData? icon;

  ActionButtonViewModel({
    required this.size,
    required this.style,
    required this.text,
    required VoidCallback onPressed,
    this.icon,
    super.isEnabled = true,
    super.id,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.width,
    super.height,
    super.tooltip,
  }) : super(onPressed: onPressed);

  /// Converte para o novo ButtonViewModel
  btn.ButtonViewModel toButtonViewModel() {
    // Mapeia size
    btn.ButtonSize newSize;
    switch (size) {
      case ActionButtonSize.small:
        newSize = btn.ButtonSize.small;
        break;
      case ActionButtonSize.medium:
        newSize = btn.ButtonSize.medium;
        break;
      case ActionButtonSize.large:
        newSize = btn.ButtonSize.large;
        break;
    }

    // Mapeia style
    btn.ButtonVariant newVariant;
    switch (style) {
      case ActionButtonStyle.primary:
        newVariant = btn.ButtonVariant.primary;
        break;
      case ActionButtonStyle.secondary:
        newVariant = btn.ButtonVariant.secondary;
        break;
      case ActionButtonStyle.tertiary:
        newVariant = btn.ButtonVariant.tertiary;
        break;
    }

    return btn.ButtonViewModel(
      text: text,
      size: newSize,
      variant: newVariant,
      icon: icon,
      onPressed: onPressed,
      isEnabled: isEnabled,
      id: id,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      width: width,
      height: height,
      tooltip: tooltip,
    );
  }
}

/// Widget legado ActionButton que usa o novo DSButton internamente
class ActionButton extends StatelessWidget {
  final ActionButtonViewModel viewModel;

  const ActionButton._({required this.viewModel});

  static Widget instantiate({required ActionButtonViewModel viewModel}) {
    return ActionButton._(viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return DSButton(viewModel: viewModel.toButtonViewModel());
  }
}
