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
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.code,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Text(
                "BFS Algorythm",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Consumer<Board>(builder: (context, board, child) {
                return IconButton(
                  icon: Icon(
                    board.isFinished ? Icons.replay : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    if (!board.isRunning) board.startPathFinding();
                  },
                );
              }),
            ),
          ],
        );
}
