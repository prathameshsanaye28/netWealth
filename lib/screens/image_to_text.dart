import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Image to Text",
          style: TextStyle(color: Colors.white),
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
      body: Stack(
        children: [
          //const rive.RiveAnimation.asset("assets/RiveAssets/bg-blur.riv"),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 500,
                    //borderRadius: 25,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _imageView(),
                          const SizedBox(height: 20),
                          // Optional: Show extracted text
                          // Text(
                          //   extractedText,
                          //   style: const TextStyle(color: Colors.white),
                          //   maxLines: 10,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Only show button if text is extracted
                  if (extractedText.isNotEmpty)
                  Container(
                    child: Text(extractedText,style: TextStyle(color: Colors.white),),
                  )
                    // GestureDetector(
                    //   onTap: () {
                    //     // Navigate to CreateChecklistScreen with extracted text
                    //     // Navigator.push(
                    //     //   context,
                    //     //   MaterialPageRoute(
                    //     //     builder: (context) => CreateChecklistScreen(
                    //     //       extractedText: extractedText,
                    //     //       shiftInchargeId: user?.id??'', // Replace with actual user ID
                    //     //     ),
                    //     //   ),
                    //     // );
                    //   },
                    //   child: const CustomGreenButton(label: 'Create Checklist'),
                    // )
                ],
              ),
            ),
          ),
        ],
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