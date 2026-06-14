import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/providers/product_provider.dart';
import 'package:mobile/providers/compare_provider.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:mobile/widgets/shared/product_card.dart';
import 'package:provider/provider.dart';

class ProductByCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String? categoryName;

  const ProductByCategoryScreen({
    super.key,
    required this.categoryId,
    this.categoryName,
  });

  @override
  State<ProductByCategoryScreen> createState() =>
      _ProductByCategoryScreenState();
}

class _ProductByCategoryScreenState extends State<ProductByCategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getProductsByCategory(widget.categoryId);
    });
  }

  @override
  void didUpdateWidget(ProductByCategoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.categoryId != widget.categoryId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductProvider>().getProductsByCategory(
          widget.categoryId,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.filteredProducts;
    final title = widget.categoryName?.trim().isNotEmpty == true
        ? widget.categoryName!.trim()
        : 'Category products';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(title),
        actions: [
          // Clear Compare Button with Label
          Consumer<CompareProvider>(
            builder: (context, compareProvider, child) {
              final count = compareProvider.count;
              return TextButton.icon(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                icon: Badge(
                  label: Text('$count'),
                  isLabelVisible: count > 0,
                  child: const Icon(Icons.compare_arrows_rounded, size: 20),
                ),
                label: Text(
                  'Compare',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  context.push('/compare');
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.edgeMarginMobile),
        child: productProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : productProvider.errorMessage != null
            ? Center(
                child: Text(
                  productProvider.errorMessage!,
                  textAlign: TextAlign.center,
                ),
              )
            : products.isEmpty
            ? Center(
                child: Text(
                  'No products found in $title',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 700 ? 3 : 2;

                  return GridView.builder(
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: AppSizes.space12,
                      crossAxisSpacing: AppSizes.space12,
                      childAspectRatio: 0.86,
                    ),
                    itemBuilder: (context, index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusLarge,
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.08),
                          ),
                        ),
                        child: ProductCard(
                          product: products[index],
                          compact: true,
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
