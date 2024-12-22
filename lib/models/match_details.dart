import 'package:netwealth_vjti/models/professional.dart';

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

class ScoredCandidate {
  final Professional professional;
  final MatchDetails matchDetails;

  ScoredCandidate({
    required this.professional,
    required this.matchDetails,
  });

  double get score => matchDetails.totalScore;
}