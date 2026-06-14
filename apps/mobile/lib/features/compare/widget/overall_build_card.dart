import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/theme/theme_context.dart';
import '../../../models/pc_build.dart';
import '../../../providers/compare_provider.dart';

class OverallBuildCard extends StatelessWidget {
  final PCBuild pcBuild;

  const OverallBuildCard({super.key, required this.pcBuild});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(context.sizes.radiusLarge),
        border: Border.all(color: context.colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            pcBuild.buildName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${pcBuild.totalPrice.toStringAsFixed(2)}',
            style: context.textTheme.titleLarge?.copyWith(
              color: context.customColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${pcBuild.componentCount} / 8 Parts',
            style: context.textTheme.bodySmall,
          ),
          IconButton(
            icon: Icon(Icons.remove_circle_outline, size: 20, color: context.colorScheme.error),
            onPressed: () => context.read<CompareProvider>().removeBuild(pcBuild.id),
          ),
        ],
      ),
    );
  }
}