import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netwealth_vjti/screens/resume_enhancer/resume_enhancer.dart';

class ImageToTextScreen extends StatefulWidget {
  const ImageToTextScreen({Key? key}) : super(key: key);

  @override
  State<ImageToTextScreen> createState() => _ImageToTextScreenState();
}

class _ImageToTextScreenState extends State<ImageToTextScreen> {
  File? selectedMedia;
  final ImagePicker _imagePicker = ImagePicker();
  String extractedText = ""; // Store the extracted text

  @override
  Widget build(BuildContext context) {
    //final ShiftIncharge? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Color.fromRGBO(200, 202, 240, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(224, 226, 248, 1),
        title: const Text(
          "Image to Text",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final XFile? image =
              await _imagePicker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            setState(() {
              selectedMedia = File(image.path);
            });

            // Extract text when a new image is picked
            String? text = await _extractText(File(image.path));
            setState(() {
              extractedText = text ?? "No text found";
            });
          }
        },
        child: const Icon(Icons.add),
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                _imageView(),
                const SizedBox(height: 20),
                // Only show button if text is extracted
                if (extractedText.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResumeEnhanceScreen(
                                    originalText: extractedText,
                                  )));
                    },
                    child: Text(
                      "See Your Resume Score",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageView() {
    if (selectedMedia == null) {
      return const Center(
        child: Text(
          "Pick image",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return Center(
      child: Image.file(
        selectedMedia!,
        width: 200,
        height: 400,
        fit: BoxFit.contain,
      ),
    );
  }

  Future<String?> _extractText(File file) async {
    var textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    return recognizedText.text;
  }
}