/// Switch Component (shadcn/ui)
library;

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart' as colors;
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/constants/durations.dart';
import 'switch_view_model.dart';
import 'switch_delegate.dart';

/// Componente Switch do Design System
class SwitchComponent extends StatelessWidget {
  final SwitchViewModel viewModel;
  final SwitchDelegate? delegate;

  const SwitchComponent({
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
          ? () => delegate!.onChanged(!vm.value)
          : null,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Switch Toggle
            AnimatedContainer(
              duration: durationNormal,
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                color: vm.value
                    ? (vm.enabled
                        ? (isDark ? colors.primaryDark : colors.primary)
                        : (isDark ? colors.mutedDark : colors.muted))
                    : (vm.enabled
                        ? (isDark ? colors.borderDark : colors.input)
                        : (isDark ? colors.mutedDark : colors.muted)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedAlign(
                duration: durationNormal,
                alignment: vm.value ? Alignment.centerRight : Alignment.centerLeft,
                curve: Curves.easeInOut,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: vm.value
                        ? (isDark ? colors.primaryForegroundDark : colors.primaryForeground)
                        : (isDark ? colors.foregroundDark : colors.foreground),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Label and Description
            if (vm.label != null || vm.description != null) ...[
              SizedBox(width: spacing3),
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
