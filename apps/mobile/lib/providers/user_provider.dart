import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../data/repository/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository = UserRepository();
  
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<User> get users => _users;
  List<User> get filteredUsers => _filteredUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _repository.getAllUsers();
      _filteredUsers = _users;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<User?> getUserById(String id) async {
    return await _repository.getUserById(id);
  }

  Future<User?> getUserByEmail(String email) async {
    return await _repository.getUserByEmail(email);
  }

  Future<void> searchUsers(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      _filteredUsers = await _repository.searchUsers(query);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
