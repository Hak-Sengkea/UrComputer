import 'package:flutter/material.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:mobile/widgets/shared/product_card.dart';

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
                child: ProductCard(
                  product: product,
                ),
              );
            },
          ),
        ),
      ],
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
