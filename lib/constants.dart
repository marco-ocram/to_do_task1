import 'package:flutter/material.dart';

String formatDate(DateTime date) {
  String formattedDate = "${date.day}-${date.month}-${date.year}";
  return formattedDate;
}
