import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateWeightData(String field, dynamic newValue) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({field: newValue});
    } else {
      print('Error: User is null');
    }
  } catch (e) {
    print('Error updating weight data: $e');
    // Handle error
  }
}
