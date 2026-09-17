import '../../../core/models/json_helpers.dart';
import 'message.dart';

/// `ConversationParticipant`.
class ConversationParticipant {
  const ConversationParticipant({required this.id, required this.fullName});

  final String id;
  final String fullName;

  factory ConversationParticipant.fromJson(Map<String, dynamic> json) => ConversationParticipant(
        id: json['id'] as String,
        fullName: json['full_name'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'full_name': fullName};
}

/// `ConversationResponse`.
class Conversation {
  const Conversation({
    required this.id,
    required this.listingType,
    required this.listingId,
    required this.buyer,
    required this.seller,
    required this.otherParty,
    required this.unreadCount,
    this.listingTitle,
    this.listingImage,
    this.lastMessage,
    this.createdAt,
  });

  final String id;

  /// `exchange` | `marketplace`
  final String listingType;
  final String listingId;
  final String? listingTitle;
  final String? listingImage;
  final ConversationParticipant buyer;
  final ConversationParticipant seller;
  final ConversationParticipant otherParty;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime? createdAt;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'] as String,
        listingType: json['listing_type'] as String? ?? '',
        listingId: json['listing_id'] as String? ?? '',
        listingTitle: readString(json['listing_title']),
        listingImage: readString(json['listing_image']),
        buyer: ConversationParticipant.fromJson(json['buyer'] as Map<String, dynamic>),
        seller: ConversationParticipant.fromJson(json['seller'] as Map<String, dynamic>),
        otherParty: ConversationParticipant.fromJson(json['other_party'] as Map<String, dynamic>),
        lastMessage: json['last_message'] == null ? null : Message.fromJson(json['last_message'] as Map<String, dynamic>),
        unreadCount: readInt(json['unread_count']) ?? 0,
        createdAt: readDateTime(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'listing_type': listingType,
        'listing_id': listingId,
        'listing_title': listingTitle,
        'listing_image': listingImage,
        'buyer': buyer.toJson(),
        'seller': seller.toJson(),
        'other_party': otherParty.toJson(),
        'last_message': lastMessage?.toJson(),
        'unread_count': unreadCount,
        'created_at': createdAt?.toIso8601String(),
      };
}
