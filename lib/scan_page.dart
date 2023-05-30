import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late File _pickedImage;
  String _scannedText = '';

  Future<void> _pickImage(ImageSource source) async {
    final pickedImageFile = await ImagePicker().getImage(source: source);
    setState(() {
      if (pickedImageFile != null) {
        _pickedImage = File(pickedImageFile.path);
        _scannedText = '';
        _scanText();
      } else {
        print('Aucune image sélectionnée.');
      }
    });
  }

  Future<void> _scanText() async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_pickedImage);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    String scannedText = '';
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          scannedText += '${element.text!} ';
        }
        scannedText += '\n';
      }
    }

    setState(() {
      _scannedText = scannedText;
    });

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _pickedImage != null
                ? Image.file(
                    _pickedImage,
                    height: 200,
                  )
                : Container(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Prendre une photo'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Sélectionner une image'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Texte scanné :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _scannedText,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
