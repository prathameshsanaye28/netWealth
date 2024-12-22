import 'dart:typed_data';
import 'package:netwealth_vjti/resources/storage_methods.dart';
import 'package:netwealth_vjti/screens/chat_screen.dart/message.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send message
  Future<String> sendMessage({
    required String receiverId,
    required String message,
    Uint8List? imageFile,
  }) async {
    try {
      String messageId = const Uuid().v1();
      String? currentUserId = _auth.currentUser?.uid;
      String? imageUrl;

      if (imageFile != null) {
        imageUrl = await StorageMethods().uploadImageToStorage(
          'chat_images',
          imageFile,
          true,
        );
      }

      Message messageObj = Message(
        senderId: currentUserId!,
        receiverId: receiverId,
        message: message,
        messageId: messageId,
        timestamp: DateTime.now(),
        imageUrl: imageUrl,
      );

      // Create chat room ID by sorting user IDs
      List<String> ids = [currentUserId, receiverId];
      ids.sort();
      String chatRoomId = ids.join('_');

      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .set(messageObj.toJson());

      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  // Get messages stream
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Search users
  Future<QuerySnapshot> searchUsers(String searchTerm) async {
    return await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: searchTerm)
        .where('username', isLessThan: searchTerm + 'z')
        .get();
  }
}