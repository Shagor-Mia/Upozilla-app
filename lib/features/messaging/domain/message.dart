import '../../../core/models/json_helpers.dart';

/// `MessageResponse`.
class Message {
  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.body,
    this.createdAt,
    this.readAt,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String body;
  final DateTime? createdAt;
  final DateTime? readAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as String,
        conversationId: json['conversation_id'] as String? ?? '',
        senderId: json['sender_id'] as String? ?? '',
        body: json['body'] as String? ?? '',
        createdAt: readDateTime(json['created_at']),
        readAt: readDateTime(json['read_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversation_id': conversationId,
        'sender_id': senderId,
        'body': body,
        'created_at': createdAt?.toIso8601String(),
        'read_at': readAt?.toIso8601String(),
      };
}
