import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class MentorPage extends StatefulWidget {
  final String? category;
  final double? calories;

  const MentorPage({Key? key, this.category, this.calories}) : super(key: key);

  @override
  _MentorPageState createState() => _MentorPageState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
}

class _MentorPageState extends State<MentorPage> {
  int burnedCals = 0; // ตัวแปรที่รับข้อมูลจาก fetchBurnedCals()

  AppState _state = AppState.DATA_NOT_FETCHED;

  static final types = [
    HealthDataType.WORKOUT,
  ];

  final permissions = types.map((e) => HealthDataAccess.READ).toList();

  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

/////////////////////////////////////
/// Health Connect API Start point///
/////////////////////////////////////

  Future authorize() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    bool authorized = false;
    if (hasPermissions != null && !hasPermissions) {
      try {
        authorized =
            await health.requestAuthorization(types, permissions: permissions);
        print("Authorization requested. Authorization status: $authorized");
      } catch (error) {
        print("Exception in authorize: $error");
      }
    } else {
      print("Already authorized.");
      authorized =
          true; // If permissions are already granted, consider it authorized
    }

    setState(() => _state =
        (authorized) ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED);
  }

  /// Fetch steps from the health plugin and show them in the app.
  Future<void> fetchBurnedCals() async {
    // get current date and midnight
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    // Check permissions for workout data
    bool workoutPermission =
        await health.hasPermissions([HealthDataType.WORKOUT]) ?? false;

    if (!workoutPermission) {
      workoutPermission =
          await health.requestAuthorization([HealthDataType.WORKOUT]);
    }

    if (workoutPermission) {
      try {
        // Fetch workout data since midnight
        final workouts = await health
            .getHealthDataFromTypes(midnight, now, [HealthDataType.WORKOUT]);

        // Calculate total burned calories from workouts (if any)
        int totalBurnedCalories = 0;
        workouts.forEach((workout) {
          if (workout.value is WorkoutHealthValue) {
            final burnedCalories =
                (workout.value as WorkoutHealthValue).totalEnergyBurned;
            if (burnedCalories != null) {
              totalBurnedCalories += burnedCalories;
            }
          }
        });

        // Update progressValue with the calculated totalBurnedCalories
        setState(() {
          burnedCals = totalBurnedCalories;
        });

        print('Total burned calories from workouts: $totalBurnedCalories');
      } catch (error) {
        print("Caught exception in getHealthDataFromTypes: $error");
      }
    } else {
      print("Authorization not granted - error in authorization");
    }
  }

  /// Revoke access to health data. Note, this only has an effect on Android.
  Future revokeAccess() async {
    try {
      await health.revokePermissions();
    } catch (error) {
      print("Caught exception in revokeAccess: $error");
    }
  }

  String _authorizationStatusText() {
    switch (_state) {
      case AppState.AUTHORIZED:
        return "Access Granted!";
      case AppState.AUTH_NOT_GRANTED:
        return "Authorization not given. Please check permissions.";
      default:
        return "";
    }
  }

/////////////////////////////////////
/// Health Connect API End point ////
/////////////////////////////////////


  int totalCalories = 0; // เปลี่ยนจาก 1 เป็น 0
  double progressValue = 0;
  int consumedCalories = 0;

  @override
  void initState() {
    super.initState();
    fetchTotalCalories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 145, 255, 112),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          // แสดงข้อมูล widget.category และ widget.calories ที่ได้รับมาจากหน้า scan.dart
          Text('Category: ${widget.category}'),
          Text('Calories: ${widget.calories}'),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$consumedCalories',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Intake',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10),
              CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 13.0,
                percent: progressValue,
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                progressColor: Colors.blueAccent,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${remainingCalories()}',
                      style: TextStyle(
                        color: Color.fromARGB(255, 247, 247, 247),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Cal Left',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$burnedCals', // ใช้ตัวแปร burnedCals เพื่อแสดงค่าแคลอรี่ที่เผาผลาญ
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Burned',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Text(
                      'Left',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: Color.fromARGB(255, 255, 255, 255),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                height: MediaQuery.of(context).size.height * 0.35,
              ),
              Positioned(
                top: 20,
                left: 50,
                right: 50,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(198, 0, 255, 149),
                    border: Border.all(
                      color: Color(0xFF2FFFAF),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text(
                      'Today Meal', // Display "Today Meal"
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
            child: Column(
              children: [
                SizedBox(height: 100),
                Text("Press Auth Button first then Sync cal data"),
                TextButton(
                    onPressed: authorize,
                    child: Text("Auth", style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue))),
                TextButton(
                    onPressed: fetchBurnedCals, //เรียกใช้ method fetchedBurnedCals และส่งค่าเข้าตัวแปร burnedCals
                    child: Text("Sync cal data",
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue))),
              ],
            ),
          ),
              SizedBox(
                height: 40,
              ),
              SizedBox(height: 40),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                Positioned(
                  top: 80,
                  left: 50,
                  right: 50,
                  child: Container(
                    child: Text(
                      'Tracking your activities with the connection',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 50,
                  right: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(198, 0, 255, 149),
                      border: Border.all(
                        color: Color(0xFF2FFFAF),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        'Burning Activities',
                        style: TextStyle(
                          color: Color(0xFF2FFFAF),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          // แสดงรายการอาหารที่บันทึกไว้
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('meals').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              final meals = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  final category = meal['category'] as String?;
                  final calories = meal['calories'] as int?;
                  return ListTile(
                    title: Text(category ?? ''),
                    subtitle: Text(calories != null ? calories.toString() : ''),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void fetchTotalCalories() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (snapshot.exists) {
          setState(() {
            totalCalories = snapshot.get('totalCalories');
          });
        } else {
          print('Document does not exist');
        }
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print('Error fetching total calories: $e');
    }
  }

  void addCalories(int calories) {
    setState(() {
      consumedCalories += calories;
      progressValue = consumedCalories / totalCalories;
      progressValue = progressValue.clamp(0.0, 1.0);
    });
  }

  int remainingCalories() {
    return (totalCalories - consumedCalories).clamp(0, totalCalories);
  }
}