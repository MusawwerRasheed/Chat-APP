import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  ValueNotifier<int> val = ValueNotifier(3);

  @override
  void initState() {
    super.initState();
    // Using a Timer to delay the print message
    Timer(Duration(seconds: 2), () {
      printMessage();
    });
  }

  void printMessage() {
    print("Hello from initState!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Testing Widget',
              style: TextStyle(fontSize: 20),
            ),
            ValueListenableBuilder<int>(
              valueListenable: val,
              builder: (context, value, child) {
                return Text(
                  'Value: $value',
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
