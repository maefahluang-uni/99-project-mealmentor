import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateAgeData(int newAge) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'age': newAge});
    } else {
      print('Error: User is null');
    }
  } catch (e) {
    print('Error updating age data: $e');
    // Handle error
  }
}
