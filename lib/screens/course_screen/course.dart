import 'package:cloud_firestore/cloud_firestore.dart';

class Module {
  final String title;
  final String description;
  final String videoUrl;
  final int duration; // in minutes
  bool isCompleted;

  Module({
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.duration,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'videoUrl': videoUrl,
    'duration': duration,
    'isCompleted': isCompleted,
  };

  static Module fromJson(Map<String, dynamic> json) => Module(
    title: json['title'],
    description: json['description'],
    videoUrl: json['videoUrl'],
    duration: json['duration'],
    isCompleted: json['isCompleted'] ?? false,
  );
}

class Course {
  final String id;
  final String title;
  final String description;
  final String category;
  final String thumbnail;
  final List<Module> modules;
  final int totalDuration; // in minutes
  final List<String> enrolledUsers;
  final List<String> completedUsers;
  final double rating;
  final int numberOfRatings;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.modules,
    required this.totalDuration,
    this.enrolledUsers = const [],
    this.completedUsers = const [],
    this.rating = 0.0,
    this.numberOfRatings = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'thumbnail': thumbnail,
    'modules': modules.map((module) => module.toJson()).toList(),
    'totalDuration': totalDuration,
    'enrolledUsers': enrolledUsers,
    'completedUsers': completedUsers,
    'rating': rating,
    'numberOfRatings': numberOfRatings,
  };

  static Course fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    return Course(
      id: snap.id,
      title: data['title'],
      description: data['description'],
      category: data['category'],
      thumbnail: data['thumbnail'],
      modules: (data['modules'] as List)
          .map((m) => Module.fromJson(m as Map<String, dynamic>))
          .toList(),
      totalDuration: data['totalDuration'],
      enrolledUsers: List<String>.from(data['enrolledUsers'] ?? []),
      completedUsers: List<String>.from(data['completedUsers'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      numberOfRatings: data['numberOfRatings'] ?? 0,
    );
  }
}