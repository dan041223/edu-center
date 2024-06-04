import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget fechaXS(String fecha, Color color) {
  return Column(
    children: [
      Icon(Icons.calendar_month, color: color),
      Text(
        fecha.split(" ").first,
        style: TextStyle(color: color),
      )
    ],
  );
}
