import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  FirebaseHelper._();

  static final FirebaseHelper instance = FirebaseHelper._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create or get chat document
  Future<String> getOrCreateChat({
    required String jobId,
    required String customerId,
    required String customerName,
    required String providerId,
    required String providerName,
  }) async {
    final chatDoc = _firestore.collection('chats').doc(jobId);
    final snapshot = await chatDoc.get();

    if (!snapshot.exists) {
      await chatDoc.set({
        'participants': [customerId, providerId], // ✅ ARRAY for easy query
        'participantDetails': {
          customerId: customerName,
          providerId: providerName,
        },
        'createdAt': Timestamp.now(),
        'lastMessage': "",
        'lastMessageTime': null,
        'lastMessageSenderId': null,
        'lastMessageRead': true,
      });
    } else {
      // 🔥 ensure participants & details exist (safety net)
      await chatDoc.set({
        'participants': [customerId, providerId],
        'participantDetails': {
          customerId: customerName,
          providerId: providerName,
        },
      }, SetOptions(merge: true));
    }

    return chatDoc.id;
  }

  /// Send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    final chatRef = _firestore.collection('chats').doc(chatId);
    final snapshot = await chatRef.get();

    if (!snapshot.exists) {
      throw Exception("⚠️ Chat does not exist. Call getOrCreateChat first.");
    }

    final messagesRef = chatRef.collection('messages');

    final newMessage = {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': Timestamp.now(),
      'read': false,
    };

    await messagesRef.add(newMessage);

    // ✅ Update chat document with last message info
    await chatRef.update({
      'lastMessage': text,
      'lastMessageTime': Timestamp.now(),
      'lastMessageSenderId': senderId,
      'lastMessageRead': false,
    });
  }

  /// Listen to messages stream
  Stream<List<Map<String, dynamic>>> listenMessages({required String chatId}) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => {...doc.data(), "id": doc.id})
                  .toList(),
        );
  }

  /// Mark a message as read
  Future<void> markMessageAsRead({
    required String chatId,
    required String messageId,
  }) async {
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    await messageRef.update({'read': true});

    // ✅ update lastMessageRead if this was the last one
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessageRead': true,
    });
  }

  /// Get all chats for a user
  Stream<List<Map<String, dynamic>>> getChatsForUser({required String userId}) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId) // ✅ easy query
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => {...doc.data(), "id": doc.id})
                  .toList(),
        );
  }
}
