import 'package:flutter/material.dart';
import 'package:path_finder/Model/addMode.dart';
import 'package:path_finder/Model/play.dart';
import 'package:path_finder/Widgets/circularButton.dart';
import 'package:path_finder/Widgets/customAppBar.dart';
import 'package:provider/provider.dart';
import '../Widgets/grid.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Play(),
      child: Scaffold(
          appBar: CustomAppBar(context),
          body: ChangeNotifierProvider(
            create: (_) => AddModel(),
            child: Stack(
              children: [
                Grid(),
                FAB(),
              ],
            ),
          )),
    );
  }
}
