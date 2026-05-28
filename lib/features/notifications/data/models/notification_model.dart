import 'package:flutter/material.dart';

class NotifModel {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  bool isRead;

  /// null  → show detail bottom-sheet
  /// non-null → navigate to that route
  final String? route;

  NotifModel({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    this.route,
  });
}
