import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../data/repository/product_repository.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository());

final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getAllProducts();
});

final productsByCategory = FutureProvider.family<List<Product>, int>((ref, categoryId) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductsByCategory(categoryId);
});

final productsByBrand = FutureProvider.family<List<Product>, int>((ref, brandId) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductsByBrand(brandId);
});

final productById = FutureProvider.family<Product?, int>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(id);
});

final searchProducts = FutureProvider.family<List<Product>, String>((ref, query) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.searchProducts(query);
});

final discountedProducts = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getDiscountedProducts();
});

final inStockProducts = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getInStockProducts();
});
