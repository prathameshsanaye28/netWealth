import 'package:flutter/material.dart';
import 'package:netwealth_vjti/models/jobapplication.dart';
import 'package:netwealth_vjti/models/professional.dart';
import 'package:netwealth_vjti/models/scored_job.dart';
import 'package:netwealth_vjti/resources/job_matching_provider.dart';
import 'package:netwealth_vjti/resources/user_provider.dart';
import 'package:netwealth_vjti/screens/risk_analysis.dart';
import 'package:netwealth_vjti/screens/simplification.dart';
import 'package:provider/provider.dart';

class JobMatchingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Professional? user = Provider.of<UserProvider>(context).getUser;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Job Matches'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Available Jobs'),
              Tab(text: 'Applied Jobs'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () => _showFilters(context),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _AvailableJobsTab(),
            _AppliedJobsTab(),
          ],
        ),
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => JobFilterSheet(),
    );
  }
}

class _AvailableJobsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<JobMatchingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.jobMatches.isEmpty) {
          return _EmptyJobsView();
        }

        return RefreshIndicator(
          onRefresh: provider.findJobMatches,
          child: JobMatchList(matches: provider.jobMatches),
        );
      },
    );
  }
}

// class _AppliedJobsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Applied jobs will appear here'),
//     );
//   }
// }

class _AppliedJobsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<JobMatchingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.appliedJobs.isEmpty) {
          return _EmptyAppliedJobsView();
        }

        return ListView.builder(
          itemCount: provider.appliedJobs.length,
          itemBuilder: (context, index) {
            return AppliedJobCard(job: provider.appliedJobs[index]);
          },
        );
      },
    );
  }
}

class _EmptyAppliedJobsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_history_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No applications yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            'Your applied jobs will appear here',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class AppliedJobCard extends StatelessWidget {
  final JobApplication job;

  const AppliedJobCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _showJobDetails(context),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 4),
              Text(
                job.company,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${job.jurisdiction} • ${job.yearsExperienceRequired}y exp required',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 8),
              _buildSkillsPreview(context),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: Text('Application Pending'),
                    backgroundColor: Colors.orange[100],
                    labelStyle: TextStyle(color: Colors.orange[900]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsPreview(BuildContext context) {
    final skills = job.requiredTechnicalSkills.take(3).join(', ');
    return Text(
      'Skills: $skills${job.requiredTechnicalSkills.length > 3 ? '...' : ''}',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  void _showJobDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => JobDetails(
        job: ScoredJobApplication(
          jobApplication: job,
          matchDetails: MatchDetails(
            skillScore: 0,
            experienceScore: 0,
            jurisdictionScore: 0,
            industryScore: 0,
          ),
        ),
      ),
    );
  }
}



class JobFilterSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Jobs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          _buildFilterSection(
            'Years of Experience',
            Slider(
              value: 5,
              min: 0,
              max: 20,
              divisions: 20,
              label: '5 years',
              onChanged: (value) {
                // Implement filter logic
              },
            ),
          ),
          _buildFilterSection(
            'Jurisdiction',
            DropdownButton<String>(
              isExpanded: true,
              value: 'All',
              items: ['All', 'EU', 'UK', 'US', 'APAC']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                // Implement filter logic
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Reset'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 8),
        child,
        SizedBox(height: 16),
      ],
    );
  }
}

class _EmptyJobsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_off_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No matching jobs found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters or updating your profile',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class JobMatchList extends StatelessWidget {
  final List<ScoredJobApplication> matches;

  const JobMatchList({Key? key, required this.matches}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return JobMatchCard(scoredJob: matches[index]);
      },
    );
  }
}

class JobMatchCard extends StatelessWidget {
  final ScoredJobApplication scoredJob;

