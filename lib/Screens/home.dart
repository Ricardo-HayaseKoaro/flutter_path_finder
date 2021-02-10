import 'package:flutter/material.dart';
import 'package:path_finder/Model/addMode.dart';
import 'package:path_finder/Model/board.dart';
import 'package:path_finder/Widgets/customFAB.dart';
import 'package:path_finder/Widgets/navigationBar.dart';
import 'package:provider/provider.dart';
import '../Widgets/grid.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AddModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => Board(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xFF000066),
        appBar: AppBar(
          title: Text("Path Finder"),
        ),
        body: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Grid(),
            ],
          ),
        ),
        floatingActionButton: CustomFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: CustomNavigationBar(),
      ),
    );
  }
}
