import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/providers/favorites_provider.dart';
import 'package:mobile/theme/theme_context.dart';

class ItemFavorite extends StatelessWidget {
  final Product product;
  final FavoritesProvider favoritesProvider;

  const ItemFavorite({
    super.key,
    required this.product,
    required this.favoritesProvider,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discount != null && product.discount! > 0;

    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: context.sizes.space24),
        decoration: BoxDecoration(
          color: context.colorScheme.error,
          borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (direction) async {
        await favoritesProvider.removeFavorite(product.id);

        if (context.mounted) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.clearSnackBars();
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                'Removed ${product.name} from wishlist',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: context.colorScheme.surfaceContainerHighest,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'UNDO',
                textColor: context.colorScheme.primary,
                onPressed: () {
                  favoritesProvider.addFavorite(product);
                },
              ),
            ),
          );
        }
      },
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'product_detail',
            pathParameters: {
              'id': product.id,
            },
          );
        },
        borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
        child: Container(
          padding: EdgeInsets.all(context.sizes.space12),
          decoration: BoxDecoration(
            color: context.customColors.cardBg,
            borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
            border: Border.all(
              color: context.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              // Product Image thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(context.sizes.radiusSmall),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: product.image != null && product.image!.isNotEmpty
                      ? Image.network(
                          product.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholderIcon(context),
                        )
                      : _buildPlaceholderIcon(context),
                ),
              ),
              SizedBox(width: context.sizes.space16),
              // Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.sizes.space4),
                    Text(
                      product.description ?? 'Premium product',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.sizes.space8),
                    // Price Row
                    Row(
                      children: [
                        Text(
                          '\$${product.discountedPrice.toStringAsFixed(2)}',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (hasDiscount) ...[
                          SizedBox(width: context.sizes.space8),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.sizes.space8),
              // Chevron indicator
              Icon(
                Icons.chevron_right,
                color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.devices,
        color: context.colorScheme.onSurfaceVariant,
        size: 32,
      ),
    );
  }
}
