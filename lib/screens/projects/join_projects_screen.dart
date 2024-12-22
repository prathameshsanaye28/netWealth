import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JoinRequestScreen extends StatefulWidget {
  final String projectId;
  final String userId;

  const JoinRequestScreen({
    required this.projectId,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  _JoinRequestScreenState createState() => _JoinRequestScreenState();
}

class _JoinRequestScreenState extends State<JoinRequestScreen> {
  bool isLoading = false;

  Future<void> sendJoinRequest() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Firestore reference to the project
      final projectRef = FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId);

      // Add userId to the joinRequests list
      await projectRef.update({
        'joinRequests': FieldValue.arrayUnion([widget.userId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Join request sent successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send join request: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Join Request'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: sendJoinRequest,
                child: Text('Send Join Request'),
              ),
      ),
    );
  }
}
