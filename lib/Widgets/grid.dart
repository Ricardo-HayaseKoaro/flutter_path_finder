import 'package:flutter/material.dart';
import 'package:path_finder/Model/addMode.dart';
import 'package:path_finder/Model/node.dart';
import 'package:path_finder/Model/play.dart';
import 'package:path_finder/Widgets/gridSquare.dart';
import 'package:provider/provider.dart';
import 'dart:collection';

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

  //List of visited (used to clear the visited nodes), not used in the algorithm
  List<Node> visitedClearAux;

  // Walls in the grid
  List<Node> walls;

  // Start and finish squates
  Node start;
  Node finish;

  @override
  void initState() {
    super.initState();
    context.read<Play>().addListener(() {
      if (context.read<Play>().isPlaying) {
        _bfs();
      } else {}
    });
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

  void _bfs() {
    print("BFS");
    if (start == null) {
      print("start null");
      return;
    }
    if (finish == null) {
      print("finish null");
      return;
    }
    bfsAux(start).then((finishNode) async {
      await Future.delayed(Duration(milliseconds: 400));
      _bfsShortestPath(finishNode);
    });
  }

  Future<Node> bfsAux(Node node) async {
    // Clear visited nodes
    _clearVisitedNodes();

    //Create queueu and add start node
    Queue queue = Queue();
    queue.add(node);
    node.setVisited(0);

    while (queue.isNotEmpty) {
      //Pop
      Node auxNode = queue.removeFirst();

      // Get all adjacent vertices of the
      // dequeued vertex s. If a adjacent
      // has not been visited, then mark it
      // visited and enqueue it
      for (Node item in _getNeighbors(auxNode)) {
        if (!item.visited && !item.isWall) {
          if (item.isFinish) {
            return item;
          }
          queue.add(item);
          visitedClearAux.add(item);
          await Future.delayed(Duration(microseconds: 1500));
          item.setVisited(auxNode.val + 1);
        }
      }
    }
  }

  List<Node> _getNeighbors(node) {
    int x = node.x;
    int y = node.y;

    List<Node> neighbors = List<Node>();

    if (x - 1 >= 0) {
      neighbors.add(board[x - 1][y]);
    }
    if (x + 1 < rowCount) {
      neighbors.add(board[x + 1][y]);
    }
    if (y - 1 >= 0) {
      neighbors.add(board[x][y - 1]);
    }
    if (y + 1 < columnCount) {
      neighbors.add(board[x][y + 1]);
    }
    return neighbors;
  }

  //Find the shortest path from finish node to start node
  void _bfsShortestPath(Node node) async {
    //Check if could find the finish node
    if (node == null) {
      print("Coulnd find the shortest path");
      return;
    }

    // Base case
    if (node.isStart) {
      return;
    }

    //Search node with the min value
    Node minNode;
    for (Node item in _getNeighbors(node)) {
      if (item.visited) {
        // Needs to be visited
        if (minNode == null) {
          minNode = item;
        } else {
          if (item.val < minNode.val) minNode = item;
        }
      }
    }
    await Future.delayed(Duration(microseconds: 1500));
    minNode.setPath();
    _bfsShortestPath(minNode);
  }

  void _initialiseBoard() {
    board = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        return Node(x: i, y: j);
      });
    });
    walls = List();
    visitedClearAux = List();
  }

  setStart(Node node) {
    this.start = node;
  }

  setFinish(Node node) {
    this.finish = node;
  }

  void _clearVisitedNodes() {
    for (var node in visitedClearAux) {
      if (!node.isStart && !node.isFinish) node.clear();
    }
  }

  void clearBoard() {
    for (var node in walls) {
      node.fullClear();
    }
    for (var node in visitedClearAux) {
      node.fullClear();
    }
  }
}
