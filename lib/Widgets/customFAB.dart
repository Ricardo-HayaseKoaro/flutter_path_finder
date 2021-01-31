import 'package:flutter/material.dart';
import 'package:path_finder/Model/board.dart';
import 'package:provider/provider.dart';

class CustomFAB extends StatefulWidget {
  CustomFAB({Key key}) : super(key: key);

  @override
  _CustomFABState createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (!context.read<Board>().isRunning)
          context.read<Board>().startPathFinding();
      },
      child: context.watch<Board>().isFinished
          ? Icon(Icons.replay)
          : Icon(Icons.play_arrow),
      backgroundColor: Color(0xFF00b38f),
    );
  }
}
