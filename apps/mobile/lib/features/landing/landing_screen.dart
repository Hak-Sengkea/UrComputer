import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/features/landing/widgets/landing_build_dream_section.dart';
import 'package:mobile/features/landing/widgets/landing_featured_deployments_section.dart';
import 'package:mobile/features/landing/widgets/landing_hero_banner.dart';
import 'package:mobile/features/landing/widgets/landing_join_alpha_section.dart';
import 'package:mobile/features/landing/widgets/landing_sector_section.dart';
import 'package:mobile/features/landing/widgets/landing_top_rated_section.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/providers/category_provider.dart';
import 'package:mobile/providers/product_provider.dart';
import 'package:mobile/widgets/heading.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LandingScreenContent();
  }
}

class _LandingScreenContent extends StatelessWidget {
  const _LandingScreenContent();

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final products = productProvider.products;
    final categories = categoryProvider.categories;

    Product? heroProduct;
    for (final product in products) {
      if (product.categoryId == 'c81dfa01-9f9e-4c74-a029-79257e84f502') {
        heroProduct = product;
        break;
      }
    }

    final featuredLaptops = products
        .where((product) => product.categoryId == 'c81dfa01-9f9e-4c74-a029-79257e84f501')
        .take(6)
        .toList();

    final topRated = [...products]
      ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    final topRatedSelection = topRated.take(3).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: Heading(
        onMenuPressed: () => context.go('/login'),
        actions: [
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () => context.go('/register'),
            child: const Text('Register'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.edgeMarginMobile,
            vertical: AppSizes.space16,
          ),
          child: productProvider.isLoading || categoryProvider.isLoading
              ? const SizedBox(
                  height: 360,
                  child: Center(child: CircularProgressIndicator()),
                )
              : (productProvider.errorMessage != null ||
                    categoryProvider.errorMessage != null)
              ? SizedBox(
                  height: 360,
                  child: Center(
                    child: Text(
                      productProvider.errorMessage ??
                          categoryProvider.errorMessage ??
                          'Failed to load data',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Column(
                  children: [
                    LandingHeroBanner(heroProduct: heroProduct),
                    const SizedBox(height: AppSizes.space24),
                    LandingSectorSection(categories: categories),
                    const SizedBox(height: AppSizes.space24),
                    LandingFeaturedDeploymentsSection(
                      products: featuredLaptops,
                    ),
                    const SizedBox(height: AppSizes.space24),
                    LandingBuildDreamSection(product: heroProduct),
                    const SizedBox(height: AppSizes.space24),
                    LandingTopRatedSection(products: topRatedSelection),
                    const SizedBox(height: AppSizes.space24),
                    const LandingJoinAlphaSection(),
                    const SizedBox(height: AppSizes.space24),
                  ],
                ),
        ),
      ),
    );
  }
}
