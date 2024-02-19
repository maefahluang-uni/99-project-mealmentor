import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MentorPage extends StatefulWidget {
  @override
  _MentorPageState createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  double progressValue = 0;
  int totalCalories = 2500;
  int consumedCalories = 0;

  void addCalories(int calories) {
    setState(() {
      consumedCalories += calories;
      progressValue = consumedCalories / totalCalories;
      progressValue = progressValue.clamp(0.0, 1.0);
    });
  }

  int remainingCalories() {
    return ((1 - progressValue) * totalCalories).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 145, 255, 112),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20), // Add SizedBox at the top
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
              SizedBox(
                width: 10,
              ),
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
                      'Cal',
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
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(
                      255, 255, 255, 255), // สีพื้นหลังส่วนที่สองใต้วงกลม
                  border: Border.all(
                    color: Colors.white, // สีขอบ
                    width: 2.0, // ความกว้างขอบ
                  ),
                  borderRadius: BorderRadius.circular(12.0), // ความโค้งขอบ
                ),
                height: MediaQuery.of(context).size.height *
                    0.5, // ปรับความสูงตามที่ต้องการ
              ),
              Positioned(
                top: 20, // ปรับตำแหน่งของ Today Meal จากบนลงล่าง
                left: 70, // ปรับตำแหน่งจากซ้ายไปขวา
                right: 70,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(198, 0, 255, 149),
                    border: Border.all(
                      color: Color(0xFF2FFFAF), // สีขอบ
                      width: 2.0, // ความกว้างขอบ
                    ),
                    borderRadius: BorderRadius.circular(12.0), // ความโค้งขอบ
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text(
                      'Today Meal',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => addCalories(300),
            child: Text('ADD 300 Calories'),
          ),
        ],
      ),
    );
  }
}
