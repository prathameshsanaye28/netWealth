import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ResumeEnhanceScreen extends StatefulWidget {
  final String originalText;
  const ResumeEnhanceScreen({super.key, required this.originalText});

  @override
  ResumeEnhanceScreenState createState() => ResumeEnhanceScreenState();
}

class ResumeEnhanceScreenState extends State<ResumeEnhanceScreen> {
  String simplifiedText = '';
  bool isSimplifiedWindowVisible = false;
  bool isLoading = true; // Track loading state

  // Initialize Gemini
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyAsIWg2xV5Dv-2-IR4pZBZOKwg4wbfI6So',
  );

  // Simplify the text as soon as the screen loads
  @override
  void initState() {
    super.initState();
    simplifyText();
  }

  Future<void> simplifyText() async {
    try {
      final prompt =
          'See this extracted text of resume and give a resume score out of 100 and also suggest enhancements and improvements, say the drawbacks and keeping technical skills and work experience as priority and give in simple plain text format, no bold or any type of formatting: ${widget.originalText}';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        simplifiedText = response.text ?? 'Unable to simplify text';
        isSimplifiedWindowVisible = true;
        isLoading = false; // Update loading state when done
      });
    } catch (e) {
      debugPrint('Error simplifying text: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to simplify text. Please try again.'),
        ),
      );
      setState(() {
        isLoading = false; // Update loading state on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate fixed height for the simplified window
    final screenHeight = MediaQuery.of(context).size.height;
    final windowHeight = screenHeight * 0.5; // 50% of screen height

    return Scaffold(
      backgroundColor: Color.fromRGBO(200, 202, 240, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(224, 226, 248, 1),
        title: const Text('Resume Enhancer'),
        //elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Container(
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
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isLoading)
                      Center(
                        child:
                            CircularProgressIndicator(), // Show progress indicator while loading
                      )
                    else
                      Text(
                        simplifiedText,
                        style: const TextStyle(fontSize: 18, height: 1.5),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Simplified text window
            ],
          ),
        ),
      ),
    );
  }
}