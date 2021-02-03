import 'package:flutter/material.dart';
import 'package:path_finder/Model/node.dart';
import 'package:path_finder/Services/bfs.dart';
import 'package:path_finder/Services/mazeKruskal.dart';
import 'package:path_finder/Services/mazeRecursiveBacktracking.dart';

class Board extends ChangeNotifier {
  // Grid size
  int rowCount;
  int columnCount;

  //Status (finished finding path)
  bool isFinished;
  bool isRunning;

  //Speed
  int speedSearch;
  int speedPath;
  int speedMaze;
  int speedAnimation;

  // The board of squares
  List<List<Node>> grid;

  //List of visited (Used with visited property of node, the property is used to makes easier to check when rendering)
  List<Node> visitedNodes;
  List<Node> mazeVisitedNodes;

  // Walls in the grid
  List<Node> walls;

  // Start and finish squates
  Node start;
  Node finish;

  // Algorythms for path finding
  BFS bfs;

  // Algorythms for maze generation
  MazeRecursiveBacktracking mazeRecursiveBacktracking;
  MazeKruskal mazeKruskal;

  Board() {
    this.rowCount = 10;
    this.columnCount = 10;
    this.isFinished = false;
    this.isRunning = false;
    this.speedSearch = 1;
    this.speedMaze = 10;
    this.speedPath = 50;
    this.speedAnimation = 400;
    this.grid = List<List<Node>>();
    this.visitedNodes = List<Node>();
    this.mazeVisitedNodes = List<Node>();
    this.walls = List<Node>();
    this.mazeRecursiveBacktracking = MazeRecursiveBacktracking(this);
    this.mazeKruskal = MazeKruskal(this);
  }

  void initialiseBoard() {
    grid = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        if (i == (rowCount ~/ 2) - 3 && j == (columnCount ~/ 2)) {
          Node newNode = Node(x: i, y: j, isStart: true);
          start = newNode;
          return newNode;
        }
        if (i == (rowCount ~/ 2) + 3 && j == (columnCount ~/ 2)) {
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

  // Used to pass to each square in grid when changing the location of finish and start
  setStart(Node node) {
    this.start = node;
  }

  setFinish(Node node) {
    this.finish = node;
  }

  void clearVisitedNodes() {
    for (var node in visitedNodes) {
      if (!node.isStart && !node.isFinish) node.clear();
    }
    notifyListeners();
  }

  void clearBoard() {
    for (var node in walls) {
      node.fullClear();
    }
    for (var node in visitedNodes) {
      node.fullClear();
    }
    for (var node in mazeVisitedNodes) {
      node.fullClear();
    }
    this.isFinished = false;
    notifyListeners();
  }

  void startPathFindingAgain() {
    this.clearVisitedNodes();
    this.isFinished = false;

    //Disable run button
    this.isRunning = true;
    notifyListeners();

    this.clearVisitedNodes();
    bfs = BFS(this);
    bfs.startBFS().then((_) {
      this.isFinished = true;
      this.isRunning = false;
      notifyListeners();
    });
  }

  startPathFinding() {
    //Disable run button
    this.isRunning = true;
    notifyListeners();

    this.clearVisitedNodes();
    bfs = BFS(this);
    bfs.startBFS().then((_) {
      this.isFinished = true;
      this.isRunning = false;
      notifyListeners();
    });
  }

  startMazeGeneration() {
    if (!this.isRunning) {
      //Disable run button
      this.isRunning = true;
      notifyListeners();

      this.clearBoard();

      mazeKruskal.startMazeGenaration().then((_) {
        this.isRunning = false;
        notifyListeners();
      });
    }
  }
}
