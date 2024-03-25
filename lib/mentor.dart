import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MentorPage extends StatefulWidget {
  final String? category;
  final double? calories;

  const MentorPage({Key? key, this.category, this.calories}) : super(key: key);

  @override
  _MentorPageState createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
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
                    '$consumedCalories',
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
