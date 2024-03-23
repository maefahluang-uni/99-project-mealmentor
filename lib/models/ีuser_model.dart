import 'package:firebase_database/firebase_database.dart';

class User {
  final String uid;
  final String displayName;
  final String email;
  final int totalCalories;

  User({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.totalCalories,
  });

  // Convert user object to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'totalCalories': totalCalories,
    };
  }

  // Convert JSON to user object
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      uid: json['uid'],
      displayName: json['displayName'],
      email: json['email'],
      totalCalories: json['totalCalories'],
    );
  }

  User.fromSnapshot(DataSnapshot snapshot)
      : uid = snapshot.key ?? '',
        displayName =
            (snapshot.value as Map<String, dynamic>)['displayName'] ?? '',
        email = (snapshot.value as Map<String, dynamic>)['email'] ?? '',
        totalCalories =
            (snapshot.value as Map<String, dynamic>)['totalCalories'] ?? 0;

  // Convert user object to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'totalCalories': totalCalories,
    };
  }
}
