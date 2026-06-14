import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_context.dart';

class SpecRow extends StatelessWidget {
  final String title;
  final List<String> values;

  const SpecRow({super.key, required this.title, required this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.colorScheme.outline.withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.all(12),
            color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Text(
              title,
              style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: values.map((val) {
                  return Container(
                    width: 156,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      val,
                      style: context.textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}