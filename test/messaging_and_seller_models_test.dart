import 'package:flutter_test/flutter_test.dart';
import 'package:upazila_app/features/marketplace/domain/contact_reveal.dart';
import 'package:upazila_app/features/marketplace/domain/favorites.dart';
import 'package:upazila_app/features/marketplace/domain/seller_review.dart';
import 'package:upazila_app/features/messaging/domain/conversation.dart';
import 'package:upazila_app/features/messaging/domain/message.dart';

const _seller = {
  'id': 'u-1',
  'full_name': 'Rahim',
  'phone_masked': '+88017****678',
  'phone_verified': true,
  'member_since': '2025-01-02T03:04:05Z',
  'trust_score': 7,
  'avg_rating': 4.5,
  'review_count': 3,
};

void main() {
  test('Message round-trips and reads read_at', () {
    final json = {
      'id': 'm-1',
      'conversation_id': 'c-1',
      'sender_id': 'u-1',
      'body': 'Hello there',
      'created_at': '2025-05-01T10:00:00Z',
      'read_at': null,
    };
    final message = Message.fromJson(json);
    expect(message.body, 'Hello there');
    expect(message.readAt, isNull);
    expect(Message.fromJson(message.toJson()).senderId, 'u-1');
  });

  test('Conversation parses participants and embedded last message', () {
    final json = {
      'id': 'c-1',
      'listing_type': 'exchange',
      'listing_id': 'l-1',
      'listing_title': 'Old sofa',
      'listing_image': null,
      'buyer': {'id': 'u-1', 'full_name': 'Rahim'},
      'seller': {'id': 'u-2', 'full_name': 'Karim'},
      'other_party': {'id': 'u-2', 'full_name': 'Karim'},
      'last_message': {
        'id': 'm-1',
        'conversation_id': 'c-1',
        'sender_id': 'u-1',
        'body': 'Still available?',
        'created_at': '2025-05-01T10:00:00Z',
        'read_at': null,
      },
      'unread_count': 2,
      'created_at': '2025-05-01T09:00:00Z',
    };
    final conversation = Conversation.fromJson(json);
    expect(conversation.otherParty.fullName, 'Karim');
    expect(conversation.lastMessage?.body, 'Still available?');
    expect(conversation.unreadCount, 2);
    expect(Conversation.fromJson(conversation.toJson()).buyer.id, 'u-1');
  });

  test('Conversation tolerates a null last_message', () {
    final conversation = Conversation.fromJson({
      'id': 'c-2',
      'listing_type': 'marketplace',
      'listing_id': 'l-2',
      'listing_title': null,
      'listing_image': null,
      'buyer': {'id': 'u-1', 'full_name': 'Rahim'},
      'seller': {'id': 'u-2', 'full_name': 'Karim'},
      'other_party': {'id': 'u-1', 'full_name': 'Rahim'},
      'last_message': null,
      'unread_count': 0,
      'created_at': '2025-05-01T09:00:00Z',
    });
    expect(conversation.lastMessage, isNull);
  });

  test('SellerReview and SellerProfile parse ratings and embedded summary', () {
    final review = SellerReview.fromJson({
      'id': 'r-1',
      'seller_user_id': 'u-1',
      'reviewer_user_id': 'u-2',
      'reviewer_name': 'Karim',
      'listing_type': 'exchange',
      'listing_id': 'l-1',
      'rating': 4,
      'comment': 'Smooth deal',
      'created_at': '2025-05-01T10:00:00Z',
    });
    expect(review.rating, 4);
    expect(SellerReview.fromJson(review.toJson()).reviewerName, 'Karim');

    final profile = SellerProfile.fromJson({
      ..._seller,
      'active_listings': 3,
      'total_listings': 5,
      'reviews': [review.toJson()],
    });
    expect(profile.summary.fullName, 'Rahim');
    expect(profile.activeListings, 3);
    expect(profile.reviews.single.rating, 4);
  });

  test('ContactReveal parses seller name and phone', () {
    final reveal = ContactReveal.fromJson({'seller_name': 'Rahim', 'phone': '+8801712345678'});
    expect(reveal.sellerName, 'Rahim');
    expect(reveal.phone, '+8801712345678');
  });

  test('Favorites bundles exchange and marketplace lists and reports emptiness', () {
    final favorites = Favorites.fromJson({'exchange': [], 'marketplace': []});
    expect(favorites.isEmpty, isTrue);
  });
}
