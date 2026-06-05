import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/user.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ✅ FIXED: Return the actual auth state stream, not null
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
  
  // Login method
  Future<bool> login(String email, String password) async {
    try {
      // Validate email format
      if (email.isEmpty) {
        throw Exception('Email is required');
      }
      
      if (!email.contains('@') || !email.contains('.')) {
        throw Exception('Please enter a valid email address');
      }
      
      if (password.isEmpty) {
        throw Exception('Password is required');
      }
      
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }
      
      // Sign in with Supabase Auth
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      return true;
    } catch (e) {
      throw Exception('Login failed: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }
  
  Future<bool> register(String email, String password, String confirmPassword, {
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      // Validate email
      if (email.isEmpty) {
        throw Exception('Email is required');
      }
      
      if (!email.contains('@') || !email.contains('.')) {
        throw Exception('Please enter a valid email address');
      }
      
      if (password.isEmpty) {
        throw Exception('Password is required');
      }
      
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }
      
      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }
      
      // Sign up with Supabase Auth
      await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName ?? '',
          'last_name': lastName ?? '',
          'phone': phone ?? '',
        },
      );
      
      return true;
      
    } catch (e) {
      throw Exception('Registration failed: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }
  
  // Get user data from profiles table or session fallback
  Future<User?> getUserData() async {
    try {
      final sessionUser = _supabase.auth.currentUser;
      if (sessionUser == null) return null;
      
      final profile = await _supabase
          .from('profiles')
          .select()
          .eq('id', sessionUser.id)
          .maybeSingle();
          
      if (profile == null) {
        // Fallback to local session metadata if trigger is still propagating
        return User(
          id: sessionUser.id,
          email: sessionUser.email ?? '',
          firstName: sessionUser.userMetadata?['first_name'] ?? '',
          lastName: sessionUser.userMetadata?['last_name'] ?? '',
          phone: sessionUser.userMetadata?['phone'] ?? '',
          profileImage: null,
          address: null,
          city: null,
          country: null,
          zipCode: null,
          createdAt: DateTime.tryParse(sessionUser.createdAt ?? ''),
        );
      }
      
      return User.fromJson(profile);
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> isLoggedIn() async {
    return _supabase.auth.currentSession != null;
  }
  
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
  
  Future<String?> getToken() async {
    return _supabase.auth.currentSession?.accessToken;
  }
}