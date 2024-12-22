import 'package:cloud_firestore/cloud_firestore.dart';

class Badge {
  final String userId;
  final String courseId;
  final String badgeId; // This will now hold the Firestore doc ID
  final Timestamp awardedAt; // Using Firestore's Timestamp

  Badge({
    required this.userId,
    required this.courseId,
    required this.badgeId,
    required this.awardedAt,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'courseId': courseId,
        'awardedAt': awardedAt, // Timestamp is directly supported by Firestore
      };

  static Badge fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;

    return Badge(
      userId: data['userId'],
      courseId: data['courseId'],
      badgeId: snap.id, // Use document ID as the badgeId
      awardedAt: data['awardedAt'],
    );
  }
}