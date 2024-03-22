import 'package:flutter/material.dart';

class ConnectionModel {
  String name;
  String iconPath;
  String description;
  bool boxIsSelected;

  ConnectionModel({
    required this.name,
    required this.iconPath,
    required this.description,
    required this.boxIsSelected,
  });

  static List<ConnectionModel> getConnection() {
    List<ConnectionModel> connection = [];

    connection.add(
      ConnectionModel(
          name: 'Zepp Life',
          iconPath:
              'assets/icons/zepp-life-svgrepo-com.svg', // corrected iconPath
          description: 'Connect to this app to retrieve your activites data',
          boxIsSelected: true),
    );

    connection.add(
      ConnectionModel(
          name: 'Samsung Health',
          iconPath:
              'assets/icons/icons8-samsung-health.svg', // corrected iconPath
          description: 'Connect to this app to retrieve your activites data',
          boxIsSelected: false),
    );

    connection.add(
      ConnectionModel(
          name: 'Google Fit',
          iconPath: 'assets/icons/google-fit-svgrepo-com.svg',
          description: 'Connect to this app to retrieve your activites data',
          boxIsSelected: true),
    );

    return connection;
  }
}
