import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/features/home/widgets/category_overview.dart';
import 'package:mobile/features/home/widgets/hero_section.dart';
import 'package:mobile/features/home/widgets/product_section.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/providers/brand_provider.dart';
import 'package:mobile/providers/product_provider.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:mobile/theme/app_text_style.dart';
import 'package:mobile/widgets/heading.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productProvider = context.watch<ProductProvider>();
    final brandProvider = context.watch<BrandProvider>();
    final authProvider = context.read<AuthProvider>();
    final List<Product> products = productProvider.products;
    final List<Product> pcComponents = products
        .where((p) => p.categoryId == 'c81dfa01-9f9e-4c74-a029-79257e84f503')
        .toList();
    final List<Product> pcBuilds = products
        .where((p) => p.categoryId == 'c81dfa01-9f9e-4c74-a029-79257e84f502')
        .toList();
    final List<Product> laptops = products
        .where((p) => p.categoryId == 'c81dfa01-9f9e-4c74-a029-79257e84f501')
        .toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: Heading(
        onMenuPressed: () {},
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.edgeMarginMobile,
          ),
          child: Column(
            children: [
              if (productProvider.isLoading) ...[
                SizedBox(
                  height: 320,
                  child: Center(child: const CircularProgressIndicator()),
                ),
              ] else if (productProvider.errorMessage != null) ...[
                SizedBox(
                  height: 320,
                  child: Center(
                    child: Text(
                      productProvider.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ] else if (pcComponents.isEmpty) ...[
                SizedBox(
                  height: 320,
                  child: Center(
                    child: const Text('No PC components available'),
                  ),
                ),
              ] else ...[
                HeroSection(pcComponents: pcComponents),
              ],
              const SizedBox(height: AppSizes.space12),
              CategoryOverview(
                icons: [
                  Icons.laptop,
                  Icons.headphones,
                  Icons.memory,
                  Icons.computer,
                  Icons.router,
                  Icons.storage,
                ],
                labels: ['Laptop', 'Audio', 'RAM', 'PC', 'Network', 'Storage'],
              ),
              const SizedBox(height: AppSizes.space8),
              ProductSection(title: 'Custom PC Builds', products: pcBuilds),
              ProductSection(title: 'Gaming Laptops', products: laptops),
              const SizedBox(height: AppSizes.space16),
              SizedBox(
                height: 60.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: brandProvider.brands.length,
                  itemBuilder: (context, index) {
                    final brand = brandProvider.brands[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMedium,
                          ),
                        ),
                        child: Chip(
                          label: Text(
                            brand.name,
                            style: AppTextStyle.displaySmall.copyWith(
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.space16),
            ],
          ),
        ),
      ),
    );
  }
}
