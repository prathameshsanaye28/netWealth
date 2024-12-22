import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewRequestsScreen extends StatelessWidget {
  final String projectId;

  const ViewRequestsScreen({required this.projectId, Key? key})
      : super(key: key);

  Future<List<Map<String, dynamic>>> fetchRequests(String projectId) async {
    final projectRef =
        FirebaseFirestore.instance.collection('projects').doc(projectId);

    final projectSnapshot = await projectRef.get();
    final List<String> joinRequests =
        List<String>.from(projectSnapshot['joinRequests'] ?? []);

    List<Map<String, dynamic>> userDetails = [];
    for (String userId in joinRequests) {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        userDetails.add({
          'userId': userId,
          'name': userSnapshot['name'],
          'email': userSnapshot['email'],
        });
      }
    }

    return userDetails;
  }

  Future<void> approveRequest(
      BuildContext context, String userId, String projectId) async {
    TextEditingController roleController = TextEditingController();

    // Open dialog box to enter role
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign Role'),
        content: TextField(
          controller: roleController,
          decoration: InputDecoration(hintText: 'Enter role'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final role = roleController.text.trim();
              if (role.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Role cannot be empty')),
                );
                return;
              }

              Navigator.pop(context);

              try {
                final projectRef = FirebaseFirestore.instance
                    .collection('projects')
                    .doc(projectId);

                // Remove userId from joinRequests and add to userRoles
                await projectRef.update({
                  'joinRequests': FieldValue.arrayRemove([userId]),
                  'userRoles': {userId: role},
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User approved and role assigned')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to approve user: $e')),
                );
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> rejectRequest(BuildContext context, String userId) async {
    try {
      final projectRef =
          FirebaseFirestore.instance.collection('projects').doc(projectId);

      // Remove userId from joinRequests
      await projectRef.update({
        'joinRequests': FieldValue.arrayRemove([userId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User request rejected')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject request: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Join Requests'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchRequests(projectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No join requests found.'));
          } else {
            final userDetails = snapshot.data!;
            return ListView.builder(
              itemCount: userDetails.length,
              itemBuilder: (context, index) {
                final user = userDetails[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () =>
                            approveRequest(context, user['userId'], projectId),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => rejectRequest(context, user['userId']),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
