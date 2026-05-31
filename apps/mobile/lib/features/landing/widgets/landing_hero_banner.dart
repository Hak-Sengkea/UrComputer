import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/theme/app_colors.dart';

class LandingHeroBanner extends StatelessWidget {
  final Product? heroProduct;

  const LandingHeroBanner({super.key, this.heroProduct});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final heroImage = heroProduct?.image;
    final heroTitle = heroProduct?.name ?? 'Next Gen Gaming Starts Here';
    final heroDescription =
        heroProduct?.description ??
        'Custom builds, elite parts, and esports-ready gear.';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 360;

        return Container(
          padding: const EdgeInsets.all(AppSizes.space16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            border: Border.all(color: AppColors.outline.withOpacity(0.2)),
          ),
          child: isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (heroImage != null && heroImage.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusMedium,
                        ),
                        child: Image.network(
                          heroImage,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(height: 150),
                        ),
                      ),
                    if (heroImage != null && heroImage.isNotEmpty)
                      const SizedBox(height: AppSizes.space12),
                    _HeroCopy(
                      theme: theme,
                      title: heroTitle,
                      description: heroDescription,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _HeroCopy(
                        theme: theme,
                        title: heroTitle,
                        description: heroDescription,
                      ),
                    ),
                    const SizedBox(width: AppSizes.space12),
                    if (heroImage != null && heroImage.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusMedium,
                        ),
                        child: Image.network(
                          heroImage,
                          width: 110,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(width: 110, height: 140),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class _HeroCopy extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final String description;

  const _HeroCopy({
    required this.theme,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.space8),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.onSurface.withOpacity(0.7),
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSizes.space12),
        SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              ),
              elevation: 0,
            ),
            child: const Text('Explore Builds'),
          ),
        ),
      ],
    );
  }
}
