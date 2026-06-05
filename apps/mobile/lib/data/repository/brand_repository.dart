import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/brand.dart';

class BrandRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Brand>> getAllBrands() async {
    final response = await _supabase
        .from('brands')
        .select()
        .order('name', ascending: true);
    return (response as List).map((json) => Brand.fromJson(json)).toList();
  }

  Future<Brand?> getBrandById(String id) async {
    try {
      final response = await _supabase
          .from('brands')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (response == null) return null;
      return Brand.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<List<Brand>> searchBrands(String query) async {
    try {
      final response = await _supabase
          .from('brands')
          .select()
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('name', ascending: true);
      return (response as List).map((json) => Brand.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
