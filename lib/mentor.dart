import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mealmentor/connection.dart';
import 'dart:io';
import 'package:mealmentor/scan.dart';

class MentorPage extends StatefulWidget {
  final String? category;
  final double? calories;
  final File? imageFile;
  final List<String> items; // Declare the items parameter

  const MentorPage({
    Key? key,
    this.category,
    this.calories,
    this.imageFile,
    required this.items, // Require the items parameter
  }) : super(key: key);

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
  late double calories;

  @override
  void initState() {
    super.initState();
    calories = widget.calories ?? 0.0;
    _imageFile = widget.imageFile;
    items = widget.items; // Assign the value of the items parameter
    fetchTotalCalories(); // Assign a default value if widget.calories is null
    consumedCalories = widget.calories?.toInt() ?? 0;
    progressValue = consumedCalories / totalCalories;
    progressValue = progressValue.clamp(0.0, 1.0);
    progressValue = 0.0;
    // Set progressValue to 0 initially (remove this block of code)
  }

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
  double progressValue = 0.0;
  int consumedCalories = 0;
  File? _imageFile;

  List<String> items = []; // ตัวอย่างรายการที่มีอยู่แล้ว

  // @override
  // void initState() {
  //   super.initState();
  // _imageFile = widget.imageFile;
  // //  items = widget.items; // Assign the value of the items parameter
  //  fetchTotalCalories();
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 145, 255, 112),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                progressColor: Color.fromARGB(255, 1, 140, 255),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${remainingCalories()}',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
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
                height: MediaQuery.of(context).size.height * 0.3,
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
              Positioned(
                top: 70,
                left: 20,
                right: 20,
                child: Container(
                  height: 300,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 15,
                          ),
                          itemBuilder: (context, index) {
                            if (items.isEmpty) {
                              return Container();
                            } else {
                              return Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Color(0xff1D1617).withOpacity(0.07),
                                      offset: Offset(0, 10),
                                      blurRadius: 40,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //ที่สำหรับใส่รูปอาหารที่ดึงค่ามา
                                    _imageFile != null
                                        ? Image.file(
                                            _imageFile!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.image,
                                            size: 80,
                                          ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.category}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          '${widget.calories} calorie',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      // เพิ่มปุ่มเพื่อเพิ่ม Card
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
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
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                Positioned(
                  top: 70,
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
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 120, // Position Today Meal from top
                  left: 50, // Position from left
                  right: 50, // Position from right
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 145, 255, 112),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: authorize,
                    child: Text(
                      'Auth',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 167.5, // Position Today Meal from top
                  left: 50, // Position from left
                  right: 50, // Position from right
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 145, 255, 112),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed:
                        fetchBurnedCals, //เรียกใช้ method fetchedBurnedCals และส่งค่าเข้าตัวแปร burnedCals
                    child: Text(
                      'Sync cal data',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // โชว์ totalCalories ใน Dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Total Calories"),
                    content: Text("$calories  "),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text("Check Total Calories"),
          ),
          ElevatedButton(
            onPressed: () {
              // ตรวจสอบว่าค่า calories เป็นค่าบวกหรือไม่
              if (calories > 0) {
                // รับค่าจำนวนแคลอรี่ที่ต้องการเพิ่ม
                double caloriesToAdd =
                    calories.toDouble(); // ตั้งค่าตัวอย่างเป็น 100 แคลอรี่
                // เรียกใช้เมธอด addCalories และส่งค่าแคลอรี่ที่ต้องการเพิ่ม
                addCalories(caloriesToAdd);
              } else {
                // แสดงข้อความบนคอนโซลเมื่อค่า calories เป็นค่าลบ
                print("Invalid value for calories: $calories");
              }
            },
            child: Text("Add Calories"),
          ),
          SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate back to the previous screen
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
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
            // เรียกใช้งาน updateProgress() เพื่ออัปเดตค่าความคืบหน้า
            updateProgress();
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

  // void addCalories(double calories) {
  //   setState(() {
  //   consumedCalories += calories.round();
//progressValue = consumedCalories / totalCalories;
  //   progressValue = progressValue.clamp(0.0, 1.0);

  // เรียกใช้ฟังก์ชัน remainingCalories() เพื่อให้ค่า progressValue มีการอัปเดต
//remainingCalories();
  //  });
  // }

  int remainingCalories() {
    return totalCalories - consumedCalories;
  }

  void updateProgress() {
    setState(() {
      progressValue = consumedCalories / totalCalories;
      progressValue = progressValue.clamp(
          0.0, 1.0); // ตรวจสอบและจำกัดค่าให้อยู่ในช่วงระหว่าง 0.0 ถึง 1.0
    });
  }

  void addScannedFood() {
    setState(() {
      items.add(widget.category!);
      consumedCalories += (widget.calories ?? 0).toInt();
      updateProgress(); // เพิ่มเส้นทางนี้เพื่ออัปเดตค่าความคืบหน้า
    });
  }

  void addCalories(double calories) {
    setState(() {
      if (consumedCalories + calories <= totalCalories) {
        consumedCalories += calories.toInt();
        updateProgress(); // เพิ่มเส้นทางนี้เพื่ออัปเดตค่าความคืบหน้า
      } else {
        print(
            "Cannot add more calories. Consumed calories would exceed total calories.");
      }
    });
  }
}
