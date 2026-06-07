import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:mobile/const/app_sizes.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double? width;
  final bool compact;

  const ProductCard({
    super.key,
    required this.product,
    this.width,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.pushNamed(
              'product_detail',
              pathParameters: {'id': product.id},
            );
          },
          child: SizedBox(
            width: width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: AppColors.surfaceVariant),

                _buildBackground(),

                if (!compact)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.surface.withValues(alpha: 0.88),
                        ],
                      ),
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.all(
                    compact ? AppSizes.space8 : AppSizes.space16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        product.name,
                        style:
                            (compact
                                    ? theme.textTheme.bodyMedium
                                    : theme.textTheme.titleMedium)
                                ?.copyWith(
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(
                        height: compact ? AppSizes.space4 : AppSizes.space8,
                      ),

                      if (!compact) ...[
                        Text(
                          product.description ?? 'Premium Product',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: AppSizes.space12),
                      ],

                      Text(
                        '\$${product.price}',
                        style:
                            (compact
                                    ? theme.textTheme.bodySmall
                                    : theme.textTheme.titleSmall)
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    final image = product.image?.trim();

    if (image != null && image.isNotEmpty) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
    }

    return const SizedBox.shrink();
  }
}
