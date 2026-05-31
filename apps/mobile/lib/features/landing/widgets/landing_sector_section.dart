import 'package:flutter/material.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/models/category.dart';
import 'package:mobile/theme/app_colors.dart';

class LandingSectorSection extends StatelessWidget {
  final List<Category> categories;

  const LandingSectorSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Browse by Sector',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.outline,
              ),
            ),
            Text(
              'See all',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.space12),
        if (categories.isNotEmpty)
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length > 5 ? 5 : categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.space12),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _SectorTile(
                  icon: _iconForCategory(category.name),
                  label: category.name,
                );
              },
            ),
          ),
      ],
    );
  }

  IconData _iconForCategory(String name) {
    final normalized = name.toLowerCase();
    if (normalized.contains('laptop')) return Icons.laptop;
    if (normalized.contains('build')) return Icons.computer;
    if (normalized.contains('component')) return Icons.memory;
    if (normalized.contains('peripheral')) return Icons.headphones;
    if (normalized.contains('storage')) return Icons.storage;
    if (normalized.contains('network')) return Icons.router;
    return Icons.category;
  }
}

class _SectorTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectorTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: AppSizes.space8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
