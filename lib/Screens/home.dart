import 'package:flutter/material.dart';
import 'package:path_finder/Model/addMode.dart';
import 'package:path_finder/Model/board.dart';
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
        appBar: CustomAppBar(context),
        body: Stack(
          children: [
            Grid(),
            FAB(),
          ],
        ),
      ),
    );
  }
}
