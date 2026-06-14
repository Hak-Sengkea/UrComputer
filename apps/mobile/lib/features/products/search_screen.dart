import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/providers/product_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search products...',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            _query = value;
          });
        },
      ),
    ),
    body: _buildResults(),
  );
}
Widget _buildResults() {
  final productsProvider = context.watch<ProductProvider>();
  if (productsProvider.isLoading) return const Center(child: CircularProgressIndicator());
  final filteredProducts = productsProvider.products.where((product) {
    return product.name
        .toLowerCase()
        .contains(_query.toLowerCase());
  }).toList();
   if (filteredProducts.isEmpty) {
    return const Center(child: Text('No products found'));
  }
  return ListView.builder(
    itemCount: filteredProducts.length,
    itemBuilder: (context, index) {
      final product = filteredProducts[index];

      return InkWell(
        onTap:(){
          context.push('/product/${product.id}');
        },
        child:ListTile(
        title: Text(product.name),
        subtitle: Text(
          '\$${product.price}',
        ),
      )
      );
    },
  );
}
}
