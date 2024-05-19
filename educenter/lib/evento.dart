import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EventoPanel extends StatefulWidget {
  const EventoPanel({super.key});

  @override
  State<EventoPanel> createState() => _EventoPanelState();
}

class _EventoPanelState extends State<EventoPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Evento"),
      ),
    );
  }
}
