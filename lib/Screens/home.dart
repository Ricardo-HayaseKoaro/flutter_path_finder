import 'package:flutter/material.dart';
import 'package:path_finder/Widgets/circularButton.dart';
import '../Widgets/grid.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Path Finder"),
          actions: [
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.play_arrow,
              size: 40,
            ),
            SizedBox(
              width: 30,
            )
          ],
        ),
        body: Stack(
          children: [
            Grid(),
            FAB(),
          ],
        ));
  }
}
