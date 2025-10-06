import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  FirebaseHelper._();

  static final FirebaseHelper instance = FirebaseHelper._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getOrCreateChat({
    required String jobId,
    required String customerId,
    required String customerName,
    required String providerId,
    required String providerName,
  }) async {
    final chatDoc = _firestore.collection('chats').doc(jobId);
    final snapshot = await chatDoc.get();

    bool isNew = false;

    if (!snapshot.exists) {
      isNew = true;
      await chatDoc.set({
        'participants': [customerId, providerId],
        'participantDetails': {
          customerId: customerName,
          providerId: providerName,
        },

        'jobId': jobId,
        'status': true,
        'createdAt': Timestamp.now(),
        'lastMessage': "",
        'lastMessageTime': null,
        'lastMessageSenderId': null,
        'lastMessageRead': true,
      });
    } else {
      await chatDoc.set({
        'participants': [customerId, providerId],
        'participantDetails': {
          customerId: customerName,
          providerId: providerName,
        },
      }, SetOptions(merge: true));
    }

    return {'chatId': chatDoc.id, 'isNew': isNew};
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
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => {...doc.data(), "id": doc.id})
                  .toList(),
        );
  }

  /// Mark all messages as read when user opens chat
  Future<void> markAllMessagesAsRead({
    required String chatId,
    required String currentUserId,
  }) async {
    final chatRef = _firestore.collection('chats').doc(chatId);

    final unreadMessages =
        await chatRef
            .collection('messages')
            .where("senderId", isNotEqualTo: currentUserId)
            .where("read", isEqualTo: false)
            .get();

    final batch = _firestore.batch();

    for (var doc in unreadMessages.docs) {
      batch.update(doc.reference, {"read": true});
    }

    // ✅ agar lastMessage usi dusre user ka hai aur abhi unread hai → usko bhi mark read
    final chatSnapshot = await chatRef.get();
    if (chatSnapshot.exists) {
      final data = chatSnapshot.data()!;
      if (data["lastMessageSenderId"] != currentUserId &&
          data["lastMessageRead"] == false) {
        batch.update(chatRef, {"lastMessageRead": true});
      }
    }

    await batch.commit();
  }
}
