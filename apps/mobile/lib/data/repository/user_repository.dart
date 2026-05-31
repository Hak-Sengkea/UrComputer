import '../../models/user.dart';
import '../data_provider.dart';

class UserRepository {
  final JsonDataProvider _dataProvider = JsonDataProvider();

  Future<List<User>> getAllUsers() async {
    final data = await _dataProvider.loadUsers();
    final List<dynamic> usersJson = data['users'];
    return usersJson.map((json) => User.fromJson(json)).toList();
  }

  Future<User?> getUserById(int id) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere((u) => u.email.toLowerCase() == email.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> searchUsers(String query) async {
    final users = await getAllUsers();
    final lowerQuery = query.toLowerCase();
    return users
        .where((u) => 
            u.fullName.toLowerCase().contains(lowerQuery) ||
            u.email.toLowerCase().contains(lowerQuery) ||
            (u.phone?.contains(query) ?? false))
        .toList();
  }
}
