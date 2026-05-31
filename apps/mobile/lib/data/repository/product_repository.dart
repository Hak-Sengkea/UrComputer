import '../../models/product.dart';
import '../data_provider.dart';

class ProductRepository {
  final JsonDataProvider _dataProvider = JsonDataProvider();

  Future<List<Product>> getAllProducts() async {
    final data = await _dataProvider.loadProducts();
    final List<dynamic> productsJson = data['products'];
    return productsJson.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final products = await getAllProducts();
    return products.where((p) => p.categoryId == categoryId).toList();
  }

  Future<List<Product>> getProductsByBrand(int brandId) async {
    final products = await getAllProducts();
    return products.where((p) => p.brandId == brandId).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final products = await getAllProducts();
    final lowerQuery = query.toLowerCase();
    return products
        .where((p) => p.name.toLowerCase().contains(lowerQuery) ||
            (p.description?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  Future<Product?> getProductById(int id) async {
    final products = await getAllProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> getDiscountedProducts() async {
    final products = await getAllProducts();
    return products
        .where((p) => p.discount != null && p.discount! > 0)
        .toList();
  }

  Future<List<Product>> getInStockProducts() async {
    final products = await getAllProducts();
    return products.where((p) => p.stock != null && p.stock! > 0).toList();
  }
}