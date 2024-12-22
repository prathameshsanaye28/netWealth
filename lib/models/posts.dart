

// import 'package:cloud_firestore/cloud_firestore.dart';

// class Posts{
//   final String description;
//   final String uid;
//   final String username;
//   final String postId;
//   final String postUrl;
//   final String profImage;
//   final datePublished;
//   final likes;

//   const Posts({
//     required this.datePublished,
//     required this.description,
//     required this.likes,
//     required this.postId,
//     required this.postUrl,
//     required this.username,
//     required this.uid,
//     required this.profImage,
//   });

//   Map<String, dynamic> toJson()=>{
//       'username': username,
//       'uid': uid,
//       'datePublished': datePublished,
//       'likes':likes,
//       'postId':postId,
//       'profImage':profImage,
//       'description': description,
//       'postUrl':postUrl,
//   };

//   static Posts fromSnap(DocumentSnapshot snap){
//     var snapshot = snap.data() as Map<String,dynamic>;

//     return Posts(
//       datePublished: snapshot['datePublished'],
//       likes: snapshot['likes'],
//       postId: snapshot['postId'],
//       profImage: snapshot['profImage'],
//       description: snapshot['description'],
//       postUrl:snapshot['postUrl'],
//       uid: snapshot['uid'],
//       username: snapshot['username'],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final String? postUrl; // Made optional with ?
  final String profImage;
  final datePublished;
  final likes;

  const Posts({
    required this.datePublished,
    required this.description,
    required this.likes,
    required this.postId,
    this.postUrl, // Made optional by removing required
    required this.username,
    required this.uid,
    required this.profImage,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'datePublished': datePublished,
        'likes': likes,
        'postId': postId,
        'profImage': profImage,
        'description': description,
        'postUrl': postUrl, // Can be null
      };

  static Posts fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Posts(
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      postId: snapshot['postId'],
      profImage: snapshot['profImage'],
      description: snapshot['description'],
      postUrl: snapshot['postUrl'], // Can be null
      uid: snapshot['uid'],
      username: snapshot['username'],
    );
  }
}