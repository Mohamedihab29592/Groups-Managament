
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final int id;
   String title;
   String group;
     String  date;
     String  time;
  final String description;
  final String action;
  final Timestamp timeStamp;

  final String user;
   int colorPriority;
   int completed;
  final int critical;

  TaskModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.group,
    required this.description,
    required this.action,
    required this.user,
    required this.colorPriority,
    required this.completed,
    required this.critical,
    required this.timeStamp,
  }

  );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      date: json['date'] as String,
      group: json['group'] as String,
      time: json['time'] as String,
      description: json['description'] as String,
      action: json['action taken'] as String,
      user: json['user'] as String,
      colorPriority: json['colorPriority'] as int,
      completed: json['completed'] as int,
      critical: json['critical'] as int,
      timeStamp: json['timeStamp'] as Timestamp,
    );

  }
}