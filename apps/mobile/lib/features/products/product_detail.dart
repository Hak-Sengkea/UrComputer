import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/providers/product_provider.dart';
import 'package:mobile/providers/favorites_provider.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/providers/cart_provider.dart';
import 'package:mobile/providers/compare_provider.dart';
import 'package:mobile/features/cart/widgets/quantity_button.dart';
import 'package:mobile/theme/theme_context.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final String productId;

  const ProductDetail({super.key, required this.productId});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late final Future<Product?> _productFuture;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _productFuture = context.read<ProductProvider>().getProductById(
      widget.productId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favoritesProvider = context.watch<FavoritesProvider>();

    return FutureBuilder<Product?>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(title: const Text('Product Detail')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(title: const Text('Product Detail')),
            body: _ProductDetailStateView(
              icon: Icons.error_outline,
              title: 'Something went wrong',
              message: snapshot.error.toString(),
            ),
          );
        }

        final product = snapshot.data;
        if (product == null) {
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(title: const Text('Product Detail')),
            body: const _ProductDetailStateView(
              icon: Icons.inventory_2_outlined,
              title: 'Product not found',
              message: 'This product may no longer be available.',
            ),
          );
        }

        final isFav = favoritesProvider.isFavorite(product.id);

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            title: const Text('Product Detail'),
            actions: [
              // 1. Add to Compare Button (Text + Icon for clarity)
              TextButton.icon(
                label: Text(
                  'Compare',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: Icon(Icons.compare_arrows_rounded, color: context.colorScheme.primary, size: 20),
                onPressed: () {
                  final compareProvider = context.read<CompareProvider>();
                  final router = GoRouter.of(context); // Save GoRouter reference before page is disposed!

                  // Check if already in the compare list
                  if (compareProvider.selectedProducts.any((p) => p.id == product.id)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('This product is already in the compare list.'),
                        backgroundColor: context.colorScheme.error,
                      ),
                    );
                    return;
                  }

                  // Check if limit of 3 is reached
                  if (compareProvider.selectedProducts.length >= 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Comparison list is full. Limit is 3 products.'),
                        backgroundColor: context.colorScheme.error,
                      ),
                    );
                    return;
                  }

                  // Check if it belongs to a different category
                  if (compareProvider.selectedProducts.isNotEmpty &&
                      compareProvider.selectedProducts.first.categoryId != product.categoryId) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Cannot compare: items must be from the same category.'),
                        backgroundColor: context.colorScheme.error,
                      ),
                    );
                    return;
                  }

                  final wasAdded = compareProvider.addProduct(product);
                  if (wasAdded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to comparison!'),
                        backgroundColor: context.colorScheme.primary,
                        action: SnackBarAction(
                          label: 'View Compare',
                          textColor: context.colorScheme.onPrimary,
                          onPressed: () => router.push('/compare'), // Safe navigation!
                        ),
                      ),
                    );
                  }
                },
              ),
              // 2. Add to Favorites Button
              IconButton(
                tooltip: isFav ? 'Remove from Favorites' : 'Add to Favorites',
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? context.colorScheme.error : null,
                ),
                onPressed: () {
                  favoritesProvider.toggleFavorite(product);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.edgeMarginMobile,
              AppSizes.space16,
              AppSizes.edgeMarginMobile,
              AppSizes.space32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductGallery(product: product),
                const SizedBox(height: AppSizes.space16),
                ProductSummaryCard(
                  product: product,
                  quantity: _quantity,
                  onIncrement: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                  onDecrement: () {
                    if (_quantity > 1) {
                      setState(() {
                        _quantity--;
                      });
                    }
                  },
                  onAddToCart: () async {
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
                    await cart.addToCart(product, _quantity);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} (x$_quantity) added to cart!'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSizes.space16),
                QuickSpecs(product: product),
                const SizedBox(height: AppSizes.space16),
                PerformanceSection(product: product),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductGallery extends StatefulWidget {
  final Product product;

  const ProductGallery({super.key, required this.product});

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final images = _galleryImages;
    final selectedIndex = _selectedIndex < images.length ? _selectedIndex : 0;
    final selectedImage = images.isEmpty ? null : images[selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.18),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: selectedImage == null
              ? _GalleryPlaceholder(productName: widget.product.name)
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      selectedImage.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _GalleryPlaceholder(productName: widget.product.name),
                    ),
                    Positioned(
                      left: AppSizes.space12,
                      bottom: AppSizes.space12,
                      child: _ImageCountBadge(
                        count: images.length,
                        label: selectedImage.viewAngle,
                      ),
                    ),
                  ],
                ),
        ),
        if (images.isNotEmpty) ...[
          const SizedBox(height: AppSizes.space12),
          Text(
            'Product Images',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.space8),
          SizedBox(
            height: 76,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.space8),
              itemBuilder: (context, index) {
                final image = images[index];
                final isSelected = index == selectedIndex;

                return _AngleThumbnail(
                  image: image,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedIndex = index),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  List<_GalleryImage> get _galleryImages {
    final galleryImages = <_GalleryImage>[];
    final addedUrls = <String>{};
    final mainImage = widget.product.image?.trim();

    if (mainImage != null && mainImage.isNotEmpty) {
      galleryImages.add(_GalleryImage(imageUrl: mainImage, viewAngle: 'Main'));
      addedUrls.add(mainImage);
    }

    final productImages = [...?widget.product.viewAngle]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    for (final image in productImages) {
      final imageUrl = image.imageUrl.trim();
      if (imageUrl.isEmpty || addedUrls.contains(imageUrl)) continue;

      galleryImages.add(
        _GalleryImage(imageUrl: imageUrl, viewAngle: image.viewAngle),
      );
      addedUrls.add(imageUrl);
    }

    return galleryImages;
  }
}

class _AngleThumbnail extends StatelessWidget {
  final _GalleryImage image;
  final bool isSelected;
  final VoidCallback onTap;

  const _AngleThumbnail({
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 96,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.48,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.18),
              width: isSelected ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                image.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.surface.withValues(alpha: 0.84),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: AppSizes.space8,
                right: AppSizes.space8,
                bottom: AppSizes.space4,
                child: Text(
                  image.viewAngle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryImage {
  final String imageUrl;
  final String viewAngle;

  const _GalleryImage({required this.imageUrl, required this.viewAngle});
}

class ProductSummaryCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToCart;

  const ProductSummaryCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount = product.discount != null && product.discount! > 0;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.space12),
              _StockBadge(stock: product.stock),
            ],
          ),
          const SizedBox(height: AppSizes.space12),
          if (product.description?.trim().isNotEmpty ?? false)
            Text(
              product.description!.trim(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: AppSizes.space16),
          Row(
            children: [
              Text(
                'Qty:',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSizes.space8),
              QuantityButton(
                quantity: quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
              const SizedBox(width: AppSizes.space12),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                      textStyle: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.space16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${product.discountedPrice.toStringAsFixed(2)}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (hasDiscount) ...[
                const SizedBox(width: AppSizes.space8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (hasDiscount) ...[
            const SizedBox(height: AppSizes.space8),
            Text(
              '${product.discount!.toStringAsFixed(0)}% off',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class QuickSpecs extends StatelessWidget {
  final Product product;

  const QuickSpecs({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final specs = [
      _SpecItem(
        Icons.star_outline,
        'Rating',
        product.rating?.toStringAsFixed(1) ?? 'New',
      ),
      _SpecItem(Icons.reviews_outlined, 'Reviews', '${product.reviews ?? 0}'),
      _SpecItem(Icons.inventory_2_outlined, 'Stock', _stockText(product.stock)),
      _SpecItem(
        Icons.sell_outlined,
        'Discount',
        _discountText(product.discount),
      ),
    ];

    return _DetailSection(
      title: 'Quick Specs',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 520;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: specs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWide ? 4 : 2,
              mainAxisSpacing: AppSizes.space12,
              crossAxisSpacing: AppSizes.space12,
              childAspectRatio: isWide ? 1.2 : 1.65,
            ),
            itemBuilder: (context, index) => _SpecTile(item: specs[index]),
          );
        },
      ),
    );
  }

  String _stockText(int? stock) {
    if (stock == null) return 'Check';
    if (stock <= 0) return 'Out';
    return '$stock left';
  }

  String _discountText(double? discount) {
    if (discount == null || discount <= 0) return 'None';
    return '${discount.toStringAsFixed(0)}%';
  }
}

class PerformanceSection extends StatelessWidget {
  final Product product;

  const PerformanceSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final items = [
      _PerformanceItem(
        icon: Icons.speed_outlined,
        title: 'Responsive Daily Use',
        value: _performanceLevel,
      ),
      _PerformanceItem(
        icon: Icons.sports_esports_outlined,
        title: 'Gaming Readiness',
        value: _gamingLevel,
      ),
      _PerformanceItem(
        icon: Icons.verified_outlined,
        title: 'Buyer Confidence',
        value: _confidenceLevel,
      ),
    ];

    return _DetailSection(
      title: 'Performance',
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _PerformanceTile(item: items[index]),
            if (index != items.length - 1)
              const SizedBox(height: AppSizes.space12),
          ],
        ],
      ),
    );
  }

  String get _performanceLevel {
    if (product.price >= 1200) return 'High';
    if (product.price >= 700) return 'Balanced';
    return 'Essential';
  }

  String get _gamingLevel {
    final text = '${product.name} ${product.description ?? ''}'.toLowerCase();
    if (text.contains('gaming') ||
        text.contains('rtx') ||
        text.contains('gpu')) {
      return 'Ready';
    }
    if (product.price >= 900) return 'Capable';
    return 'Casual';
  }

  String get _confidenceLevel {
    final rating = product.rating ?? 0;
    final reviews = product.reviews ?? 0;
    if (rating >= 4.5 && reviews >= 20) return 'Excellent';
    if (rating >= 4.0 || reviews >= 10) return 'Strong';
    return 'Emerging';
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.space12),
        child,
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.space16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.48,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.14),
        ),
      ),
      child: child,
    );
  }
}

