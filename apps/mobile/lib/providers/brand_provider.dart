import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/brand.dart';
import '../../data/repository/brand_repository.dart';

final brandRepositoryProvider = Provider((ref) => BrandRepository());

final allBrandsProvider = FutureProvider<List<Brand>>((ref) async {
  final repository = ref.watch(brandRepositoryProvider);
  return repository.getAllBrands();
});

final brandById = FutureProvider.family<Brand?, int>((ref, id) async {
  final repository = ref.watch(brandRepositoryProvider);
  return repository.getBrandById(id);
});

final searchBrands = FutureProvider.family<List<Brand>, String>((ref, query) async {
  final repository = ref.watch(brandRepositoryProvider);
  return repository.searchBrands(query);
});
