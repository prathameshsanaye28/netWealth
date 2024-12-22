// // lib/services/matcher_service.dart
// import 'dart:math';
// import 'package:collection/collection.dart';
// import '../../models/professional.dart';
// import '../../models/match_details.dart';

// class MatcherService {
//   Future<List<ScoredCandidate>> findMatches(
//     Professional profile, 
//     List<Professional> candidates
//   ) async {
//     List<ScoredCandidate> scoredCandidates = [];
    
//     for (var candidate in candidates) {
//       final matchDetails = await _calculateMatchDetails(profile, candidate);
//       scoredCandidates.add(ScoredCandidate(
//         professional: candidate,
//         matchDetails: matchDetails,
//       ));
//     }
    
//     scoredCandidates.sort((a, b) => b.score.compareTo(a.score));
//     return scoredCandidates;
//   }

//   Future<MatchDetails> _calculateMatchDetails(
//     Professional profile1, 
//     Professional profile2
//   ) async {
//     return MatchDetails(
//       skillScore: _calculateSkillScore(profile1, profile2),
//       experienceScore: _calculateExperienceScore(profile1, profile2),
//       jurisdictionScore: _calculateJurisdictionScore(profile1, profile2),
//       industryScore: _calculateIndustryScore(profile1, profile2),
//     );
//   }

//   double _calculateSkillScore(Professional p1, Professional p2) {
//     double technicalScore = _calculateSetSimilarity(
//       p1.technicalSkills.toSet(), 
//       p2.technicalSkills.toSet()
//     );
    
//     double regulatoryScore = _calculateSetSimilarity(
//       p1.regulatoryExpertise.toSet(), 
//       p2.regulatoryExpertise.toSet()
//     );
    
//     double standardsScore = _calculateSetSimilarity(
//       p1.financialStandards.toSet(), 
//       p2.financialStandards.toSet()
//     );
    
//     return (technicalScore * 0.4 + regulatoryScore * 0.3 + standardsScore * 0.3);
//   }

//   double _calculateSetSimilarity(Set<String> set1, Set<String> set2) {
//     if (set1.isEmpty || set2.isEmpty) return 0.0;
//     return set1.intersection(set2).length / set1.union(set2).length;
//   }

//   double _calculateExperienceScore(Professional p1, Professional p2) {
//     int diff = (p1.yearsExperience - p2.yearsExperience).abs();
//     return 1.0 / (1.0 + (diff / 5));
//   }

//   double _calculateJurisdictionScore(Professional p1, Professional p2) {
//     const matrix = {
//       'EU': {'EU': 1.0, 'UK': 0.8, 'US': 0.6, 'APAC': 0.5},
//       'UK': {'EU': 0.8, 'UK': 1.0, 'US': 0.7, 'APAC': 0.5},
//       'US': {'EU': 0.6, 'UK': 0.7, 'US': 1.0, 'APAC': 0.6},
//       'APAC': {'EU': 0.5, 'UK': 0.5, 'US': 0.6, 'APAC': 1.0},
//     };
//     return matrix[p1.jurisdiction]?[p2.jurisdiction] ?? 0.3;
//   }

//   double _calculateIndustryScore(Professional p1, Professional p2) {
//     return _calculateSetSimilarity(
//       p1.industryFocus.toSet(), 
//       p2.industryFocus.toSet()
//     );
//   }
// }


import 'dart:math';
import 'package:collection/collection.dart';
import '../../models/professional.dart';
import '../../models/match_details.dart';

class MatcherService {
  Future<List<ScoredCandidate>> findMatches(
    Professional profile, 
    List<Professional> candidates
  ) async {
    List<ScoredCandidate> scoredCandidates = [];
    
    for (var candidate in candidates) {
      if (candidate.id != profile.id) {  // Additional check to ensure no self-matching
        final matchDetails = await _calculateMatchDetails(profile, candidate);
        scoredCandidates.add(ScoredCandidate(
          professional: candidate,
          matchDetails: matchDetails,
        ));
      }
    }
    
    return scoredCandidates;
  }

  Future<MatchDetails> _calculateMatchDetails(
    Professional profile1, 
    Professional profile2
  ) async {
    // Calculate basic scores
    double skillScore = _calculateSkillScore(profile1, profile2);
    double experienceScore = _calculateExperienceScore(profile1, profile2);
    double jurisdictionScore = _calculateJurisdictionScore(profile1, profile2);
    double industryScore = _calculateIndustryScore(profile1, profile2);
    
    return MatchDetails(
      skillScore: skillScore,
      experienceScore: experienceScore,
      jurisdictionScore: jurisdictionScore,
      industryScore: industryScore,
    );
  }

  double _calculateSkillScore(Professional p1, Professional p2) {
    // Weighted average of different skill types
    double technicalScore = _calculateSetSimilarity(
      p1.technicalSkills.toSet(), 
      p2.technicalSkills.toSet()
    );
    
    double regulatoryScore = _calculateSetSimilarity(
      p1.regulatoryExpertise.toSet(), 
      p2.regulatoryExpertise.toSet()
    );
    
    double standardsScore = _calculateSetSimilarity(
      p1.financialStandards.toSet(), 
      p2.financialStandards.toSet()
    );
    
    // Adjust weights based on importance
    return (technicalScore * 0.4 + regulatoryScore * 0.3 + standardsScore * 0.3);
  }

  double _calculateSetSimilarity(Set<String> set1, Set<String> set2) {
    if (set1.isEmpty || set2.isEmpty) return 0.0;
    
    // Use Jaccard similarity coefficient
    double intersection = set1.intersection(set2).length.toDouble();
    double union = set1.union(set2).length.toDouble();
    
    return intersection / union;
  }

  double _calculateExperienceScore(Professional p1, Professional p2) {
    // Calculate experience similarity using a decay function
    int diff = (p1.yearsExperience - p2.yearsExperience).abs();
    return 1.0 / (1.0 + (diff / 5)); // Normalized difference
  }

  double _calculateJurisdictionScore(Professional p1, Professional p2) {
    // Enhanced jurisdiction matching matrix
    const matrix = {
      'EU': {'EU': 1.0, 'UK': 0.8, 'US': 0.6, 'APAC': 0.5},
      'UK': {'EU': 0.8, 'UK': 1.0, 'US': 0.7, 'APAC': 0.5},
      'US': {'EU': 0.6, 'UK': 0.7, 'US': 1.0, 'APAC': 0.6},
      'APAC': {'EU': 0.5, 'UK': 0.5, 'US': 0.6, 'APAC': 1.0},
    };
    
    return matrix[p1.jurisdiction]?[p2.jurisdiction] ?? 0.3;
  }

  double _calculateIndustryScore(Professional p1, Professional p2) {
    // Calculate industry focus similarity
    return _calculateSetSimilarity(
      p1.industryFocus.toSet(), 
      p2.industryFocus.toSet()
    );
  }
}