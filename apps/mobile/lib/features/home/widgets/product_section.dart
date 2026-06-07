import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:mobile/providers/cart_provider.dart';
import 'package:mobile/providers/auth_provider.dart';

class ProductSection extends StatelessWidget {
  final String title;
  final List<Product> products;

  const ProductSection({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSizes.space16,
            bottom: AppSizes.space16,
          ),
          child: Text(
            title,
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
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: EdgeInsets.only(right: AppSizes.space16),
                child: _buildProductCard(context, product, theme),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
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
            _buildBackground(product),
            
            // 1. Bottom Dark Gradient Scrim to ensure text legibility over images
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.85),
                      Colors.black.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
            
            // 2. Product Information Overlay
            Padding(
              padding: const EdgeInsets.all(AppSizes.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.space8),
                  Text(
                    product.description ?? 'Premium Product',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurface.withOpacity(0.8),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: AppSizes.space12),
                  Text(
                    '\$${product.price}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            
            // 3. Top-Right "Add to Cart" Button
            Positioned(
              top: AppSizes.space12,
              right: AppSizes.space12,
              child: ClipOval(
                child: Material(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onPressed: () async {
                      final auth = context.read<AuthProvider>();
                      
                      if (!auth.isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please log in to add items to cart'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      
                      final cart = context.read<CartProvider>();
                      await cart.addToCart(product, 1);
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart!'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(Product product) {
    final image = product.image?.trim();

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
