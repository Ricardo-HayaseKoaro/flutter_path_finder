import 'package:flutter/material.dart';
import 'package:path_finder/Model/play.dart';
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
              child: Consumer<Play>(builder: (context, play, child) {
                return IconButton(
                  icon: Icon(
                    play.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    play.changeState();
                  },
                );
              }),
            ),
          ],
        );
}
