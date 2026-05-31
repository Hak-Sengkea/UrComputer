import '../../models/category.dart';
import '../data_provider.dart';

class CategoryRepository {
  final JsonDataProvider _dataProvider = JsonDataProvider();

  Future<List<Category>> getAllCategories() async {
    final data = await _dataProvider.loadCategories();
    final List<dynamic> categoriesJson = data['categories'];
    return categoriesJson.map((json) => Category.fromJson(json)).toList();
  }

  Future<Category?> getCategoryById(int id) async {
    final categories = await getAllCategories();
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Category>> searchCategories(String query) async {
    final categories = await getAllCategories();
    final lowerQuery = query.toLowerCase();
    return categories
        .where((c) => c.name.toLowerCase().contains(lowerQuery) ||
            (c.description?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }
}
