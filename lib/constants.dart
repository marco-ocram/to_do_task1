import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task.dart';

String formatDate(DateTime date) {
  String formattedDate = "${date.day}-${date.month}-${date.year}";
  return formattedDate;
}

//---ADDING A NEW TASK TO FIRESTORE
addTaskToDatabase(Task task) async {
  await FirebaseFirestore.instance.collection('tasks').add({
    'task': task.task,
    'isComplete': task.isComplete,
    'timestamp': task.timestamp
  });
}

completeTaskToDatabase(Task task) async {
  await FirebaseFirestore.instance
      .collection('tasks')
      .doc(task.taskuid)
      .update({
    'isComplete': task.isComplete,
  });
}

deleteTaskToDatabase(Task task) async {
  await FirebaseFirestore.instance
      .collection('tasks')
      .doc(task.taskuid)
      .delete()
      .then((value) => print("DELETED"));
}

editTasktoDatabase(Task task) async {
  await FirebaseFirestore.instance
      .collection('tasks')
      .doc(task.taskuid)
      .update({
    'task': task.task,
    'isComplete': task.isComplete,
  });
}

List<Task> getListOfTasks(QuerySnapshot res, DateTime date) {
  List<Task> lisOTasks = [];
  DateTime presentDate = DateTime(date.year, date.month, date.day);
  print(res);
  for (var doc in res.docs) {
    print(doc.data());
    print("DATA");
    Task task = Task.fromJson(doc.data());
    task.taskuid = doc.id;
    print(task.taskuid);
    print(date);
    print(task.timestamp.toDate());
    if (date.compareTo(task.timestamp.toDate()) == 0) lisOTasks.add(task);
  }
  return lisOTasks;
}
