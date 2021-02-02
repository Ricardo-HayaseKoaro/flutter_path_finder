import 'package:flutter/material.dart';
import 'package:path_finder/Model/board.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  Board board;
  Settings(this.board, {Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double _speedSearch;
  double _speedPath;
  double _speedMaze;
  double _speedAnimation;

  @override
  void initState() {
    super.initState();
    _speedSearch = widget.board.speedSearch.roundToDouble();
    _speedPath = widget.board.speedPath.roundToDouble();
    _speedMaze = widget.board.speedMaze.roundToDouble();
    _speedAnimation = widget.board.speedAnimation.roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Settings",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Delay Search",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Slider(
              value: _speedSearch,
              onChanged: (value) {
                setState(() {
                  _speedSearch = value;
                  widget.board.speedSearch = value.toInt();
                });
              },
              label: _speedSearch.round().toString() + " ms",
              activeColor: Color(0xFF5900b3),
              divisions: 5,
              min: 0,
              max: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Delay Path",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Slider(
              value: _speedPath,
              onChanged: (value) {
                setState(() {
                  _speedPath = value;
                  widget.board.speedPath = value.toInt();
                });
              },
              label: _speedPath.round().toString() + " ms",
              activeColor: Color(0xFF5900b3),
              divisions: 8,
              min: 0,
              max: 400,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Delay Maze",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Slider(
              value: _speedMaze,
              onChanged: (value) {
                setState(() {
                  _speedMaze = value;
                  widget.board.speedMaze = value.toInt();
                });
              },
              label: _speedMaze.round().toString() + " ms",
              activeColor: Color(0xFF5900b3),
              divisions: 10,
              min: 0,
              max: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Speed Animation",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Slider(
              value: _speedAnimation,
              onChanged: (value) {
                setState(() {
                  _speedAnimation = value;
                  widget.board.speedAnimation = value.toInt();
                });
              },
              label: _speedAnimation.round().toString() + " ms",
              activeColor: Color(0xFF5900b3),
              divisions: 10,
              min: 1,
              max: 1000,
            ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Padding(
            //     padding: const EdgeInsets.only(right: 30),
            //     child: RaisedButton.icon(
            //       icon: Icon(Icons.save),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(0),
            //           side: BorderSide(color: Color(0xFF5900b3))),
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //       },
            //       color: Color(0xFF5900b3),
            //       textColor: Colors.white,
            //       label: Text("save".toUpperCase(),
            //           style: TextStyle(fontSize: 14)),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
