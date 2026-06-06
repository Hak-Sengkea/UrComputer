import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../../models/user.dart';

class UserRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<User>> getAllUsers() async {
    final response = await _supabase
        .from('profiles')
        .select()
        .order('first_name', ascending: true);
    return (response as List).map((json) => User.fromJson(json)).toList();
  }

  Future<User?> getUserById(String id) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (response == null) return null;
      return User.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('email', email)
          .maybeSingle();
      if (response == null) return null;
      return User.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> searchUsers(String query) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .or('first_name.ilike.%$query%,last_name.ilike.%$query%,email.ilike.%$query%,phone.ilike.%$query%')
          .order('first_name', ascending: true);
      return (response as List).map((json) => User.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}