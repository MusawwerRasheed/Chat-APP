import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            color: Colors.red,
            height: 400,
          ),
          Container(
            height: 200,
            color: Colors.green,
            child: Expanded(
                child: Column(
              children: [
                Container(
                  height: 200,
                  color: Colors.orange,
                ),
                Container(height: 200, color: Colors.blue,),
                Container(height: 200, color: Colors.black,),
                
              ],
            )),
          ),
        ],
      ),
    );
  }
}
