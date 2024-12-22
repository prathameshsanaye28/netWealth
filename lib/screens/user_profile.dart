import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/screens/course_screen/course.dart';
import 'package:netwealth_vjti/screens/network_visualisation_screen.dart';
import 'package:netwealth_vjti/screens/resume_enhancer/imagetotext.dart';

import '../models/professional.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;

  UserProfileScreen({required this.userId});

  Future<Professional> fetchUserProfile() async {
    // Fetch user profile from Firestore
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users') // Your Firestore collection
        .doc(userId)
        .get();

    return Professional.fromSnap(snap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(224, 226, 248, 1),
        title: Text("User Profile"),
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
        child: FutureBuilder<Professional>(
          future: fetchUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData) {
              return Center(child: Text("User data not found"));
            }

            final professional = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Profile Picture
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: professional.photoUrl != null
                          ? NetworkImage(professional.photoUrl!)
                          : AssetImage('assets/default_avatar.png')
                              as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Name
                  Text(
                    professional.name ?? "Name not available",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  // Show badges if available
                  BadgeDisplayRow(userId: userId),
                  SizedBox(height: 10),
                  // Role
                  Text(
                    professional.role,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>NetworkVisualizationScreen()));
                      }, child: Text('See Network'),),
                      ElevatedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageToTextScreen()));
                      }, child: Text('Analyze Resume'))
                    ],
                  ),
                  // Email
                  Row(
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 10),
                      Text(professional.email ?? "Email not available"),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Phone
                  Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 10),
                      Text(professional.phone ?? "Phone not available"),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Financial Standards
                  _buildSectionTitle("Financial Standards"),
                  _buildList(professional.financialStandards),
                  SizedBox(height: 20),
                  // Industry Focus
                  _buildSectionTitle("Industry Focus"),
                  _buildList(professional.industryFocus),
                  SizedBox(height: 20),
                  // Regulatory Expertise
                  _buildSectionTitle("Regulatory Expertise"),
                  _buildList(professional.regulatoryExpertise),
                  SizedBox(height: 20),
                  // Technical Skills
                  _buildSectionTitle("Technical Skills"),
                  _buildList(professional.technicalSkills),
                  SizedBox(height: 20),
                  // Experience & Jurisdiction
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 10),
                      Text("Jurisdiction: ${professional.jurisdiction}"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 10),
                      Text("Experience: ${professional.yearsExperience} years"),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to build section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Helper method to build list of items
  Widget _buildList(List<String> items) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(item),
              ))
          .toList(),
    );
  }
}

class BadgeDisplayRow extends StatefulWidget {
  final String userId;

  BadgeDisplayRow({required this.userId});

  @override
  _BadgeDisplayRowState createState() => _BadgeDisplayRowState();
}

class _BadgeDisplayRowState extends State<BadgeDisplayRow> {
  late Future<List<String>> badges;

  @override
  void initState() {
    super.initState();
    badges = fetchBadges();
  }

  Future<List<String>> fetchBadges() async {
    // Query Firestore to get badges where userId matches
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('badges')
        .where('userId', isEqualTo: widget.userId)
        .get();

    // Extract courseId from matching badges
    List<String> badgeCourseIds = [];
    for (var doc in snapshot.docs) {
      String courseId = doc['courseId'];
      badgeCourseIds.add(courseId); // Add the full courseId
    }

    return badgeCourseIds;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: badges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Don't display anything related to badges if none are found
          return SizedBox.shrink();
        }

        List<String> badgeCourseIds = snapshot.data!;

        return Row(
          children: [
            SizedBox(width: 20),
            ...badgeCourseIds.map((courseId) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  // Fetch course details when badge is clicked
                  final course = await fetchCourseDetails(courseId);
                  // Show snackbar with course details
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Course: ${course.title}\nDescription: ${course.description}',
                        style: TextStyle(fontSize: 14),
                      ),
                      duration: Duration(seconds: 4),
                    ),
                  );
                },
                child: CircleBadge(courseId: courseId),
              ),
            )).toList(),
          ],
        );
      },
    );
  }

  Future<Course> fetchCourseDetails(String courseId) async {
    // Query Firestore to get course details by courseId
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)  // Fetch the course directly by its courseId
        .get();

    if (snapshot.exists) {
      return Course.fromSnapshot(snapshot);
    } else {
      return Course(
        id: '',
        title: 'Course not found',
        description: 'No description available.',
        category: '',
        thumbnail: '',
        modules: [],
        totalDuration: 0,
        enrolledUsers: [],
        completedUsers: [],
        rating: 0.0,
        numberOfRatings: 0,
      );
    }
  }
}

class CircleBadge extends StatelessWidget {
  final String courseId;

  CircleBadge({required this.courseId});

  @override
  Widget build(BuildContext context) {
    // Get the first letter of the courseId to display in the badge
    String firstLetter = courseId.isNotEmpty ? courseId[0].toUpperCase() : '';

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue, // Background color of the circle
      ),
      child: Center(
        child: Text(
          firstLetter,  // Display the first letter of courseId
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24, // Adjust the font size
          ),
        ),
      ),
    );
  }
}