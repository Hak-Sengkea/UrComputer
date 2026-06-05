import 'package:flutter/material.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/theme/app_colors.dart';

class LandingTopRatedSection extends StatelessWidget {
  final List<Product> products;

  const LandingTopRatedSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Rated Hardware',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.outline,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.space12),
        if (products.isNotEmpty)
          ...products
              .take(3)
              .map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.space12),
                  child: _RatedTile(
                    imageUrl: product.image ?? '',
                    title: product.name,
                    rating: _formatRating(product.rating),
                    price: _formatPrice(product.discountedPrice),
                  ),
                ),
              ),
      ],
    );
  }

  String _formatRating(double? rating) {
    if (rating == null) return '—';
    return rating.toStringAsFixed(1);
  }

  String _formatPrice(double value) {
    return '\$${value.toStringAsFixed(0)}';
  }
}

class _RatedTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String rating;
  final String price;

  const _RatedTile({
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.space12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            child: Image.network(
              imageUrl,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox(width: 52, height: 52),
            ),
          ),
          const SizedBox(width: AppSizes.space12),
          Expanded(
            child: Column(
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            price,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
