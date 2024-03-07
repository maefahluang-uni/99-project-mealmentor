// scan.dart

import 'dart:io'; // Importing dart IO library for file operations
import 'package:flutter/material.dart'; // Importing material package
import 'package:image_picker/image_picker.dart'; // Importing image_picker package

class ScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Page', // Title of the app bar
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white, // Background color of app bar
        elevation: 0.0, // No shadow
        centerTitle: true, // Center align title
      ),
      body: ImagePickerWidget(), // Display ImagePickerWidget in the body
    );
  }
}

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  late File _image; // Non-nullable variable to hold picked image

  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  @override
  void initState() {
    super.initState();
    _image = File(''); // Initialize with a default empty file
  }

  // Function to get image from gallery
  Future<void> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Pick image from gallery
    );

    // If an image is picked, update the state with the new image
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to get image from camera
  Future<void> getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera, // Capture image from camera
    );

    // If an image is picked, update the state with the new image
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            // Display the picked image if available, otherwise show a text indicating no image selected
            child: _image == null || _image.path.isEmpty
                ? Text('No image selected.')
                : Image.file(_image, fit: BoxFit.cover),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Button to pick image from gallery
                ElevatedButton(
                  onPressed: getImageFromGallery,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Icon(Icons.image), // Gallery icon
                ),
                SizedBox(height: 16),
                // Button to pick image from camera
                ElevatedButton(
                  onPressed: getImageFromCamera,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                  child: Icon(Icons.camera), // Camera icon
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
