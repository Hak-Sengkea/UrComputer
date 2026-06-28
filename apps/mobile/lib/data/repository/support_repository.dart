import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/support_message.dart';

class SupportRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Retrieve or create an active support room for the current user
  Future<String> getOrCreateActiveRoom() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception("User must be logged in to access support");
    }

    final userId = currentUser.id;

    // Check for an existing open room
    final existing = await _supabase
        .from('support_rooms')
        .select('id')
        .eq('customer_id', userId)
        .eq('status', 'open')
        .maybeSingle();

    if (existing != null) {
      return existing['id'] as String;
    }

    // Otherwise, create a new support room
    final newRoom = await _supabase
        .from('support_rooms')
        .insert({
          'customer_id': userId,
          'status': 'open',
        })
        .select('id')
        .single();

    return newRoom['id'] as String;
  }

  // Get historical messages in chronological order
  Future<List<SupportMessage>> getMessages(String roomId) async {
    final response = await _supabase
        .from('support_messages')
        .select()
        .eq('room_id', roomId)
        .order('created_at', ascending: true);

    return (response as List).map((json) => SupportMessage.fromJson(json)).toList();
  }

  // Real-time message subscription stream using Supabase streams
  Stream<List<SupportMessage>> subscribeToMessages(String roomId) {
    return _supabase
        .from('support_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: true)
        .map((list) => list.map((json) => SupportMessage.fromJson(json)).toList());
  }

  // Send a message from the customer
  Future<void> sendMessage(String roomId, String content, String senderName) async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception("User must be logged in to send support messages");
    }

    await _supabase.from('support_messages').insert({
      'room_id': roomId,
      'sender_id': currentUser.id,
      'sender_name': senderName,
      'is_from_customer': true,
      'content': content.trim(),
    });
  }
}
