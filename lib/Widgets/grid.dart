import 'package:flutter/material.dart';
import 'package:path_finder/Model/addMode.dart';
import 'package:path_finder/Model/board.dart';
import 'package:path_finder/Widgets/gridSquare.dart';
import 'package:provider/provider.dart';

class Grid extends StatefulWidget {
  Grid({Key key}) : super(key: key);

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  Board board;

  //Controller for scrolls
  ScrollController _scrollControllerVertical;
  ScrollController _scrollControllerHorizontal;

  @override
  void initState() {
    super.initState();
    board = context.read<Board>();
    //Create default position for scrolls
    _scrollControllerVertical = new ScrollController();
    _scrollControllerHorizontal = new ScrollController();
    board.initialiseBoard();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollControllerHorizontal
          .jumpTo(_scrollControllerHorizontal.position.maxScrollExtent / 2);
      _scrollControllerVertical
          .jumpTo(_scrollControllerVertical.position.maxScrollExtent / 2);
    });

    return InteractiveViewer(
      minScale: 0.1,
      maxScale: 3.0,
      child: Container(
        child: SingleChildScrollView(
          controller: _scrollControllerHorizontal,
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            controller: _scrollControllerVertical,
            child: Row(
              children: List.generate(
                board.rowCount,
                (i) => Column(
                  children: List.generate(
                    board.columnCount,
                    (j) => GestureDetector(
                      child: GridSquare(
                        node: board.grid[i][j],
                        i: i,
                        j: j,
                        setStart: board.setStart,
                        setFinish: board.setFinish,
                      ),
                      onTap: () {
                        final String mode = context.read<AddModel>().addMode;
                        switch (mode) {
                          case "wall":
                            if (!board.grid[i][j].isFinish &&
                                !board.grid[i][j].isStart) {
                              board.grid[i][j].changeWall();
                              board.walls.add(board.grid[i][j]);
                              break;
                            }
                        }
                      },
                      onLongPress: () {
                        if (!board.isRunning) board.clearBoard();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
