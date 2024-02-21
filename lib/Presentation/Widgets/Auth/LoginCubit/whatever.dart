import 'package:flutter/material.dart';

class whatever extends StatefulWidget {
  const whatever({super.key});

  @override
  State<whatever> createState() => _whateverState();
}

class _whateverState extends State<whatever> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('something'),),);
  }
}