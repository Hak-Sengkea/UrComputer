import '../../models/brand.dart';
import '../data_provider.dart';

class BrandRepository {
  final JsonDataProvider _dataProvider = JsonDataProvider();

  Future<List<Brand>> getAllBrands() async {
    final data = await _dataProvider.loadBrands();
    final List<dynamic> brandsJson = data['brands'];
    return brandsJson.map((json) => Brand.fromJson(json)).toList();
  }

  Future<Brand?> getBrandById(int id) async {
    final brands = await getAllBrands();
    try {
      return brands.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Brand>> searchBrands(String query) async {
    final brands = await getAllBrands();
    final lowerQuery = query.toLowerCase();
    return brands
        .where(
          (b) =>
              b.name.toLowerCase().contains(lowerQuery) ||
              (b.description?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .toList();
  }
}
