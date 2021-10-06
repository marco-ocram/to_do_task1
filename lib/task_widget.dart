import 'package:flutter/material.dart';
import 'package:to_do_task1/task.dart';

Widget taskWidget(Task currentTask, double height, double width) {
  return Card(
    elevation: currentTask.isComplete ? 0 : 10,
    color: currentTask.isComplete ? Colors.grey : Colors.greenAccent,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 2, vertical: height),
      child: Container(
          width: double.maxFinite,
          child: Text(
            currentTask.task,
            textAlign: TextAlign.center,
            style: TextStyle(
                decoration:
                    currentTask.isComplete ? TextDecoration.lineThrough : null),
          )),
    ),
  );
}
