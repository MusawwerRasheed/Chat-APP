import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
 
 

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> suggestions = [
    "Apple",
    "Banana",
    "Cherry",
    "Date",
    "Elderberry",
    "Fig",
    "Grape",
    "Honeydew",
    "Mango",
    "Nectarine",
    "Orange",
    "Peach",
    "Pear",
    "Quince",
    "Raspberry",
    "Strawberry",
    "Tangerine",
    "Watermelon",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: TypeAheadField<String>(
          // Ensure 'onSuggestionSelected' is included
           
          itemBuilder: (context, suggestion) => ListTile(
            title: Text(suggestion),
          ),
          suggestionsCallback: (pattern) {
            List<String> matches = [];
            for (var item in suggestions) {
              if (item.toLowerCase().startsWith(pattern.toLowerCase())) {
                matches.add(item);
              }
            }
            return matches;
          }, onSelected: (String value) {  },
        ),
      ),
    );
  }
}
