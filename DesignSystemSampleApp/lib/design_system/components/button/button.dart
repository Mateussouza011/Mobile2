import 'package:flutter/material.dart';
import 'button_view_model.dart';
import '../../theme/design_system_theme.dart';

/// Componente de botão reutilizável baseado em ViewModel
class DSButton extends StatelessWidget {
  final ButtonViewModel viewModel;

  const DSButton({
    super.key,
    required this.viewModel,
  });

  /// Factory method para instanciar o botão
  static Widget instantiate({required ButtonViewModel viewModel}) {
    return DSButton(viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);
    
    // Define tamanhos baseados no enum
    final sizes = _getSizeConfiguration(viewModel.size);
    
    // Define cores e estilos baseados na variante
    final styleConfig = _getVariantConfiguration(theme, viewModel.variant);

    Widget buttonChild;
    
    if (viewModel.isLoading) {
      buttonChild = SizedBox(
        height: sizes.iconSize,
        width: sizes.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(styleConfig.foregroundColor),
        ),
      );
    } else if (viewModel.icon != null) {
      final iconWidget = Icon(
        viewModel.icon,
        size: sizes.iconSize,
        color: styleConfig.foregroundColor,
      );
      
      final textWidget = Text(
        viewModel.text,
        style: sizes.textStyle.copyWith(
          color: styleConfig.foregroundColor,
        ).merge(viewModel.textStyle),
      );

      buttonChild = viewModel.iconPosition == IconPosition.leading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                iconWidget,
                SizedBox(width: sizes.spacing),
                textWidget,
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                textWidget,
                SizedBox(width: sizes.spacing),
                iconWidget,
              ],
            );
    } else {
      buttonChild = Text(
        viewModel.text,
        style: sizes.textStyle.copyWith(
          color: styleConfig.foregroundColor,
        ).merge(viewModel.textStyle),
      );
    }

    final button = ElevatedButton(
      onPressed: viewModel.isEnabled && !viewModel.isLoading ? viewModel.onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: viewModel.backgroundColor ?? styleConfig.backgroundColor,
        foregroundColor: styleConfig.foregroundColor,
        disabledBackgroundColor: styleConfig.disabledBackgroundColor,
        disabledForegroundColor: styleConfig.disabledForegroundColor,
        elevation: styleConfig.elevation,
        shadowColor: styleConfig.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: viewModel.borderRadius ?? sizes.borderRadius,
          side: styleConfig.borderSide,
        ),
        padding: viewModel.padding ?? sizes.padding,
        minimumSize: viewModel.fullWidth
            ? const Size(double.infinity, 0)
            : null,
      ),
      child: buttonChild,
    );

    // Aplica margin se especificado
    if (viewModel.margin != null) {
      return Padding(
        padding: viewModel.margin!,
        child: button,
      );
    }

    return button;
  }

  /// Retorna configuração de tamanho baseada no ButtonSize
  _ButtonSizeConfiguration _getSizeConfiguration(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return _ButtonSizeConfiguration(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          iconSize: 16,
          borderRadius: BorderRadius.circular(8),
          spacing: 6,
        );
      case ButtonSize.medium:
        return _ButtonSizeConfiguration(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          iconSize: 20,
          borderRadius: BorderRadius.circular(12),
          spacing: 8,
        );
      case ButtonSize.large:
        return _ButtonSizeConfiguration(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          iconSize: 24,
          borderRadius: BorderRadius.circular(16),
          spacing: 10,
        );
    }
  }

  /// Retorna configuração de estilo baseada no ButtonVariant
  _ButtonVariantConfiguration _getVariantConfiguration(
    DesignSystemTheme theme,
    ButtonVariant variant,
  ) {
    switch (variant) {
      case ButtonVariant.primary:
        return _ButtonVariantConfiguration(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.onPrimaryColor,
          disabledBackgroundColor: theme.primaryColor.withOpacity(0.3),
          disabledForegroundColor: theme.onPrimaryColor.withOpacity(0.5),
          borderSide: BorderSide.none,
          elevation: 2,
          shadowColor: theme.primaryColor.withOpacity(0.3),
        );
      case ButtonVariant.secondary:
        return _ButtonVariantConfiguration(
          backgroundColor: theme.secondaryColor,
          foregroundColor: theme.onSecondaryColor,
          disabledBackgroundColor: theme.secondaryColor.withOpacity(0.3),
          disabledForegroundColor: theme.onSecondaryColor.withOpacity(0.5),
          borderSide: BorderSide.none,
          elevation: 1,
          shadowColor: theme.secondaryColor.withOpacity(0.2),
        );
      case ButtonVariant.tertiary:
        return _ButtonVariantConfiguration(
          backgroundColor: theme.tertiaryColor,
          foregroundColor: theme.onTertiaryColor,
          disabledBackgroundColor: theme.tertiaryColor.withOpacity(0.3),
          disabledForegroundColor: theme.onTertiaryColor.withOpacity(0.5),
          borderSide: BorderSide.none,
          elevation: 0,
        );
      case ButtonVariant.outline:
        return _ButtonVariantConfiguration(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.primaryColor,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: theme.primaryColor.withOpacity(0.3),
          borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
          elevation: 0,
        );
      case ButtonVariant.ghost:
        return _ButtonVariantConfiguration(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.primaryColor,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: theme.primaryColor.withOpacity(0.3),
          borderSide: BorderSide.none,
          elevation: 0,
        );
      case ButtonVariant.destructive:
        return _ButtonVariantConfiguration(
          backgroundColor: theme.errorColor,
          foregroundColor: theme.onErrorColor,
          disabledBackgroundColor: theme.errorColor.withOpacity(0.3),
          disabledForegroundColor: theme.onErrorColor.withOpacity(0.5),
          borderSide: BorderSide.none,
          elevation: 2,
          shadowColor: theme.errorColor.withOpacity(0.3),
        );
    }
  }
}

/// Configuração de tamanho do botão
class _ButtonSizeConfiguration {
  final EdgeInsets padding;
  final TextStyle textStyle;
  final double iconSize;
  final BorderRadius borderRadius;
  final double spacing;

  _ButtonSizeConfiguration({
    required this.padding,
    required this.textStyle,
    required this.iconSize,
    required this.borderRadius,
    required this.spacing,
  });
}

/// Configuração de variante/estilo do botão
class _ButtonVariantConfiguration {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color disabledBackgroundColor;
  final Color disabledForegroundColor;
  final BorderSide borderSide;
  final double elevation;
  final Color? shadowColor;

  _ButtonVariantConfiguration({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.borderSide,
    this.elevation = 0,
    this.shadowColor,
  });
}
