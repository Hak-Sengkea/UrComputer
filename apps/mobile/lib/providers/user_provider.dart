import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../data/repository/user_repository.dart';

final userRepositoryProvider = Provider((ref) => UserRepository());

final allUsersProvider = FutureProvider<List<User>>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getAllUsers();
});

final userById = FutureProvider.family<User?, int>((ref, id) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserById(id);
});

final userByEmail = FutureProvider.family<User?, String>((ref, email) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserByEmail(email);
});

final searchUsers = FutureProvider.family<List<User>, String>((ref, query) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.searchUsers(query);
});
