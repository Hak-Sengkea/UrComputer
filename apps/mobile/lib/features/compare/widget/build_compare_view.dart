import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_context.dart';
import '../../../models/pc_build.dart';
import 'overall_build_card.dart';

class BuildCompareView extends StatelessWidget {
  final List<PCBuild> builds;

  const BuildCompareView({super.key, required this.builds});

  @override
  Widget build(BuildContext context) {
    if (builds.length < 2) {
      return Center(
        child: Text(
          'Select another PC Build to compare.',
          style: context.textTheme.titleMedium,
        ),
      );
    }

    final buildA = builds[0];
    final buildB = builds[1];
    final componentKeys = ['CPU', 'GPU', 'RAM', 'Motherboard', 'Storage', 'PSU', 'Case', 'Cooler'];

    return ListView(
      padding: EdgeInsets.all(context.sizes.space16),
      children: [
        // Overall Summary Cards
        Row(
          children: [
            Expanded(child: OverallBuildCard(pcBuild: buildA)),
            const SizedBox(width: 12),
            Expanded(child: OverallBuildCard(pcBuild: buildB)),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Slot Comparison',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Component-by-component Rows
        ...componentKeys.map((key) {
          final prodA = buildA.components[key];
          final prodB = buildB.components[key];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
              border: Border.all(color: context.colorScheme.outline.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      key,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        prodA?.name ?? 'Not Selected',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: prodA != null ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(width: 1, height: 30, color: context.colorScheme.outline.withValues(alpha: 0.2)),
                    Expanded(
                      child: Text(
                        prodB?.name ?? 'Not Selected',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: prodB != null ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                if (prodA != null || prodB != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          prodA != null ? '\$${prodA.price.toStringAsFixed(2)}' : '',
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodySmall?.copyWith(color: context.customColors.success),
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: Text(
                          prodB != null ? '\$${prodB.price.toStringAsFixed(2)}' : '',
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodySmall?.copyWith(color: context.customColors.success),
                        ),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          );
        }),
      ],
    );
  }
}