import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile/theme/theme_context.dart';
import '../../../models/product.dart';
import '../../../providers/compare_provider.dart';

class ProductHeaderCard extends StatelessWidget {
  final Product product;

  const ProductHeaderCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsets.symmetric(horizontal: context.sizes.space8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
            child: CachedNetworkImage(
              imageUrl: product.image ?? '',
              height: 70,
              width: 70,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Icon(Icons.devices, color: context.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle_outline, size: 18, color: context.colorScheme.error),
            onPressed: () => context.read<CompareProvider>().removeProduct(product.id),
          )
        ],
      ),
    );
  }
}