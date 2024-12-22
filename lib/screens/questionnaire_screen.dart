import 'package:flutter/material.dart';

class QuestionnaireScreen extends StatefulWidget {
  final String projectId;

  QuestionnaireScreen({required this.projectId});

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final List<String> questions = [
    "What is your experience in this domain?",
    "How would you solve a challenge related to this project?",
    "What are the key skills you bring to the table?",
  ];

  final Map<int, String> answers = {};

  void _submitAnswers() {
    if (answers.length < questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please answer all questions!')),
      );
      return;
    }

    // Submit answers to Firestore or backend logic
    print("Submitted Answers: $answers");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Questionnaire submitted successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer Questionnaire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questions[index],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextField(
                    onChanged: (value) {
                      answers[index] = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type your answer here',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitAnswers,
        label: Text('Submit'),
        icon: Icon(Icons.check),
      ),
    );
  }
}