import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String task;
  bool isComplete;
  String taskuid;
  Timestamp timestamp;
  Task({this.task, this.isComplete, this.taskuid, this.timestamp});
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        task: json['task'],
        isComplete: json['isComplete'],
        timestamp: json['timestamp']);
  }
}
