import 'package:flutter/material.dart';

class MyMunus extends StatelessWidget {
  final String child;

  MyMunus({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        child: Row(
          children: [
            Text(
              child,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.07),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.07),
                offset: Offset(0, 10),
                blurRadius: 40,
                spreadRadius: 0,
              )
            ]),
      ),
    );
  }
}
