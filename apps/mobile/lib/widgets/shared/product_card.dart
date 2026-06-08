import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/theme/theme_context.dart';
import 'package:mobile/providers/favorites_provider.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/providers/cart_provider.dart';
import 'package:provider/provider.dart';

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
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFav = favoritesProvider.isFavorite(product.id);

    return ClipRRect(
      borderRadius: BorderRadius.circular(context.sizes.radiusLarge),
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
                Container(
                  color: context.customColors.cardBg,
                ),

                _buildBackground(),

                // 1. Dark Gradient Scrim to ensure text legibility
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.85),
                          Colors.black.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),

                // 2. Product Text Content
                Padding(
                  padding: EdgeInsets.all(context.sizes.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        product.name,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: context.sizes.space8),

                      Text(
                        product.description ?? 'Premium Product',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),

                      SizedBox(height: context.sizes.space12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: context.textTheme.titleSmall?.copyWith(
                              color: context.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ClipOval(
                            child: Material(
                              color: context.colorScheme.primary.withValues(alpha: 0.15),
                              child: InkWell(
                                onTap: () async {
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
                                  if (cart.isLoading) return;

                                  if (cart.cart == null) {
                                    await cart.initializeCart(auth.currentUser!.id);
                                  }
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.add_shopping_cart,
                                    color: context.colorScheme.primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Top-Right "Favorite" Heart Overlay Button
                Positioned(
                  top: context.sizes.space12,
                  right: context.sizes.space12,
                  child: ClipOval(
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.45),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.redAccent : Colors.white,
                          size: 18,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(product);
                        },
                      ),
                    ),
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
