import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netwealth_vjti/models/jobs.dart';
import 'package:netwealth_vjti/models/posts.dart';
import 'package:netwealth_vjti/models/professional.dart';
import 'package:netwealth_vjti/resources/storage_methods.dart';
import 'package:netwealth_vjti/screens/api_marketplace.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  // Future<String> uploadPost(
  //   String description,
  //   Uint8List file,
  //   String uid,
  //   String username,
  //   String profImage,
  // ) async{
  //   String res ="Some error occurred";
  //   try{
  //     String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
  //     String postId = const Uuid().v1();
  //     Posts post = Posts(
  //       description: description,
  //       uid: uid,
  //       username: username,
  //       postId: postId,
  //       datePublished: DateTime.now(),
  //       postUrl: photoUrl,
  //       profImage: profImage,
  //       likes:[]
  //     );
  //     _firestore.collection('posts').doc(postId).set(post.toJson());
  //     res = "Success";
  //   }catch(err){
  //     res = err.toString();
  //   }
  //   return res;
  // }

  Future<String> uploadPost(
    String description,
    String uid,
    String username,
    String profImage, {
    Uint8List? file, // Made optional
  }) async {
    String res = "Some error occurred";
    try {
      String postId = const Uuid().v1();
      String? photoUrl;
      
      // Only upload image if file is provided
      if (file != null) {
        photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      }

      Posts post = Posts(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl, // Can be null
        profImage: profImage,
        likes: [],
      );
      
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  // Future<List<Professional>> fetchProfessionals() async {
  //   final snapshot = await _firestore.collection('professionals').get();
  //   return snapshot.docs
  //       .map((doc) => Professional.fromMap(doc.data() as Map<String, dynamic>, doc.id))
  //       .toList();
  // }

  // Future<List<Job>> fetchJobs() async {
  //   final snapshot = await _firestore.collection('jobs').get();
  //   return snapshot.docs
  //       .map((doc) => Job.fromMap(doc.data() as Map<String, dynamic>, doc.id))
  //       .toList();
  // }

  Future<List<ApiProduct>> fetchApis() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('apis').get();
      return snapshot.docs.map((doc) {
        return ApiProduct(
          id: doc['id'],
          name: doc['name'],
          description: doc['description'],
          price: doc['price'],
          features: List<String>.from(doc['features']),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch APIs: $e');
    }
  }

  // Update the list of purchased users
  Future<void> purchaseApi(ApiProduct api, String userId) async {
  try {
    final apiRef = _firestore.collection('apis').doc(api.id);

    // Update the purchasedByUserId field with the new user's ID
    await apiRef.update({
      'purchasedByUserId': FieldValue.arrayUnion([userId]), // Add userId to purchasedByUserId list
    });
  } catch (e) {
    throw Exception('Failed to update purchase: $e');
  }
}
}


