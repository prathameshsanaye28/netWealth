import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netwealth_vjti/screens/course_screen/course.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Course>> getAllCourses() {
    return _firestore
        .collection('courses')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Course.fromSnapshot(doc)).toList());
  }

  Stream<List<Course>> getEnrolledCourses(String userId) {
    return _firestore
        .collection('courses')
        .where('enrolledUsers', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Course.fromSnapshot(doc)).toList());
  }

  // Check if user is enrolled
  Stream<bool> isUserEnrolled(String userId, String courseId) {
    return _firestore
        .collection('courses')
        .doc(courseId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return false;
          List<String> enrolledUsers = List<String>.from(
              snapshot.get('enrolledUsers') ?? []);
          return enrolledUsers.contains(userId);
        });
  }

  // Check if user has completed the course
  Stream<bool> isUserCompleted(String userId, String courseId) {
    return _firestore
        .collection('courses')
        .doc(courseId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return false;
          List<String> completedUsers = List<String>.from(
              snapshot.get('completedUsers') ?? []);
          return completedUsers.contains(userId);
        });
  }

  Future<void> enrollInCourse(String userId, String courseId) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference courseRef = _firestore.collection('courses').doc(courseId);
      DocumentSnapshot courseSnapshot = await transaction.get(courseRef);
      if (courseSnapshot.exists) {
        List<String> enrolledUsers = List<String>.from(
            courseSnapshot.get('enrolledUsers') ?? []);
        if (!enrolledUsers.contains(userId)) {
          enrolledUsers.add(userId);
          transaction.update(courseRef, {'enrolledUsers': enrolledUsers});
        }
      } else {
        throw Exception('Course not found.');
      }
    });
  }

  Future<void> markCourseAsCompleted(String userId, String courseId) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference courseRef = _firestore.collection('courses').doc(courseId);
      DocumentSnapshot courseSnapshot = await transaction.get(courseRef);
      
      if (courseSnapshot.exists) {
        List<String> completedUsers = List<String>.from(
            courseSnapshot.get('completedUsers') ?? []);
        if (!completedUsers.contains(userId)) {
          completedUsers.add(userId);
          transaction.update(courseRef, {'completedUsers': completedUsers});
        }
      } else {
        throw Exception('Course not found.');
      }
    });
  }
}