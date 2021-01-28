import 'package:flutter/material.dart';
import 'package:path_finder/Model/board.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends AppBar {
  CustomAppBar(BuildContext context)
      : super(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Path Finder",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: Consumer<Board>(builder: (context, board, child) {
                return IconButton(
                  icon: Icon(
                    board.isFinished ? Icons.replay : Icons.play_arrow,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    board.startPathFinding();
                  },
                );
              }),
            ),
          ],
        );
}
