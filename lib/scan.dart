// scan.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Page',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: ImagePickerWidget(),
    );
  }
}

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  late File _image; // Non-nullable variable
  String? _predictionResult;
  double? _caloriesResult; // Changed to double
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _image = File(''); // Set a default value or null if you prefer
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Call the predictImage method here
      predictImage();
    }
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Call the predictImage method here
      predictImage();
    }
  }

  Future<void> predictImage() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://pinecone-api-dfkeodpluq-uc.a.run.app/predict');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', _image.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);
      setState(() {
        _predictionResult = responseJson['category'];
        _caloriesResult = double.tryParse(responseJson['calories'] ?? ''); // Convert to double
        _isLoading = false;
      });
    } else {
      setState(() {
        _predictionResult = 'Error predicting image';
        _caloriesResult = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: _image == null || _image.path.isEmpty
                ? Text('No image selected.')
                : Image.file(_image, fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: 20),
        _isLoading
            ? CircularProgressIndicator()
            : _predictionResult != null
                ? Column(
                    children: [
                      Text(
                        _predictionResult!,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _caloriesResult != null ? _caloriesResult.toString() : '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                : Container(),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: getImageFromGallery,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Icon(Icons.image),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: getImageFromCamera,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                  child: Icon(Icons.camera),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}