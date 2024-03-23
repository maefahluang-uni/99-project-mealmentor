// userinfo.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mealmentor/home.dart'; // Import HomePage

class UserInfoPage extends StatefulWidget {
  final String userId;
  final String email;

  UserInfoPage({required this.userId, required this.email});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  int _totalCalories = 0; // ตั้งค่าเริ่มต้นเป็น 0

  void _addUserInfoToFirestore(BuildContext context) {
    // Get a reference to the Firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Add user information to Firestore
    users.doc(widget.userId).set({
      'username': _usernameController.text.trim(),
      'dob': _dobController.text.trim(),
      'totalCalories':
          _totalCalories, // ใช้ค่าที่ผู้ใช้ป้อนเข้ามาแทนที่ค่าเริ่มต้น
      'email': widget.email,
    }).then((value) {
      // Navigate to the HomePage after adding user info
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }).catchError((error) {
      print('Failed to add user information: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'Date of Birth (YYYY-MM-DD)',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Total Calories',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _totalCalories = int.tryParse(value) ??
                      0; // อัปเดตค่า _totalCalories เมื่อผู้ใช้ป้อนค่าใหม่
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _addUserInfoToFirestore(context),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
