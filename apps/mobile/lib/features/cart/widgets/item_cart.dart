import 'package:flutter/material.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/features/cart/widgets/quantity_button.dart';
import 'package:mobile/models/cart_items.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:mobile/theme/app_text_style.dart';

class ItemCart extends StatelessWidget {
  final CartItems item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const ItemCart({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final hasDiscount = product.discount != null && product.discount! > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.space16),
      padding: const EdgeInsets.all(AppSizes.space12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.surfaceVariant.withValues(alpha: 0.4),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            child: SizedBox(
              width: 80,
              height: 80,
              child: product.image != null && product.image!.isNotEmpty
                  ? Image.network(
                      product.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.computer, color: AppColors.outline),
                      ),
                    )
                  : Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.computer, color: AppColors.outline),
                    ),
            ),
          ),
          const SizedBox(width: AppSizes.space16),

          // 2. Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppTextStyle.titleMedium.copyWith(
                          color: AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Trash Icon Button
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(
                        Icons.delete_outline,
                        color: AppColors.onSurfaceMuted,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Description / Specs
                if (product.description != null && product.description!.isNotEmpty)
                  Text(
                    product.description!,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.onSurfaceMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: AppSizes.space8),

                // Promotion Chips Row
                Row(
                  children: [
                    // Free Shipping simulation (if price > $500, show Free Shipping badge)
                    if (product.price >= 500)
                      Container(
                        margin: const EdgeInsets.only(right: AppSizes.space8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.brandBlueDark.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                        ),
                        child: Text(
                          'Free Shipping',
                          style: AppTextStyle.labelSmall.copyWith(
                            color: AppColors.brandBlue,
                            fontSize: 9,
                          ),
                        ),
                      ),

                    // Discount Chip
                    if (hasDiscount)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                        ),
                        child: Text(
                          'Sale -${product.discount!.toInt()}%',
                          style: AppTextStyle.labelSmall.copyWith(
                            color: AppColors.error,
                            fontSize: 9,
                          ),
                        ),
                      )
                    else
                      // In Stock Chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                        ),
                        child: Text(
                          'In Stock',
                          style: AppTextStyle.labelSmall.copyWith(
                            color: AppColors.success,
                            fontSize: 9,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSizes.space12),

                // Quantity & Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity Buttons
                    QuantityButton(
                      quantity: item.quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),

                    // Prices
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (hasDiscount)
                          Text(
                            '\$${product.price.toStringAsFixed(0)}',
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColors.onSurfaceMuted,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 10,
                            ),
                          ),
                        Text(
                          '\$${product.discountedPrice.toStringAsFixed(0)}',
                          style: AppTextStyle.titleMedium.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}