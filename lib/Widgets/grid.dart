import 'package:flutter/material.dart';
import 'package:path_finder/Model/addMode.dart';
import 'package:path_finder/Model/node.dart';
import 'package:path_finder/Model/play.dart';
import 'package:path_finder/Services/bfs.dart';
import 'package:path_finder/Widgets/gridSquare.dart';
import 'package:provider/provider.dart';

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

  //List of visited (Used with visited property of node, the property is used to makes easier to check when rendering)
  List<Node> visitedNodes;

  // Walls in the grid
  List<Node> walls;

  // Start and finish squates
  Node start;
  Node finish;

  // Algorythms for path finding
  BFS bfs;

  //Controller for scrolls

  ScrollController _scrollControllerVertical;
  ScrollController _scrollControllerHorizontal;

  @override
  void initState() {
    super.initState();

    //Create default position for scrolls
    _scrollControllerVertical = new ScrollController();
    _scrollControllerHorizontal = new ScrollController();
    context.read<Play>().addListener(() {
      if (context.read<Play>().isPlaying) {
        _clearVisitedNodes();
        bfs = BFS(rowCount, columnCount, start, finish, board, visitedNodes);
        bfs.startBFS();
      } else {}
    });
    _initialiseBoard();
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
                rowCount,
                (i) => Column(
                  children: List.generate(
                    columnCount,
                    (j) => GestureDetector(
                      child: GridSquare(
                        node: board[i][j],
                        i: i,
                        j: j,
                        setStart: setStart,
                        setFinish: setFinish,
                      ),
                      onTap: () {
                        final String mode = context.read<AddModel>().addMode;
                        switch (mode) {
                          case "wall":
                            board[i][j].changeWall();
                            walls.add(board[i][j]);
                            break;
                          case "start":
                            if (start != null) start.setStart(false);
                            board[i][j].setStart(true);
                            start = board[i][j];
                            break;
                          case "finish":
                            if (finish != null) finish.setFinish(false);
                            board[i][j].setFinish(true);
                            finish = board[i][j];
                            break;
                        }
                      },
                      onLongPress: () {
                        clearBoard();
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
        if (i == (rowCount / 2) - 4 && j == (columnCount / 2)) {
          Node newNode = Node(x: i, y: j, isStart: true);
          start = newNode;
          return newNode;
        }
        if (i == (rowCount / 2) + 3 && j == (columnCount / 2)) {
          Node newNode = Node(x: i, y: j, isFinish: true);
          finish = newNode;
          return newNode;
        }
        return Node(x: i, y: j);
      });
    });
    walls = List();
    visitedNodes = List();
  }

  setStart(Node node) {
    this.start = node;
  }

  setFinish(Node node) {
    this.finish = node;
  }

  void _clearVisitedNodes() {
    for (var node in visitedNodes) {
      if (!node.isStart && !node.isFinish) node.clear();
    }
  }

  void clearBoard() {
    for (var node in walls) {
      node.fullClear();
    }
    for (var node in visitedNodes) {
      node.fullClear();
    }
  }
}
