import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:path_finder/Enums/searchAlgorithm.dart';
import 'package:path_finder/Icons/maze_icons.dart';
import 'package:path_finder/Model/addMode.dart';
import 'package:path_finder/Model/board.dart';
import 'package:provider/provider.dart';
import 'package:path_finder/Widgets/settings.dart';

import 'appLocalizations.dart';

class CustomNavigationBar extends StatefulWidget {
  CustomNavigationBar({Key key}) : super(key: key);

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  Board board;
  int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    this.board = context.read<Board>();
    this.board.addListener(() {
      if (this.board.selectedSearchAlgorithm == SearchAlgorithm.BFS) {
        setState(() {
          print('Wall Mode');
          context.read<AddModel>().setModeWall();
          currentIndex = 0;
        });
      } else {
        setState(() {});
      }
    });
  }

  void changePage(int index) {
    switch (index) {
      case 0:
        setState(() {
          print('Wall Mode');
          context.read<AddModel>().setModeWall();
          currentIndex = index;
        });
        break;
      case 1:
        if (this.board.selectedSearchAlgorithm != SearchAlgorithm.BFS) {
          setState(() {
            print('Weight Mode');
            context.read<AddModel>().setModeWeight();
            currentIndex = index;
          });
        } else {
          print("Weight not supported");
        }
        break;
      case 2:
        if (!context.read<Board>().isRunning) this.board.startMazeGeneration();
        break;
      case 3:
        _showModalBottomSheet(context);
        break;
    }
  }

  _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black,
            child: Settings(this.board),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BubbleBottomBar(
      hasNotch: true,
      fabLocation: BubbleBottomBarFabLocation.end,
      opacity: .2,
      backgroundColor: Theme.of(context).primaryColor,
      currentIndex: currentIndex,
      onTap: changePage,
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(
              16)), //border radius doesn't work when the notch is enabled.
      elevation: 8,
      items: <BubbleBottomBarItem>[
        BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.dashboard,
              color: Colors.white,
            ),
            activeIcon: Icon(
              Icons.dashboard,
              color: Color(0xFF00b38f),
            ),
            title: Text(
              AppLocalizations.of(context).translate('walls'),
              style: TextStyle(color: Colors.white),
            )),
        BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Maze.weight_icon,
              size: 20,
              color: context.read<Board>().selectedSearchAlgorithm ==
                      SearchAlgorithm.BFS
                  ? Colors.grey
                  : Colors.white,
            ),
            activeIcon: Icon(
              Maze.weight_icon,
              size: 20,
              color: Color(0xFF00b38f),
            ),
            title: Text(
              AppLocalizations.of(context).translate('weights'),
              style: TextStyle(color: Colors.white),
            )),
        BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Maze.maze_icon, color: Colors.white, size: 20),
            activeIcon: Icon(
              Maze.maze_icon,
              size: 20,
              color: Color(0xFF00b38f),
            ),
            title: Text(
              "Mazes",
              style: TextStyle(color: Colors.white),
            )),
        BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            activeIcon: Icon(
              Icons.settings,
              color: Color(0xFF00b38f),
            ),
            title: Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}
