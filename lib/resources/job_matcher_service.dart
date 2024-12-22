import 'package:netwealth_vjti/models/jobapplication.dart';
import 'package:netwealth_vjti/models/professional.dart';
import 'package:netwealth_vjti/models/scored_job.dart';

class JobMatcherService {
  Future<List<ScoredJobApplication>> findJobMatches(
    Professional profile,
    List<JobApplication> jobs
  ) async {
    List<ScoredJobApplication> scoredJobs = [];
    for (var job in jobs) {
      final matchDetails = await _calculateJobMatchDetails(profile, job);
      scoredJobs.add(ScoredJobApplication(
        jobApplication: job,
        matchDetails: matchDetails,
      ));
    }
    return scoredJobs;
  }

  Future<MatchDetails> _calculateJobMatchDetails(
    Professional profile,
    JobApplication job
  ) async {
    double skillScore = _calculateJobSkillScore(profile, job);
    double experienceScore = _calculateJobExperienceScore(profile, job);
    double jurisdictionScore = _calculateJobJurisdictionScore(profile, job);
    double industryScore = _calculateJobIndustryScore(profile, job);

    return MatchDetails(
      skillScore: skillScore,
      experienceScore: experienceScore,
      jurisdictionScore: jurisdictionScore,
      industryScore: industryScore,
    );
  }

  double _calculateJobSkillScore(Professional profile, JobApplication job) {
    double technicalScore = _calculateSetSimilarity(
      profile.technicalSkills.toSet(),
      job.requiredTechnicalSkills.toSet()
    );
    double regulatoryScore = _calculateSetSimilarity(
      profile.regulatoryExpertise.toSet(),
      job.requiredRegulatoryExpertise.toSet()
    );
    double standardsScore = _calculateSetSimilarity(
      profile.financialStandards.toSet(),
      job.requiredFinancialStandards.toSet()
    );

    return (technicalScore * 0.4 + regulatoryScore * 0.3 + standardsScore * 0.3);
  }

  double _calculateSetSimilarity(Set<String> set1, Set<String> set2) {
    if (set1.isEmpty || set2.isEmpty) return 0.0;
    return set1.intersection(set2).length / set2.length;
  }

  double _calculateJobExperienceScore(Professional profile, JobApplication job) {
    if (profile.yearsExperience >= job.yearsExperienceRequired) {
      return 1.0;
    }
    return profile.yearsExperience / job.yearsExperienceRequired;
  }

  double _calculateJobJurisdictionScore(Professional profile, JobApplication job) {
    const matrix = {
      'EU': {'EU': 1.0, 'UK': 0.8, 'US': 0.6, 'APAC': 0.5},
      'UK': {'EU': 0.8, 'UK': 1.0, 'US': 0.7, 'APAC': 0.5},
      'US': {'EU': 0.6, 'UK': 0.7, 'US': 1.0, 'APAC': 0.6},
      'APAC': {'EU': 0.5, 'UK': 0.5, 'US': 0.6, 'APAC': 1.0},
    };
    return matrix[profile.jurisdiction]?[job.jurisdiction] ?? 0.3;
  }

  double _calculateJobIndustryScore(Professional profile, JobApplication job) {
    return _calculateSetSimilarity(
      profile.industryFocus.toSet(),
      job.industryFocus.toSet()
    );
  }
}