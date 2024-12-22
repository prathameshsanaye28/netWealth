import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  final String projectId;

  FeedbackScreen({required this.projectId});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback cannot be empty')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final projectRef = FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId);

      final projectSnapshot = await projectRef.get();
      if (!projectSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project not found')),
        );
        return;
      }

      // Add new feedback with a placeholder username.
      // Replace 'Anonymous' with the actual username logic.
      final newFeedback = "Anonymous: ${_feedbackController.text.trim()}";

      final List<dynamic> currentFeedbacks =
          projectSnapshot['feedbackComments'] ?? [];
      currentFeedbacks.add(newFeedback);

      // Update feedback in Firestore
      await projectRef.update({
        'feedbackComments': currentFeedbacks,
      });

      setState(() {
        _feedbackController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback added successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add feedback: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(224, 226, 248, 1),
        title: Text('Suggest Feedback'),
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
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('projects')
              .doc(widget.projectId)
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
              final List<dynamic> feedbackComments =
                  project['feedbackComments'] ?? [];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Previous Feedbacks:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),
                    feedbackComments.isEmpty
                        ? Text('No feedbacks yet.')
                        : Expanded(
                            child: ListView.builder(
                              itemCount: feedbackComments.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Icon(Icons.feedback),
                                  title: Text(feedbackComments[index]),
                                );
                              },
                            ),
                          ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _feedbackController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Add Feedback',
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    _isSubmitting
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _submitFeedback,
                            child: Text('Submit Feedback'),
                          ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
