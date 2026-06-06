import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final String productId;
  const ProductDetail({super.key,required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Center(
        child: Text('Product Detail Screen of product ID: $productId'),
      ),
    );  
  }
}