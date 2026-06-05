import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../models/pc_build.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  // Get products by category ID
  Future<List<Product>> getProductsByCategoryId(String categoryId) async {
    try {
      final response = await _client
          .from('products')
          .select('*, brands!inner(name), categories!inner(name)')
          .eq('category_id', categoryId)
          .order('price');
      
      return response.map<Product>((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Get product by ID
  Future<Product?> getProductById(String id) async {
    try {
      final response = await _client
          .from('products')
          .select('*, brands!inner(name), categories!inner(name)')
          .eq('id', id)
          .single();
      return Product.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Get all categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await _client
          .from('categories')
          .select('*')
          .order('name');
      return response;
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  // PC Builds CRUD
  Future<List<PCBuild>> getUserBuilds(String userId) async {
    try {
      final response = await _client
          .from('pc_builds')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return response.map<PCBuild>((json) => PCBuild.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load builds: $e');
    }
  }

  Future<PCBuild> saveBuild(PCBuild build) async {
    try {
      final response = await _client
          .from('pc_builds')
          .upsert(build.toJson())
          .select()
          .single();
      
      return PCBuild.fromJson(response);
    } catch (e) {
      throw Exception('Failed to save build: $e');
    }
  }

  Future<void> deleteBuild(String buildId) async {
    try {
      await _client.from('pc_builds').delete().eq('id', buildId);
    } catch (e) {
      throw Exception('Failed to delete build: $e');
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _client
          .from('products')
          .select('*, brands!inner(name), categories!inner(name)')
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .limit(30);
      
      return response.map<Product>((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }
}