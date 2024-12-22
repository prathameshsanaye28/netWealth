import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'create_projects_screen.dart';
import 'project_details.dart';

class ViewProjectsScreen extends StatelessWidget {
  // Fetch projects stream directly from Firestore
  Stream<List<Map<String, dynamic>>> getProjectsStream() {
    try {
      return FirebaseFirestore.instance
          .collection('projects')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {
                    'projectId': doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  })
              .toList());
    } catch (error) {
      print('Error fetching projects: $error');
      return Stream.value([]); // Return an empty stream on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(224, 226, 248, 1),
        title: Text('Projects'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to CreateProjectScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateProjectScreen(
                    creatorId: "user10",
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(224, 226, 248, 1),
              Color.fromRGBO(200, 202, 240, 1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: getProjectsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No projects available.'));
            } else {
              final projects = snapshot.data!;
              return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return ProjectCard(
                    title: project['title'] ?? 'No Title',
                    description: project['description'] ?? 'No Description',
                    startDate: (project['startDate'] as Timestamp?)
                        ?.toDate(), // Convert Firestore Timestamp
                    endDate: (project['endDate'] as Timestamp?)
                        ?.toDate(), // Convert Firestore Timestamp
                    technicalSkills: project['technicalSkills'] != null
                        ? List<String>.from(project['technicalSkills'])
                        : [],
                    onTap: () {
                      // Navigate to ProjectDetailsScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailsScreen(
                            projectId: project['projectId'],
                            userId: "user10",
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> technicalSkills;
  final VoidCallback onTap;

  ProjectCard({
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    required this.technicalSkills,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color.fromRGBO(250, 250, 250, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: technicalSkills.map((skill) {
                      return Container(
                        margin: EdgeInsets.only(right: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Start: ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : 'N/A'}',
                    ),
                    Text(
                      'End: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : 'N/A'}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
