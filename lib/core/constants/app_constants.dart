import 'package:flutter/material.dart';

enum NotePriorityEnum {
  low(title: 'Low', color: Colors.green),
  normal(title: 'Normal', color: Colors.orangeAccent),
  high(title: 'High', color: Colors.redAccent);

  final String title;
  final Color color;

  const NotePriorityEnum({required this.title, required this.color});

  // get title
  static String getTitle(NotePriorityEnum option) => option.title;

  // get option by title
  static NotePriorityEnum getOption(String title) {
    return NotePriorityEnum.values.firstWhere(
      (e) => e.title == title,
      orElse: () => NotePriorityEnum.normal,
    );
  }
}

class AppConstants {
  static final String appName = "KeepNote";
}
