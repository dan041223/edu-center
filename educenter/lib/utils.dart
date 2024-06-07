import 'dart:ui';

import 'package:flutter/material.dart';

class Utils {
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  static String capitalize(String texto) {
    return "${texto[0].toUpperCase()}${texto.substring(1).toLowerCase()}";
  }

  static String tipoIncidenciaToString(String tipoIncidencia) {
    switch (tipoIncidencia) {
      case "expulsion":
        return "expulsión";
      case "falta_asistencia":
        return "falta de asistencia";
      case "falta_grave":
        return "falta grave";
      default:
        return "incidencia";
    }
  }

  static TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    if (parts.length < 2) {
      throw FormatException('Invalid time format', timeString);
    }
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String timeOfDayToString(String timeOfDayString) {
    return timeOfDayString.split("(").last.split(")").first;
  }

  static String formatTimeString(String timeString) {
    // Extrae las horas y los minutos de la cadena
    final parts = timeString.split(':');
    if (parts.length < 2) {
      throw FormatException('Invalid time format', timeString);
    }
    final hour = parts[0];
    final minute = parts[1];

    // Devuelve la cadena en formato HH:mm
    return '$hour:$minute';
  }

  static String stringToTipoIncidencia(String tipoString) {
    switch (tipoString) {
      case "Expulsión":
        return "expulsion";
      case "Falta de asistencia":
        return "falta_asistencia";
      default:
        return "falta_grave";
    }
  }

  static List<String> diasSemana = [
    "lunes",
    "martes",
    "miercoles",
    "jueves",
    "viernes"
  ];

  static List<String> horasSemanaIniciales = [
    "08:00:00",
    "09:00:00",
    "10:00:00",
    "11:00:00",
    "12:00:00",
    "13:00:00"
  ];

  static List<String> horasSemanaFinales = [
    "09:00:00",
    "10:00:00",
    "11:00:00",
    "12:00:00",
    "13:00:00",
    "14:00:00"
  ];

  static List<String> tiposIncidencia = [
    "Expulsión",
    "Falta de asistencia",
    "Falta grave"
  ];
}
