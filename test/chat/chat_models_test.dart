import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idec_conference_app/features/chat/data/models/chat_enums.dart';
import 'package:idec_conference_app/features/chat/data/models/conversation_model.dart';
import 'package:idec_conference_app/features/chat/data/models/message_model.dart';
import 'package:idec_conference_app/features/chat/data/models/participant_model.dart';

/// Unit Tests for Chat Models
void main() {
  group('ChatEnums', () {
    test('ChatConversationType should convert to string correctly', () {
      expect(ChatConversationType.marketplace.value, 'MARKETPLACE');
      expect(ChatConversationType.support.value, 'SUPPORT');
      expect(ChatConversationType.event.value, 'EVENT');
      expect(ChatConversationType.group.value, 'GROUP');
      expect(ChatConversationType.broadcast.value, 'BROADCAST');
    });

    test('ChatConversationType should parse from string correctly', () {
      expect(
        ChatConversationTypeX.fromString('MARKETPLACE'),
        ChatConversationType.marketplace,
      );
      expect(
        ChatConversationTypeX.fromString('support'),
        ChatConversationType.support,
      );
      expect(
        ChatConversationTypeX.fromString('unknown'),
        ChatConversationType.marketplace, // default
      );
    });

    test('ChatConversationType should have Arabic display names', () {
      expect(ChatConversationType.marketplace.displayNameAr, 'المتجر');
      expect(ChatConversationType.support.displayNameAr, 'الدعم الفني');
      expect(ChatConversationType.event.displayNameAr, 'المؤتمر');
    });

    test('ChatMessageType should convert correctly', () {
      expect(ChatMessageType.text.value, 'TEXT');
      expect(ChatMessageType.image.value, 'IMAGE');
      expect(ChatMessageType.productCard.value, 'PRODUCT_CARD');
    });

    test('ChatPriority should convert correctly', () {
      expect(ChatPriority.low.value, 'LOW');
      expect(ChatPriority.normal.value, 'NORMAL');
      expect(ChatPriority.high.value, 'HIGH');
      expect(ChatPriority.urgent.value, 'URGENT');
    });
  });

  group('ChatParticipant', () {
    test('should parse from JSON correctly', () {
      final json = {
        'id': 'participant-1',
        'conversationId': 'conv-1',
        'userId': 'user-1',
        'role': 'OWNER',
        'userName': 'Test User',
        'isOnline': true,
        'joinedAt': '2024-01-01T00:00:00.000Z',
      };

      final participant = ChatParticipant.fromJson(json);

      expect(participant.id, 'participant-1');
      expect(participant.userId, 'user-1');
      expect(participant.role, 'OWNER');
      expect(participant.userName, 'Test User');
      expect(participant.isOnline, true);
      expect(participant.isActive, true);
    });

    test('should convert to JSON correctly', () {
      final participant = ChatParticipant(
        id: 'p-1',
        conversationId: 'c-1',
        userId: 'u-1',
        role: 'MEMBER',
        joinedAt: DateTime(2024, 1, 1),
      );

      final json = participant.toJson();

      expect(json['id'], 'p-1');
      expect(json['role'], 'MEMBER');
      expect(json['leftAt'], null);
    });

    test('should handle nested user data', () {
      final json = {
        'id': 'p-1',
        'conversationId': 'c-1',
        'userId': 'u-1',
        'role': 'MEMBER',
        'user': {
          'phone': '+966501234567',
          'profile': {
            'fullNameAr': 'محمد أحمد',
            'profilePhotoUrl': 'https://example.com/photo.jpg',
          },
        },
        'joinedAt': '2024-01-01T00:00:00.000Z',
      };

      final participant = ChatParticipant.fromJson(json);

      expect(participant.userName, 'محمد أحمد');
      expect(participant.userAvatar, 'https://example.com/photo.jpg');
    });
  });

  group('ChatMessage', () {
    test('should parse from JSON correctly', () {
      final json = {
        'id': 'msg-1',
        'conversationId': 'conv-1',
        'senderId': 'user-1',
        'type': 'TEXT',
        'content': 'Hello World',
        'isFromMe': true,
        'isRead': false,
        'createdAt': '2024-01-01T12:00:00.000Z',
      };

      final message = ChatMessage.fromJson(json);

      expect(message.id, 'msg-1');
      expect(message.content, 'Hello World');
      expect(message.type, ChatMessageType.text);
      expect(message.isFromMe, true);
      expect(message.isRead, false);
    });

    test('should handle different message types', () {
      final imageJson = {'type': 'IMAGE', 'id': '1', 'conversationId': 'c1', 'senderId': 's1', 'content': '', 'createdAt': '2024-01-01T00:00:00Z'};
      final fileJson = {'type': 'FILE', 'id': '2', 'conversationId': 'c1', 'senderId': 's1', 'content': '', 'createdAt': '2024-01-01T00:00:00Z'};
      final productJson = {'type': 'PRODUCT_CARD', 'id': '3', 'conversationId': 'c1', 'senderId': 's1', 'content': '', 'createdAt': '2024-01-01T00:00:00Z'};

      expect(ChatMessage.fromJson(imageJson).type, ChatMessageType.image);
      expect(ChatMessage.fromJson(fileJson).type, ChatMessageType.file);
      expect(ChatMessage.fromJson(productJson).type, ChatMessageType.productCard);
    });

    test('should format time correctly', () {
      final now = DateTime.now();
      final message = ChatMessage(
        id: '1',
        conversationId: 'c1',
        senderId: 's1',
        type: ChatMessageType.text,
        content: 'Test',
        createdAt: now,
      );

      expect(message.formattedTime, 'الآن');
    });

    test('should handle quick actions', () {
      final json = {
        'id': 'msg-1',
        'conversationId': 'conv-1',
        'senderId': 'user-1',
        'type': 'TEXT',
        'content': 'Choose an option',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'quickActions': [
          {'id': 'qa-1', 'label': 'نعم', 'action': 'confirm'},
          {'id': 'qa-2', 'label': 'لا', 'action': 'cancel'},
        ],
      };

      final message = ChatMessage.fromJson(json);

      expect(message.quickActions, isNotNull);
      expect(message.quickActions!.length, 2);
      expect(message.quickActions![0].label, 'نعم');
    });

    test('copyWith should work correctly', () {
      final original = ChatMessage(
        id: '1',
        conversationId: 'c1',
        senderId: 's1',
        type: ChatMessageType.text,
        content: 'Original',
        isRead: false,
        createdAt: DateTime.now(),
      );

      final updated = original.copyWith(
        content: 'Updated',
        isRead: true,
      );

      expect(updated.id, original.id);
      expect(updated.content, 'Updated');
      expect(updated.isRead, true);
    });
  });

  group('ChatConversation', () {
    test('should parse from JSON correctly', () {
      final json = {
        'id': 'conv-1',
        'type': 'MARKETPLACE',
        'status': 'OPEN',
        'subject': 'Product Inquiry',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'unreadCount': 3,
        'messagesCount': 10,
      };

      final conversation = ChatConversation.fromJson(json);

      expect(conversation.id, 'conv-1');
      expect(conversation.type, ChatConversationType.marketplace);
      expect(conversation.status, ChatConversationStatus.open);
      expect(conversation.hasUnread, true);
    });

    test('should handle last message', () {
      final json = {
        'id': 'conv-1',
        'type': 'SUPPORT',
        'status': 'ACTIVE',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'lastMessage': {
          'id': 'msg-1',
          'conversationId': 'conv-1',
          'senderId': 'user-1',
          'type': 'TEXT',
          'content': 'Last message content',
          'createdAt': '2024-01-01T12:00:00.000Z',
        },
        'lastMessageAt': '2024-01-01T12:00:00.000Z',
      };

      final conversation = ChatConversation.fromJson(json);

      expect(conversation.lastMessage, isNotNull);
      expect(conversation.lastMessage!.content, 'Last message content');
    });

    test('getDisplayName should return correct name', () {
      final conversation = ChatConversation(
        id: 'c1',
        type: ChatConversationType.marketplace,
        status: ChatConversationStatus.open,
        subject: 'Test Subject',
        createdAt: DateTime.now(),
      );

      expect(conversation.getDisplayName(), 'Test Subject');

      final conversationWithParticipant = ChatConversation(
        id: 'c2',
        type: ChatConversationType.support,
        status: ChatConversationStatus.open,
        createdAt: DateTime.now(),
        otherParticipant: ChatParticipant(
          id: 'p1',
          conversationId: 'c2',
          userId: 'u1',
          role: 'MEMBER',
          userName: 'Support Agent',
          joinedAt: DateTime.now(),
        ),
      );

      expect(conversationWithParticipant.getDisplayName(), 'Support Agent');
    });

    test('isActive should return correct value', () {
      final openConv = ChatConversation(
        id: 'c1',
        type: ChatConversationType.support,
        status: ChatConversationStatus.open,
        createdAt: DateTime.now(),
      );

      final closedConv = ChatConversation(
        id: 'c2',
        type: ChatConversationType.support,
        status: ChatConversationStatus.closed,
        createdAt: DateTime.now(),
      );

      expect(openConv.isActive, true);
      expect(closedConv.isActive, false);
    });

    test('formattedLastMessageTime should work correctly', () {
      final now = DateTime.now();
      final conversation = ChatConversation(
        id: 'c1',
        type: ChatConversationType.marketplace,
        status: ChatConversationStatus.open,
        createdAt: now,
        lastMessageAt: now,
      );

      expect(conversation.formattedLastMessageTime, 'الآن');
    });
  });

  group('ConversationsResponse', () {
    test('should parse from API response', () {
      final json = {
        'data': [
          {
            'id': 'conv-1',
            'type': 'MARKETPLACE',
            'status': 'OPEN',
            'createdAt': '2024-01-01T00:00:00.000Z',
          },
          {
            'id': 'conv-2',
            'type': 'SUPPORT',
            'status': 'ACTIVE',
            'createdAt': '2024-01-02T00:00:00.000Z',
          },
        ],
        'total': 50,
        'page': 1,
        'limit': 20,
        'hasMore': true,
      };

      final response = ConversationsResponse.fromJson(json);

      expect(response.conversations.length, 2);
      expect(response.total, 50);
      expect(response.hasMore, true);
    });
  });

  group('QuickAction', () {
    test('should parse correctly', () {
      final json = {
        'id': 'qa-1',
        'label': 'تأكيد الطلب',
        'action': 'confirm_order',
        'icon': 'check',
        'data': {'orderId': 'order-123'},
      };

      final action = QuickAction.fromJson(json);

      expect(action.id, 'qa-1');
      expect(action.label, 'تأكيد الطلب');
      expect(action.action, 'confirm_order');
      expect(action.data?['orderId'], 'order-123');
    });
  });
}
