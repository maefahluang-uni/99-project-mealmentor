import 'package:flutter/material.dart';
import 'package:mealmentor/Profile.dart';
import 'package:mealmentor/mentor.dart';
import 'package:mealmentor/scan.dart';

class HomePage extends StatefulWidget {
  final String? category;
  final double? calories;

  const HomePage({Key? key, this.category, this.calories}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<String> items = [];

  final List<Widget> _pages = [
    const MentorPage(
      items: [],
    ),
    ScanPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'MENTOR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'SCAN',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}
