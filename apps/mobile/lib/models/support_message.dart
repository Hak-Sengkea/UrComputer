class SupportMessage {
  final String id;
  final String roomId;
  final String? senderId;
  final String senderName;
  final bool isFromCustomer;
  final String content;
  final DateTime createdAt;

  SupportMessage({
    required this.id,
    required this.roomId,
    this.senderId,
    required this.senderName,
    required this.isFromCustomer,
    required this.content,
    required this.createdAt,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      senderId: json['sender_id'] as String?,
      senderName: json['sender_name'] as String? ?? 'User',
      isFromCustomer: json['is_from_customer'] as bool? ?? true,
      content: json['content'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'sender_name': senderName,
      'is_from_customer': isFromCustomer,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
