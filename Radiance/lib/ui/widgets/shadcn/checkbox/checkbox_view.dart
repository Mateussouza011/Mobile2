import 'package:flutter/material.dart';
import 'checkbox_view_model.dart';
import 'checkbox_delegate.dart';

class ShadcnCheckboxView extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final bool enabled;
  final ShadcnCheckboxDelegate? delegate;
  final ShadcnCheckboxViewModel? viewModel;

  const ShadcnCheckboxView({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.enabled = true,
    this.delegate,
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = enabled && (viewModel?.enabled ?? true);

    return InkWell(
      onTap: isEnabled
          ? () {
              delegate?.onTap();
              final newValue = !value;
              delegate?.onChanged(newValue);
              onChanged?.call(newValue);
              viewModel?.toggle();
            }
          : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: value
                    ? (isEnabled ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.5))
                    : Colors.transparent,
                border: Border.all(
                  color: value
                      ? (isEnabled ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.5))
                      : (isEnabled ? colorScheme.outline : colorScheme.outline.withValues(alpha: 0.5)),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: value
                  ? Icon(
                      Icons.check,
                      size: 12,
                      color: isEnabled
                          ? colorScheme.onPrimary
                          : colorScheme.onPrimary.withValues(alpha: 0.7),
                    )
                  : null,
            ),
            if (label != null || viewModel?.label != null) ...[
              const SizedBox(width: 8),
              Text(
                label ?? viewModel?.label ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isEnabled
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ShadcnIndeterminateCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final bool enabled;
  final ShadcnCheckboxDelegate? delegate;

  const ShadcnIndeterminateCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.enabled = true,
    this.delegate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIndeterminate = value == null;
    final isChecked = value == true;

    return InkWell(
      onTap: enabled
          ? () {
              delegate?.onTap();
              bool? newValue;
              if (isIndeterminate) {
                newValue = false;
              } else if (isChecked) {
                newValue = null;
              } else {
                newValue = true;
              }
              delegate?.onChanged(newValue);
              onChanged?.call(newValue);
            }
          : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: (isChecked || isIndeterminate)
                    ? (enabled ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.5))
                    : Colors.transparent,
                border: Border.all(
                  color: (isChecked || isIndeterminate)
                      ? (enabled ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.5))
                      : (enabled ? colorScheme.outline : colorScheme.outline.withValues(alpha: 0.5)),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: isIndeterminate
                  ? Icon(
                      Icons.remove,
                      size: 12,
                      color: enabled
                          ? colorScheme.onPrimary
                          : colorScheme.onPrimary.withValues(alpha: 0.7),
                    )
                  : isChecked
                      ? Icon(
                          Icons.check,
                          size: 12,
                          color: enabled
                              ? colorScheme.onPrimary
                              : colorScheme.onPrimary.withValues(alpha: 0.7),
                        )
                      : null,
            ),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(
                label!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: enabled
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
