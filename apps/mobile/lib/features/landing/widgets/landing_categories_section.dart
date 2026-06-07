import 'package:flutter/material.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/theme/app_colors.dart';

class LandingCategoriesSection extends StatelessWidget {
  const LandingCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Browse Categories',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.outline,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.space12),
        SizedBox(
          height: 92,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _CategoryTile(icon: Icons.computer, label: 'PC Builds'),
              const SizedBox(width: AppSizes.space12),
              _CategoryTile(icon: Icons.laptop, label: 'Laptops'),
              const SizedBox(width: AppSizes.space12),
              _CategoryTile(icon: Icons.memory, label: 'Components'),
              const SizedBox(width: AppSizes.space12),
              _CategoryTile(icon: Icons.headphones, label: 'Peripherals'),
              const SizedBox(width: AppSizes.space12),
              _CategoryTile(icon: Icons.router, label: 'Networking'),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: AppColors.primary),
          const SizedBox(height: AppSizes.space8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
