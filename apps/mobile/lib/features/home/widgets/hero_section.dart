import 'package:flutter/material.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/theme/app_colors.dart';

class HeroSection extends StatelessWidget {
  final List<Product> pcComponents;

  const HeroSection({super.key, required this.pcComponents});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSizes.space16,
            bottom: AppSizes.space16,
          ),
          child: Text(
            'Featured PC Components',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.outline,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: pcComponents.length,
            itemBuilder: (context, index) {
              final component = pcComponents[index];
              return Padding(
                padding: EdgeInsets.only(right: AppSizes.space16),
                child: _buildPCComponentCard(context, component, theme),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPCComponentCard(
    BuildContext context,
    Product component,
    ThemeData theme,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      child: SizedBox(
        width: 280,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppColors.surfaceVariant),
            _buildBackground(component),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.withOpacity(0.15),
                    Colors.grey.withOpacity(0.45),
                    Colors.grey.withOpacity(0.75),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSizes.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    component.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSizes.space8),
                  Text(
                    component.description ??
                        'Premium PC Component Configuration',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurface.withOpacity(0.8),
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: AppSizes.space12),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {},
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
                      child: const Text(
                        'View Components',
                        style: TextStyle(fontSize: 12),
                      ),
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

  Widget _buildBackground(Product build) {
    final image = build.image?.trim();

    if (image != null && image.isNotEmpty) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      );
    }

    return const SizedBox.shrink();
  }
}
