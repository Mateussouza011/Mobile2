import 'package:flutter/material.dart';

class ShadcnCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;

  const ShadcnCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
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
                color: value ? colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: value ? colorScheme.primary : colorScheme.outline,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: value
                  ? Icon(
                      Icons.check,
                      size: 12,
                      color: colorScheme.onPrimary,
                    )
                  : null,
            ),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(
                label!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}