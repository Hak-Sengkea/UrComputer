import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  // Demo users storage (replace with actual API)
  final Map<String, Map<String, dynamic>> _demoUsers = {
    'demo@example.com': {
      'password': 'password123',
      'user': {
        'id': 1,
        'email': 'demo@example.com',
        'firstName': 'Demo',
        'lastName': 'User',
        'phone': '+1234567890',
        'profileImage': null,
        'address': '123 Demo St',
        'city': 'Demo City',
        'country': 'Demo Country',
        'zipCode': '12345',
        'createdAt': DateTime.now().toIso8601String(),
      }
    },
    'john@example.com': {
      'password': 'john123',
      'user': {
        'id': 2,
        'email': 'john@example.com',
        'firstName': 'John',
        'lastName': 'Doe',
        'phone': '+0987654321',
        'profileImage': null,
        'address': '456 John Ave',
        'city': 'John City',
        'country': 'John Country',
        'zipCode': '67890',
        'createdAt': DateTime.now().toIso8601String(),
      }
    },
  };
  
  // Login method
  Future<bool> login(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
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
      
      // Check demo users
      if (_demoUsers.containsKey(email) && _demoUsers[email]!['password'] == password) {
        final userData = _demoUsers[email]!['user'];
        final user = User.fromJson(userData!);
        await _saveUserData(user);
        return true;
      }
      
      // For demo: Accept any valid email/password and create a new user
      if (email.isNotEmpty && password.isNotEmpty) {
        final user = User(
          id: DateTime.now().millisecondsSinceEpoch,
          email: email,
          firstName: email.split('@')[0],
          lastName: 'User',
          phone: null,
          profileImage: null,
          address: null,
          city: null,
          country: null,
          zipCode: null,
          createdAt: DateTime.now(),
        );
        
        await _saveUserData(user);
        return true;
      }
      
      throw Exception('Invalid email or password');
    } catch (e) {
      throw Exception('Login failed: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }
  
  // Register method
  Future<bool> register(String email, String password, String confirmPassword, {
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Validate email
      if (email.isEmpty) {
        throw Exception('Email is required');
      }
      
      if (!email.contains('@') || !email.contains('.')) {
        throw Exception('Please enter a valid email address');
      }
      
      // Validate password
      if (password.isEmpty) {
        throw Exception('Password is required');
      }
      
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }
      
      // Validate password confirmation
      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }
      
      // Check if email already exists in demo
      if (_demoUsers.containsKey(email)) {
        throw Exception('Email already registered');
      }
      
      // Create new user
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch,
        email: email,
        firstName: firstName ?? email.split('@')[0],
        lastName: lastName ?? 'User',
        phone: phone,
        profileImage: null,
        address: null,
        city: null,
        country: null,
        zipCode: null,
        createdAt: DateTime.now(),
      );
      
      // Store in demo users (in real app, this would be API call)
      _demoUsers[email] = {
        'password': password,
        'user': user.toJson(),
      };
      
      // Auto-login after registration
      await _saveUserData(user);
      return true;
      
    } catch (e) {
      throw Exception('Registration failed: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }
  
  // Save user data to local storage
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, 'token_${user.id}_${DateTime.now().millisecondsSinceEpoch}');
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
  
  // Get user data from local storage
  Future<User?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null && userJson.isNotEmpty) {
        return User.fromJson(jsonDecode(userJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
  
  // Get auth token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}