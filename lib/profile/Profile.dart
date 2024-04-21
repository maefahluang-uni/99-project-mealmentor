import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealmentor/home.dart'; // Import HomePage
import 'package:mealmentor/profile/upage.dart'; // Import each function file
import 'package:mealmentor/profile/upweight.dart';
import 'package:mealmentor/profile/uptotalcal.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text('Error: User is null'),
      );
    }

    Future<void> _showImagePicker(BuildContext context) async {
      final picker = ImagePicker();
      final pickedImage = await picker.getImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        final String imageFileName =
            'user_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final firebaseStorageRef =
            FirebaseStorage.instance.ref().child('user_avatars/$imageFileName');
        final uploadTask = firebaseStorageRef.putFile(File(pickedImage.path));

        uploadTask.whenComplete(() async {
          final imageUrl = await firebaseStorageRef.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'profileImageUrl': imageUrl,
          });
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Page',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showImagePicker(context);
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue,
                        backgroundImage:
                            NetworkImage(userData['profileImageUrl'] ?? ''),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userData['username']}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Age: ${userData['age']} years old',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _buildEditDialog(
                                        context, 'Age', userData['age']);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              '${userData['totalCalories']} kcal / day',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _buildEditDialog(
                                        context,
                                        'Total Calories',
                                        userData['totalCalories']);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Set Motivation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Begin ${userData['begin_kg']} KG',
                          style: TextStyle(fontSize: 12),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildEditDialog(
                                    context, 'BEGIN', userData['begin_kg']);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Now ${userData['now_kg'] ?? ''} KG',
                          style: TextStyle(fontSize: 12),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildEditDialog(
                                    context, 'Now', userData['now_kg'] ?? '');
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'GOAL ${userData['goal_kg'] ?? ''} KG',
                          style: TextStyle(fontSize: 12),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildEditDialog(
                                    context, 'GOAL', userData['goal_kg'] ?? '');
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'About me',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ListTile(
                  title: Text('My Account'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to My Account screen
                  },
                ),
                ListTile(
                  title: Text('Height'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Height screen
                  },
                ),
                ListTile(
                  title: Text('Birthdate'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Birthdate screen
                  },
                ),
                ListTile(
                  title: Text('Gender'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Gender screen
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Build edit dialog
  Widget _buildEditDialog(
      BuildContext context, String field, dynamic currentValue) {
    String newValue = currentValue.toString();
    return AlertDialog(
      title: Text('Edit $field'),
      content: TextFormField(
        keyboardType: TextInputType.number,
        initialValue: currentValue.toString(),
        decoration: InputDecoration(labelText: 'New $field'),
        onChanged: (value) {
          newValue = value;
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Call function to update weight, age, or total calories data
            if (field == 'Age') {
              updateAgeData(int.parse(newValue));
            } else if (field == 'Total Calories') {
              updateTotalCaloriesData(int.parse(newValue));
            } else {
              updateWeightData(field.toLowerCase() + '_kg', newValue);
            }
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
