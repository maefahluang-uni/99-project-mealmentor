import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mealmentor/models/MyMenus.dart';
import 'package:mealmentor/models/connect_model.dart';
import 'package:mealmentor/connection.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MentorPage extends StatefulWidget {
  @override
  _MentorPageState createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  double progressValue = 0; // Initialize the progress value to 0
  int totalCalories = 2500; // Total calories target
  int consumedCalories = 0; // Initialize consumed calories to 0

  // Function to add consumed calories and update progress
  void addCalories(int calories) {
    setState(() {
      consumedCalories += calories;
      // Calculate progress value as a ratio of consumed to total calories
      progressValue = consumedCalories / totalCalories;
      // Ensure progress value stays within 0 and 1
      progressValue = progressValue.clamp(0.0, 1.0);
    });
  }

  // Function to calculate remaining calories
  int remainingCalories() {
    return ((1 - progressValue) * totalCalories).round();
  }

  final List<int> _calrories = [200, 300, 500, 700, 250, 100];

  final List _post = [
    'Menu 1',
    'Menu 2',
    'Menu 3',
    'Menu 4',
    'Menu 5',
    'Menu 6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 145, 255, 112), // Set background color
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
                    '$consumedCalories', // Display consumed calories
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Intake', // Display "Intake" label
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
                radius: 70.0, // Radius of the circular progress indicator
                lineWidth: 13.0, // Width of the progress line
                percent:
                    progressValue, // Percent filled based on progress value
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                progressColor: Colors.blueAccent,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${remainingCalories()}', // Display remaining calories
                      style: TextStyle(
                        color: Color.fromARGB(255, 247, 247, 247),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Cal', // Display "Cal" label
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
                    '$consumedCalories', // Display consumed calories
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Burned', // Display "Burned" label
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
                      'Left', // Display "Left" label
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
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255,
                      255), // Background color of the bottom part
                  border: Border.all(
                    color: Color.fromARGB(255, 255, 255, 255), // Border color
                    width: 2.0, // Border width
                  ),
                  borderRadius: BorderRadius.circular(12.0), // Border radius
                ),
                height: MediaQuery.of(context).size.height *
                    0.35, // Set the height of the container
              ),
              Positioned(
                top: 20, // Position Today Meal from top
                left: 50, // Position from left
                right: 50, // Position from right
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(198, 0, 255, 149), // Background color
                    border: Border.all(
                      color: Color(0xFF2FFFAF), // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(12.0), // Border radius
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
              Positioned(
                top: 70, // Position Today Meal from top
                left: 20, // Position from left
                right: 20, // Position from right
                child: Container(
                  height: 300,
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        child: ListView.builder(
                          itemCount: _post.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => addCalories(_calrories[index]),
                              child: MyMunus(
                                child: _post[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
                    color: Color.fromARGB(255, 255, 255,
                        255), // Background color of the bottom part
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 255, 255), // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(12.0), // Border radius
                  ),
                  height: MediaQuery.of(context).size.height *
                      0.5, // Set the height of the container
                ),
                Positioned(
                  top: 80, // Position Today Meal from top
                  left: 50, // Position from left
                  right: 50, // Position from right
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
                  top: 20, // Position Today Meal from top
                  left: 50, // Position from left
                  right: 50, // Position from right
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          Color.fromARGB(198, 0, 255, 149), // Background color
                      border: Border.all(
                        color: Color(0xFF2FFFAF), // Border color
                        width: 2.0, // Border width
                      ),
                      borderRadius:
                          BorderRadius.circular(12.0), // Border radius
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        'Burning Activities', // Display "Today Meal"
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
                Positioned(
                  top: 140, // Position Today Meal from top
                  left: 50, // Position from left
                  right: 50, // Position from right
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 145, 255, 112),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to the next page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConnectionPage()),
                      );
                    },
                    child: Text(
                      'Connect',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 200, // Position Today Meal from top
                  left: 50, // Position from left
                  right: 50, // Position from right
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 145, 255, 112),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to the next page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConnectionPage()),
                      );
                    },
                    child: Text(
                      'Add Activites',
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
        ],
      ),
    );
  }
}