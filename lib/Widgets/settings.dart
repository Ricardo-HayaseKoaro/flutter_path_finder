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
  double _speed;

  @override
  void initState() {
    super.initState();
    _speed = widget.board.speed.roundToDouble();
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
                  "Speed",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Align(
            //       alignment: Alignment.centerLeft,
            //       child: Text(
            //         "Speed",
            //         style: TextStyle(
            //             color: Colors.white, fontWeight: FontWeight.bold),
            //       )),
            // ),
            Slider(
              value: _speed,
              onChanged: (value) {
                setState(() {
                  _speed = value;
                  widget.board.speed = value.toInt();
                });
              },
              label: _speed.round().toString() + " ms",
              activeColor: Color(0xFF5900b3),
              divisions: 10,
              min: 0,
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
