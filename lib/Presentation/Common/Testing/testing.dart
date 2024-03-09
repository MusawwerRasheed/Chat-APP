import 'package:flutter/material.dart';

void main() => runApp(MyApp1());

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple Positioned Example'),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 100,
              left: 50,
              child: Container(
                width: 150,
                height: 150,
                color: Colors.blue,
              ),
            ),
             
          ],
        ),
      ),
    );
  }
}
