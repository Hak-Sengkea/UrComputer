import 'package:flutter/material.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/providers/favorites_provider.dart';
import 'package:mobile/theme/theme_context.dart';
import 'package:provider/provider.dart';
import 'widgets/favorites_empty_state.dart';
import 'widgets/item_favorite.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'My Wishlist',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: favoritesProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? const FavoritesEmptyState()
              : _FavoritesList(
                  products: favorites,
                  favoritesProvider: favoritesProvider,
                ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  final List<Product> products;
  final FavoritesProvider favoritesProvider;

  const _FavoritesList({
    required this.products,
    required this.favoritesProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: context.sizes.edgeMarginMobile,
        vertical: context.sizes.space16,
      ),
      itemCount: products.length,
      separatorBuilder: (context, index) => SizedBox(
        height: context.sizes.space12,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ItemFavorite(
          product: product,
          favoritesProvider: favoritesProvider,
        );
      },
    );
  }
}
