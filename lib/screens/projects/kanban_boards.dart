import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'kanban_details.dart';

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({Key? key}) : super(key: key);

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String projectId = "project1"; // Placeholder for user input project ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(224, 226, 248, 1),
        title: const Text('Kanban Boards'),
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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // Show a dialog to input the Kanban board title
                String? newTitle = await _showCreateBoardDialog(context);

                if (newTitle != null && newTitle.isNotEmpty) {
                  // Generate a new board ID
                  String newBoardId =
                      _firestore.collection('kanban_boards').doc().id;

                  // Save the new board to Firestore
                  await _firestore
                      .collection('kanban_boards')
                      .doc(newBoardId)
                      .set({
                    'id': newBoardId,
                    'projectId': projectId,
                    'title': newTitle,
                    'lists': [],
                  });
                }
              },
              child: const Text('Create New Kanban Board'),
            ),
            const Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('kanban_boards')
                    .where('projectId', isEqualTo: projectId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      String title = doc['title'] ??
                          'Default Title'; // Handle missing fields

                      return ListTile(
                        title: Text(title),
                        onTap: () {
                          // Navigate to the Kanban details screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KanbanDetailsScreen(
                                projectId: projectId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a dialog box for creating a new Kanban board
  Future<String?> _showCreateBoardDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Kanban Board'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Board Title',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dismiss dialog without saving
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context, titleController.text); // Return the input value
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