  const JobMatchCard({Key? key, required this.scoredJob}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final job = scoredJob.jobApplication;
    final score = (scoredJob.score * 100).round();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _showJobDetails(context),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 4),
                    Text(
                      job.company,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${job.jurisdiction} • ${job.yearsExperienceRequired}y exp required',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 8),
                    _buildSkillsPreview(context),
                    SizedBox(height: 8),
                    _buildMatchDetails(context),
                  ],
                ),
              ),
              SizedBox(width: 16),
              _buildMatchScore(context, score),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsPreview(BuildContext context) {
    final skills = scoredJob.jobApplication.requiredTechnicalSkills.take(3).join(', ');
    return Text(
      'Skills: $skills${scoredJob.jobApplication.requiredTechnicalSkills.length > 3 ? '...' : ''}',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildMatchDetails(BuildContext context) {
    return Row(
      children: [
        _buildMatchMetric('Skills', scoredJob.matchDetails.skillScore),
        SizedBox(width: 16),
        _buildMatchMetric('Experience', scoredJob.matchDetails.experienceScore),
        SizedBox(width: 16),
        _buildMatchMetric('Industry', scoredJob.matchDetails.industryScore),
      ],
    );
  }

  Widget _buildMatchMetric(String label, double score) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          LinearProgressIndicator(
            value: score,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor((score * 100).round())),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchScore(BuildContext context, int score) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getScoreColor(score),
      ),
      child: Center(
        child: Text(
          '$score%',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  void _showJobDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => JobDetails(job: scoredJob),
    );
  }
}

class JobDetails extends StatelessWidget {
  final ScoredJobApplication job;

  const JobDetails({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        color: Colors.white,
        child: ListView(
          controller: controller,
          padding: EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.jobApplication.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        job.jobApplication.company,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_border),
                  onPressed: () {
                    // Implement save functionality
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildMatchScore(context),
            SizedBox(height: 16),
            _buildDetailSection('Description', job.jobApplication.description),
            _buildDetailSection('Required Technical Skills',
                job.jobApplication.requiredTechnicalSkills.join(', ')),
            _buildDetailSection('Required Regulatory Expertise',
                job.jobApplication.requiredRegulatoryExpertise.join(', ')),
            _buildDetailSection('Required Financial Standards',
                job.jobApplication.requiredFinancialStandards.join(', ')),
            _buildDetailSection('Industry Focus',
                job.jobApplication.industryFocus.join(', ')),
            SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     // Implement apply functionality
            //     Navigator.pop(context);
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text('Application submitted successfully')),
            //     );
            //   },
            //   child: Text('Apply Now'),
            // ),
            ElevatedButton(onPressed: (){
              final allDetails = [
  job.jobApplication.description,
  job.jobApplication.requiredTechnicalSkills.join(', '),
  job.jobApplication.requiredRegulatoryExpertise.join(', '),
  job.jobApplication.requiredFinancialStandards.join(', '),
  job.jobApplication.industryFocus.join(', ')
].join('\n');
              Navigator.push(context, MaterialPageRoute(builder: (context)=>JobDescriptionSimplify(originalString:allDetails )));
            }, child: Text("Job Description")),
            ElevatedButton(onPressed: (){
              final allDetails = [
  job.jobApplication.description,
  job.jobApplication.requiredTechnicalSkills.join(', '),
  job.jobApplication.requiredRegulatoryExpertise.join(', '),
  job.jobApplication.requiredFinancialStandards.join(', '),
  job.jobApplication.industryFocus.join(', ')
].join('\n');
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RiskAnalysis(originalString:allDetails )));
            }, child: Text("Risk Analysis")),
            ElevatedButton(
  onPressed: () async {
    try {
      await Provider.of<JobMatchingProvider>(context, listen: false)
          .applyToJob(job.jobApplication);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit application. Please try again.')),
      );
    }
  },
  child: Text('Apply Now'),
),

          ],
        ),
      ),
    );
  }

  Widget _buildMatchScore(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Match Score',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildScoreMetric('Skills', job.matchDetails.skillScore),
                _buildScoreMetric('Experience', job.matchDetails.experienceScore),
                _buildScoreMetric('Industry', job.matchDetails.industryScore),
              ],
            ),
          ],
        ),
      ),
    );
  }

   Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildScoreMetric(String label, double score) {
    return Expanded(
      child: Column(
        children: [
          Text('$label'),
          SizedBox(height: 8),
          Text(
            '${(score * 100).round()}%',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _getScoreColor((score * 100).round()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}