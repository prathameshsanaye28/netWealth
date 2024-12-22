import 'package:flutter/material.dart';
import 'package:netwealth_vjti/screens/questionnaire_screen.dart';

class JobApplicationScreen extends StatelessWidget {
  final String projectId;

  JobApplicationScreen({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose an option to proceed:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 20),

            // Option 1: Answer Questionnaire
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.quiz, color: Colors.blue),
                title: Text('Answer a Questionnaire'),
                subtitle: Text(
                    'Answer a set of questions related to the project domain.'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionnaireScreen(
                        projectId: projectId,
                        //jobApplication: null,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            // Option 2: Complete Mini Task
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.task_alt, color: Colors.green),
                title: Text('Complete a Mini Task'),
                subtitle:
                    Text('Perform a small task related to the project domain.'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MiniTaskScreen(
                        projectId: '',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MiniTaskScreen extends StatefulWidget {
  final String projectId;

  MiniTaskScreen({required this.projectId});

  @override
  _MiniTaskScreenState createState() => _MiniTaskScreenState();
}

class _MiniTaskScreenState extends State<MiniTaskScreen> {
  final TextEditingController _taskController = TextEditingController();

  void _submitTask() {
    if (_taskController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task description cannot be empty!')),
      );
      return;
    }

    // Submit task description to Firestore or backend logic
    print("Task Submitted: ${_taskController.text.trim()}");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mini task submitted successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Mini Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mini Task Instructions:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 10),
            Text(
              'Provide a detailed solution or description for the following task:',
            ),
            SizedBox(height: 20),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Describe your solution',
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitTask,
        label: Text('Submit'),
        icon: Icon(Icons.check),
      ),
    );
  }
}
