import 'package:flutter/material.dart';
import 'package:path_finder/Model/node.dart';
import 'package:path_finder/Widgets/gridSquare.dart';

class Grid extends StatefulWidget {
  Grid({Key key}) : super(key: key);

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  int rowCount = 20;
  int columnCount = 30;

  // The board of squares
  List<List<Node>> board;

  // Walls in the grid
  List<Node> walls;

  // Start and finish squates
  Node start;
  Node finish;

  @override
  void initState() {
    super.initState();
    _initialiseBoard();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.1,
      maxScale: 3.0,
      child: Container(
        child: SingleChildScrollView(
          // physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            // physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: List.generate(
                rowCount,
                (i) => Column(
                  children: List.generate(
                    columnCount,
                    (j) => GestureDetector(
                      child: GridSquare(node: board[i][j], i: i, j: j),
                      onTap: () {
                        board[i][j].changeWall();
                        walls.add(board[i][j]);
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

  void _initialiseBoard() {
    board = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        return Node();
      });
    });
    walls = List();
  }

  void clearBoard() {
    for (var node in walls) {
      node.clear();
    }
    start.clear();
    finish.clear();
  }
}
