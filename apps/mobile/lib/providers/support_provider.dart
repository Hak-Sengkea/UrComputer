import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/repository/support_repository.dart';
import '../../models/support_message.dart';

class SupportProvider extends ChangeNotifier {
  final SupportRepository _repository = SupportRepository();

  String? _roomId;
  List<SupportMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<List<SupportMessage>>? _subscription;

  String? get roomId => _roomId;
  List<SupportMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize the support chat: load room, load history, subscribe to real-time updates
  Future<void> initializeChat() async {
    // If already loaded or loading, do not reload
    if (_roomId != null || _isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _roomId = await _repository.getOrCreateActiveRoom();

      // Retrieve existing message history
      _messages = await _repository.getMessages(_roomId!);

      // Cancel any existing subscription
      await _subscription?.cancel();

      // Subscribe to real-time additions/modifications in the message list
      _subscription = _repository.subscribeToMessages(_roomId!).listen(
        (updatedMessages) {
          _messages = updatedMessages;
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = "Real-time subscription error: $error";
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Send a message
  Future<void> sendMessage(String content, String senderName) async {
    if (_roomId == null || content.trim().isEmpty) return;

    try {
      await _repository.sendMessage(_roomId!, content, senderName);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Clean up subscription when provider is disposed
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
