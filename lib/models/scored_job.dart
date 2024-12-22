import 'package:netwealth_vjti/models/jobapplication.dart';

class MatchDetails {
  final double skillScore;
  final double experienceScore;
  final double jurisdictionScore;
  final double industryScore;

  MatchDetails({
    required this.skillScore,
    required this.experienceScore,
    required this.jurisdictionScore,
    required this.industryScore,
  });

  double get totalScore =>
      (skillScore * 0.4) +
      (experienceScore * 0.2) +
      (jurisdictionScore * 0.2) +
      (industryScore * 0.2);
}

class ScoredJobApplication {
  final JobApplication jobApplication;
  final MatchDetails matchDetails;

  ScoredJobApplication({
    required this.jobApplication,
    required this.matchDetails,
  });

  double get score => matchDetails.totalScore;
}