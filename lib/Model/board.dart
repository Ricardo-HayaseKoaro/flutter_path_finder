import 'package:flutter/material.dart';
import 'package:path_finder/Model/node.dart';
import 'package:path_finder/Services/aStar.dart';
import 'package:path_finder/Services/bfs.dart';
import 'package:path_finder/Services/dijkstra.dart';
import 'package:path_finder/Services/mazePrim.dart';
import 'package:path_finder/Services/mazeRecursiveBacktracking.dart';
import 'package:path_finder/Services/mazeRecursiveDivision.dart';

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

  //Weights in the grid
  List<Node> weights;

  // Default value of weight
  int weightValue;

  // Start and finish squates
  Node start;
  Node finish;

  // Algorythms for path finding
  BFS bfs;
  Dijkstra dijkstra;
  AStar aStar;

  // Algorythms for maze generation
  MazeRecursiveBacktracking mazeRecursiveBacktracking;
  MazePrim mazePrim;
  MazeRecursiveDivision mazeRecursiveDivision;

  Board() {
    this.rowCount = 11;
    this.columnCount = 11;
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
    this.weights = List<Node>();
    this.weightValue = 15;
    this.bfs = BFS(this);
    this.dijkstra = Dijkstra(this);
    this.aStar = AStar(this);
    this.mazeRecursiveBacktracking = MazeRecursiveBacktracking(this);
    this.mazePrim = MazePrim(this);
    this.mazeRecursiveDivision = MazeRecursiveDivision(this);
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
      node.clear();
    }
    visitedNodes.clear();
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
    for (var node in weights) {
      node.fullClear();
    }
    visitedNodes.clear();
    walls.clear();
    mazeVisitedNodes.clear();
    weights.clear();
    this.isFinished = false;
    notifyListeners();
  }

  void startPathFindingAgain() {
    this.clearVisitedNodes();
    this.isFinished = false;

    //Disable run button
    this.isRunning = true;
    notifyListeners();

    aStar.start().then((_) {
      print("end");
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
    aStar.start().then((_) {
      print("end");
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

      mazeRecursiveDivision.startMazeGenaration().then((_) {
        this.isRunning = false;
        notifyListeners();
      });
    }
  }
}
