import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/screens/network_visualisation_screen.dart';
import 'package:netwealth_vjti/screens/resume_enhancer/imagetotext.dart';

import '../models/professional.dart';

// Assuming you already have the Professional model defined as provided.

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

// class Professional {
//   final String? id;
//   final String? name;
//   final String? email;
//   final String? phone;
//   final String role;
//   final List<String> technicalSkills;
//   final List<String> regulatoryExpertise;
//   final List<String> financialStandards;
//   final List<String> industryFocus;
//   final String jurisdiction;
//   final int yearsExperience;
//   final String? photoUrl;

//   const Professional({
//     this.id,
//     required this.name,
//     this.email,
//     this.phone,
//     this.role = "Professional",
//     this.technicalSkills = const [],
//     this.regulatoryExpertise = const [],
//     this.financialStandards = const [],
//     this.industryFocus = const [],
//     required this.jurisdiction,
//     required this.yearsExperience,
//     this.photoUrl,
//   });

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'email': email,
//         'phone': phone,
//         'role': role,
//         'technicalSkills': technicalSkills,
//         'regulatoryExpertise': regulatoryExpertise,
//         'financialStandards': financialStandards,
//         'industryFocus': industryFocus,
//         'jurisdiction': jurisdiction,
//         'yearsExperience': yearsExperience,
//         'photoUrl': photoUrl,
//       };

//   static Professional fromSnap(DocumentSnapshot snap) {
//     // Check if the document data exists
//     if (!snap.exists || snap.data() == null) {
//       throw Exception('Document does not exist or data is null');
//     }

//     var snapshot = snap.data() as Map<String, dynamic>;

//     return Professional(
//       id: snap.id,
//       name: snapshot['name'],
//       email: snapshot['email'],
//       phone: snapshot['phone'],
//       role: snapshot['role'] ?? "Professional",
//       technicalSkills: List<String>.from(snapshot['technicalSkills'] ?? []),
//       regulatoryExpertise:
//           List<String>.from(snapshot['regulatoryExpertise'] ?? []),
//       financialStandards:
//           List<String>.from(snapshot['financialStandards'] ?? []),
//       industryFocus: List<String>.from(snapshot['industryFocus'] ?? []),
//       jurisdiction: snapshot['jurisdiction'],
//       yearsExperience: snapshot['yearsExperience'],
//       photoUrl: snapshot['photoUrl'],
//     );
//   }
// }