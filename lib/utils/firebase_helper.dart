// lib/helpers/firebase_helper.dart
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
    required String providerId,
  }) async {
    final chatDoc = _firestore.collection('chats').doc(jobId);
    final snapshot = await chatDoc.get();

    if (!snapshot.exists) {
      await chatDoc.set({
        'participants': [customerId, providerId],
        'createdAt': Timestamp.now(),
      });
    }

    return chatDoc.id;
  }

  /// Send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final messagesRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    await messagesRef.add({
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.now(),
      'read': false,
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
                  .map((doc) => doc.data() as Map<String, dynamic>)
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
  }

  Stream<List<Map<String, dynamic>>> getChatsForUser({required String userId}) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList(),
        );
  }
}
