import 'package:flutter/material.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/theme/app_colors.dart';

class LandingFeaturedDeploymentsSection extends StatelessWidget {
  final List<Product> products;

  const LandingFeaturedDeploymentsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Laptops',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors
                .onSurface, // Changed from outline to make header readable
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.space12),
        if (products.isNotEmpty)
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: products.length > 6 ? 6 : products.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.space12),
              itemBuilder: (context, index) {
                final product = products[index];
                final hasDiscount = (product.discount ?? 0) > 0;
                final badge = hasDiscount
                    ? '-${product.discount!.round()}%'
                    : 'New';

                return _FeaturedCard(
                  imageUrl: product.image ?? '',
                  title: product.name,
                  subtitle: product.description ?? 'High performance',
                  price: _formatPrice(
                    hasDiscount ? product.discountedPrice : product.price,
                  ),
                  badge: badge,
                  isDiscount: hasDiscount,
                );
              },
            ),
          ),
      ],
    );
  }

  String _formatPrice(double value) {
    return '\$${value.toStringAsFixed(0)}';
  }
}

class _FeaturedCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String price;
  final String badge;
  final bool isDiscount;

  const _FeaturedCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.badge,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width:
          160, // 2. NARROWED WIDTH: Gives it a tighter, cleaner portrait aspect ratio
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(color: AppColors.outline.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image / Badge Layout
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusLarge),
            ),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 105, // Subtle sizing down for visual balance
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 105,
                    color: AppColors.outline.withOpacity(0.1),
                    child: const Icon(Icons.laptop, color: Colors.grey),
                  ),
                ),
                // Badge overlay
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      // Dynamic styling: Red accent for deals, premium colored accent for new drops
                      color: isDiscount
                          ? const Color(0xFFE53935)
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    ),
                    child: Text(
                      badge,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDiscount ? Colors.white : AppColors.onPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details Text Container
          // 3. OPTIMIZED FLEX/PADDING: Swapped full padding values to allow text layout to breathe vertically
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Distributes text evenly without jamming
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    price,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
