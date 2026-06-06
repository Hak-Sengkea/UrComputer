import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/category.dart';

class CategoryRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Category>> getAllCategories() async {
    final response = await _supabase
        .from('categories')
        .select()
        .order('name', ascending: true);
    return (response as List).map((json) => Category.fromJson(json)).toList();
  }

  Future<Category?> getCategoryById(String id) async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (response == null) return null;
      return Category.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<List<Category>> searchCategories(String query) async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('name', ascending: true);
      return (response as List).map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
