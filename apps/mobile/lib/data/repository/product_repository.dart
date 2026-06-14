import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/product.dart';

class ProductRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
    static const String _productSelectQuery = '''
    *,
    product_images(*)
  ''';


  Future<List<Product>> getAllProducts() async {
    final response = await _supabase
        .from('products')
        .select('''*,
          product_images(*)
        ''')
        .order('id', ascending: true);
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final response = await _supabase
        .from('products')
        .select('''*,
          product_images(*)
        ''')
        .eq('category_id', categoryId);
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> getProductsByBrand(String brandId) async {
    final response = await _supabase
        .from('products')
        .select()
        .eq('brand_id', brandId);
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .or('name.ilike.%$query%,description.ilike.%$query%');
      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      // 🌟 Cleaned up: You don't need a separate network request _getProductImages(id)
      // We can use the nested select here just like the other functions!
      final productResponse = await _supabase
          .from('products')
          .select(_productSelectQuery)
          .eq('id', id)
          .maybeSingle();
        print('RESPONSE = $productResponse');

      if (productResponse == null) return null;

      return Product.fromJson(productResponse);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _getProductImages(String productId) async {
    try {
      final response = await _supabase
          .from('product_images')
          .select()
          .eq('product_id', productId)
          .order('display_order', ascending: true);

      return (response as List)
          .map((json) => Map<String, dynamic>.from(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Product>> getDiscountedProducts() async {
    final response = await _supabase
        .from('products')
        .select()
        .gt('discount', 0);
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> getInStockProducts() async {
    final response = await _supabase.from('products').select().gt('stock', 0);
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }
}