class _SpecTile extends StatelessWidget {
  final _SpecItem item;

  const _SpecTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(item.icon, color: theme.colorScheme.primary, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSizes.space4),
              Text(
                item.value,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PerformanceTile extends StatelessWidget {
  final _PerformanceItem item;

  const _PerformanceTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Icon(item.icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppSizes.space12),
          Expanded(
            child: Text(
              item.title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.space12),
          Text(
            item.value,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final int? stock;

  const _StockBadge({required this.stock});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvailable = stock == null || stock! > 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.space12,
        vertical: AppSizes.space8,
      ),
      decoration: BoxDecoration(
        color: isAvailable
            ? theme.colorScheme.primary.withValues(alpha: 0.14)
            : theme.colorScheme.error.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Text(
        isAvailable ? 'In stock' : 'Out of stock',
        style: theme.textTheme.labelMedium?.copyWith(
          color: isAvailable
              ? theme.colorScheme.primary
              : theme.colorScheme.error,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ImageCountBadge extends StatelessWidget {
  final int count;
  final String label;

  const _ImageCountBadge({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.space12,
        vertical: AppSizes.space8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Text(
        '$label - $count ${count == 1 ? 'image' : 'images'}',
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _GalleryPlaceholder extends StatelessWidget {
  final String productName;

  const _GalleryPlaceholder({required this.productName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.devices_other_outlined,
              color: theme.colorScheme.primary,
              size: 56,
            ),
            const SizedBox(height: AppSizes.space12),
            Text(
              productName,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _ProductDetailStateView({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 48),
            const SizedBox(height: AppSizes.space12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.space8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecItem {
  final IconData icon;
  final String label;
  final String value;

  const _SpecItem(this.icon, this.label, this.value);
}

class _PerformanceItem {
  final IconData icon;
  final String title;
  final String value;

  const _PerformanceItem({
    required this.icon,
    required this.title,
    required this.value,
  });
}
