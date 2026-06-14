import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_context.dart';
import '../../../models/product.dart';
import 'product_header_card.dart';
import 'spec_row.dart';

class ProductCompareView extends StatelessWidget {
  final List<Product> products;
  final bool onlyShowDifferences;

  const ProductCompareView({
    super.key,
    required this.products,
    required this.onlyShowDifferences,
  });

  @override
  Widget build(BuildContext context) {
    final allKeys = <String>{};
    for (var p in products) {
      allKeys.addAll(p.specs.keys);
    }
    final specKeys = allKeys.toList();

    if (onlyShowDifferences && products.length > 1) {
      specKeys.retainWhere((key) {
        final firstVal = products.first.specs[key]?.toString() ?? '';
        return products.any((p) => (p.specs[key]?.toString() ?? '') != firstVal);
      });
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: context.sizes.space16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: context.colorScheme.outline.withValues(alpha: 0.12))),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Center(
                  child: Text(
                    'Products',
                    style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: products.map((p) => ProductHeaderCard(product: p)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              SpecRow(title: 'Price', values: products.map((p) => '\$${p.price.toStringAsFixed(2)}').toList()),
              SpecRow(title: 'Rating', values: products.map((p) => '${p.rating ?? "N/A"} ★').toList()),
              SpecRow(title: 'Discount', values: products.map((p) => p.discount != null ? '${p.discount}%' : 'None').toList()),
              ...specKeys.map((key) {
                return SpecRow(
                  title: key,
                  values: products.map((p) => p.specs[key]?.toString() ?? '-').toList(),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}