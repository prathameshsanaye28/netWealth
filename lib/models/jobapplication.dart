// class JobApplication {
//   final String jobId; // Unique identifier for the job
//   final bool isQuestionnaire; // True for questionnaire, false for mini task
//   final List<Question>?
//       questionnaire; // List of questions if it's a questionnaire
//   final MiniTask? miniTask; // Details of the mini task
//   final Map<String, int>? userScores; // Map of user IDs to their scores
//   final Map<String, String>?
//       taskSubmissions; // Map of user IDs to their submission URLs
//   final DateTime deadline; // Deadline for the job application

//   JobApplication({
//     required this.jobId,
//     required this.isQuestionnaire,
//     this.questionnaire,
//     this.miniTask,
//     this.userScores,
//     this.taskSubmissions,
//     required this.deadline,
//   });

//   Map<String, dynamic> toJson() => {
//         'jobId': jobId,
//         'isQuestionnaire': isQuestionnaire,
//         'questionnaire': questionnaire?.map((q) => q.toJson()).toList(),
//         'miniTask': miniTask?.toJson(),
//         'userScores': userScores,
//         'taskSubmissions': taskSubmissions,
//         'deadline': deadline.toIso8601String(),
//       };
// }

// class Question {
//   final String questionText;
//   final List<String> options;
//   final int correctOptionIndex;
//   final int score;

//   Question({
//     required this.questionText,
//     required this.options,
//     required this.correctOptionIndex,
//     required this.score,
//   });

//   Map<String, dynamic> toJson() => {
//         'questionText': questionText,
//         'options': options,
//         'correctOptionIndex': correctOptionIndex,
//         'score': score,
//       };
// }

// class MiniTask {
//   final String description;
//   final String submissionFormat;

//   MiniTask({
//     required this.description,
//     required this.submissionFormat,
//   });

//   Map<String, dynamic> toJson() => {
//         'description': description,
//         'submissionFormat': submissionFormat,
//       };
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplication {
  final String? id;
  final String title;
  final String company;
  final String jurisdiction;
  final int yearsExperienceRequired;
  final List<String> requiredTechnicalSkills;
  final List<String> requiredRegulatoryExpertise;
  final List<String> requiredFinancialStandards;
  final List<String> industryFocus;
  final String description;
  final DateTime postedDate;

  JobApplication({
    this.id,
    required this.title,
    required this.company,
    required this.jurisdiction,
    required this.yearsExperienceRequired,
    required this.requiredTechnicalSkills,
    required this.requiredRegulatoryExpertise,
    required this.requiredFinancialStandards,
    required this.industryFocus,
    required this.description,
    required this.postedDate,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'company': company,
    'jurisdiction': jurisdiction,
    'yearsExperienceRequired': yearsExperienceRequired,
    'requiredTechnicalSkills': requiredTechnicalSkills,
    'requiredRegulatoryExpertise': requiredRegulatoryExpertise,
    'requiredFinancialStandards': requiredFinancialStandards,
    'industryFocus': industryFocus,
    'description': description,
    'postedDate': postedDate.toIso8601String(),
  };

  static JobApplication fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return JobApplication(
      id: snap.id,
      title: snapshot['title'] ?? '',
      company: snapshot['company'] ?? '',
      jurisdiction: snapshot['jurisdiction'] ?? '',
      yearsExperienceRequired: snapshot['yearsExperienceRequired'] ?? 0,
      requiredTechnicalSkills: List<String>.from(snapshot['requiredTechnicalSkills'] ?? []),
      requiredRegulatoryExpertise: List<String>.from(snapshot['requiredRegulatoryExpertise'] ?? []),
      requiredFinancialStandards: List<String>.from(snapshot['requiredFinancialStandards'] ?? []),
      industryFocus: List<String>.from(snapshot['industryFocus'] ?? []),
      description: snapshot['description'] ?? '',
      postedDate: DateTime.parse(snapshot['postedDate']),
    );
  }
}