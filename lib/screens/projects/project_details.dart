import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/screens/feedback_screen.dart';
import 'package:netwealth_vjti/screens/job_application_screen.dart';
import 'package:netwealth_vjti/screens/projects/kanban_boards.dart';

import 'join_projects_screen.dart';
import 'view_requests_screen.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;
  final String userId; // Added userId parameter

  ProjectDetailsScreen({required this.projectId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(224, 226, 248, 1),
        title: Text('Project Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(224, 226, 248, 1),
              Color.fromRGBO(200, 202, 240, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('projects')
              .doc(projectId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Project not found.'));
            } else {
              final project = snapshot.data!;
              final data = project.data() as Map<String, dynamic>;

              // Determine ownership
              final isOwner = userId == (data['creatorId'] ?? '');

              final startDate = (data['startDate'] as Timestamp?)?.toDate();
              final endDate = (data['endDate'] as Timestamp?)?.toDate();
              final isOpenForFeedback =
                  data['isOpenForFeedback'] as bool? ?? false;
              final isJobApplicationOpen =
                  data['isJobApplicationOpen'] as bool? ?? false;

              // Use detailedDescription if available
              final description = (data['detailedDescription'] != null &&
                      data['detailedDescription']!.toString().isNotEmpty)
                  ? data['detailedDescription']
                  : data['description'];

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isOwner)
                        Text(
                          'You are the owner of this project',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      SizedBox(height: 16),
                      if (isOwner)
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KanbanBoardScreen())),
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(201, 203, 241, 1),
                                  Color.fromRGBO(169, 183, 240, 0.94)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "View Kanban Boards",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.blueAccent),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 16),
                      _buildDetailCard('Title', data['title'] ?? 'N/A'),
                      _buildDetailCard(
                        'Description',
                        description ?? 'N/A',
                        isLongText: true,
                      ),
                      _buildDetailCard(
                        'Start Date',
                        startDate != null
                            ? startDate.toLocal().toString()
                            : 'N/A',
                      ),
                      _buildDetailCard(
                        'End Date',
                        endDate != null ? endDate.toLocal().toString() : 'N/A',
                      ),
                      _buildDetailCard(
                          'Creator ID', data['creatorId'] ?? 'N/A'),
                      _buildDetailCard(
                          'Jurisdiction', data['jurisdiction'] ?? 'N/A'),
                      _buildDetailCard('Years of Experience Required',
                          data['yearsExperienceRequired']?.toString() ?? 'N/A'),
                      _buildDetailCard('Skills Required',
                          _getListAsString(data['skillsRequired'])),
                      _buildDetailCard(
                          'Milestones', _getListAsString(data['milestones'])),
                      _buildDetailCard('Technical Skills',
                          _getListAsString(data['technicalSkills'])),
                      _buildDetailCard('Regulatory Expertise',
                          _getListAsString(data['regulatoryExpertise'])),
                      _buildDetailCard('Financial Standards',
                          _getListAsString(data['financialStandards'])),
                      _buildDetailCard('Industry Focus',
                          _getListAsString(data['industryFocus'])),
                      _buildDetailCard(
                          'User Roles', data['userRoles']?.toString() ?? 'N/A'),
                      _buildDetailCard('Join Requests',
                          _getListAsString(data['joinRequests'])),
                      SizedBox(height: 30),
                      if (isOwner)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewRequestsScreen(projectId: projectId),
                                ),
                              );
                            },
                            child: Text('View Requests'),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JoinRequestScreen(
                                    projectId: projectId,
                                    userId: userId,
                                  ),
                                ),
                              );
                            },
                            child: Text('Join Project'),
                          ),
                        ),
                      if (isOpenForFeedback && !isOwner)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FeedbackScreen(projectId: projectId),
                                ),
                              );
                            },
                            child: Text('Suggest Feedback'),
                          ),
                        ),
                      if (isJobApplicationOpen && !isOwner)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobApplicationScreen(
                                      projectId: projectId),
                                ),
                              );
                            },
                            child: Text('Apply for Job'),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Card widget for each project detail
  Widget _buildDetailCard(String label, String value,
      {bool isLongText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Container(
        width: double.infinity,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 8),
                isLongText
                    ? SingleChildScrollView(
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : Text(
                        value,
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to convert lists to a string
  String _getListAsString(dynamic value) {
    if (value is List) {
      return value.join(', ');
    } else {
      return 'N/A';
    }
  }
}
