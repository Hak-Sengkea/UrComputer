import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/theme/app_colors.dart';

class LandingBuildDreamSection extends StatelessWidget {
  final Product? product;

  const LandingBuildDreamSection({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final image = product?.image;
    final title = product?.name ?? 'Build Your Dream Gaming Rig';
    final description =
        product?.description ?? 'Pick your parts. We assemble it for you.';

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      child: SizedBox(
        height: 210,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppColors.surfaceVariant),
            if (image != null && image.isNotEmpty)
              Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.space8),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.8),
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
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusPill,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Start Build'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
