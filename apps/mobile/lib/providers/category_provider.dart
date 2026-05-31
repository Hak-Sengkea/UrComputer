import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/category.dart';
import '../../data/repository/category_repository.dart';

final categoryRepositoryProvider = Provider((ref) => CategoryRepository());

final allCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getAllCategories();
});

final categoryById = FutureProvider.family<Category?, int>((ref, id) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategoryById(id);
});

final searchCategories = FutureProvider.family<List<Category>, String>((ref, query) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.searchCategories(query);
});
