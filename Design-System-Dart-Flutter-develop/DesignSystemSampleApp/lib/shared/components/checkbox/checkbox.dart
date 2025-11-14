/// Checkbox Component (shadcn/ui)
library;

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart' as colors;
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/constants/durations.dart';
import 'checkbox_view_model.dart';
import 'checkbox_delegate.dart';

/// Componente Checkbox do Design System
class CheckboxComponent extends StatelessWidget {
  final CheckboxViewModel viewModel;
  final CheckboxDelegate? delegate;

  const CheckboxComponent({
    Key? key,
    required this.viewModel,
    this.delegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = viewModel;

    return InkWell(
      onTap: vm.enabled && delegate != null
          ? () => delegate!.onChanged(!(vm.checked ?? false))
          : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkbox Box
            AnimatedContainer(
              duration: durationFast,
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: vm.checked == true
                    ? (vm.enabled
                        ? (isDark ? colors.primaryDark : colors.primary)
                        : (isDark ? colors.mutedDark : colors.muted))
                    : Colors.transparent,
                border: Border.all(
                  color: vm.checked == true
                      ? (vm.enabled
                          ? (isDark ? colors.primaryDark : colors.primary)
                          : (isDark ? colors.mutedForegroundDark : colors.mutedForeground))
                      : (vm.enabled
                          ? (isDark ? colors.borderDark : colors.border)
                          : (isDark ? colors.mutedForegroundDark.withOpacity(0.5) : colors.mutedForeground.withOpacity(0.5))),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: vm.checked == true
                  ? Icon(
                      Icons.check,
                      size: 14,
                      color: isDark ? colors.primaryForegroundDark : colors.primaryForeground,
                    )
                  : vm.checked == null
                      ? Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark ? colors.primaryForegroundDark : colors.primaryForeground,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        )
                      : null,
            ),

            // Label and Description
            if (vm.label != null || vm.description != null) ...[
              SizedBox(width: spacing2),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (vm.label != null)
                      Text(
                        vm.label!,
                        style: bodyBase.copyWith(
                          color: vm.enabled
                              ? (isDark ? colors.foregroundDark : colors.foreground)
                              : (isDark ? colors.mutedForegroundDark : colors.mutedForeground),
                        ),
                      ),
                    if (vm.description != null) ...[
                      SizedBox(height: spacing1),
                      Text(
                        vm.description!,
                        style: bodySmall.copyWith(
                          color: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
