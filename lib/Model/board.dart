import 'package:flutter/material.dart';
import 'package:path_finder/Enums/mazeAlgorithm.dart';
import 'package:path_finder/Enums/searchAlgorithm.dart';
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

  // Selected algorithms
  SearchAlgorithm selectedSearchAlgorithm;
  MazeAlgorithm selectedMazeAlgorithm;

  // Algorithms for path finding
  BFS bfs;
  Dijkstra dijkstra;
  AStar aStar;

  // Algorithms for maze generation
  MazeRecursiveBacktracking mazeRecursiveBacktracking;
  MazePrim mazePrim;
  MazeRecursiveDivision mazeRecursiveDivision;

  Board() {
    this.rowCount = 31;
    this.columnCount = 21;
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
    this.selectedMazeAlgorithm = MazeAlgorithm.RecursiveBacktracking;
    this.selectedSearchAlgorithm = SearchAlgorithm.Dijkstra;
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

  // Used ontap of button retry (dont render instantnously)
  void startPathFindingAgain() {
    this.clearVisitedNodes();
    this.isFinished = false;
    //Disable run button
    this.isRunning = true;
    notifyListeners();
    switch (selectedSearchAlgorithm) {
      case SearchAlgorithm.Dijkstra:
        {
          dijkstra.start().then((_) {
            print("end");
            this.isFinished = true;
            this.isRunning = false;
            notifyListeners();
          });
          break;
        }
      case SearchAlgorithm.BFS:
        {
          bfs.start().then((_) {
            print("end");
            this.isFinished = true;
            this.isRunning = false;
            notifyListeners();
          });
          break;
        }
      case SearchAlgorithm.AStar:
        {
          aStar.start().then((_) {
            print("end");
            this.isFinished = true;
            this.isRunning = false;
            notifyListeners();
          });
          break;
        }
    }
  }

  startPathFinding() {
    //Disable run button
    this.isRunning = true;
    notifyListeners();
    this.clearVisitedNodes();

    switch (selectedSearchAlgorithm) {
      case SearchAlgorithm.Dijkstra:
        {
          dijkstra.start().then((_) {
            print("end");
            this.isFinished = true;
            this.isRunning = false;
            notifyListeners();
          });
          break;
        }
      case SearchAlgorithm.BFS:
        {
          bfs.start().then((_) {
            print("end");
            this.isFinished = true;
            this.isRunning = false;
            notifyListeners();
          });
          break;
        }
      case SearchAlgorithm.AStar:
        {
          aStar.start().then((_) {
            print("end");
            this.isFinished = true;
            this.isRunning = false;
            notifyListeners();
          });
          break;
        }
    }
  }

  startMazeGeneration() {
    if (!this.isRunning) {
      //Disable run button
      this.isRunning = true;
      notifyListeners();

      this.clearBoard();

      switch (selectedMazeAlgorithm) {
        case MazeAlgorithm.RecursiveBacktracking:
          {
            mazeRecursiveBacktracking.startMazeGenaration().then((_) {
              this.isRunning = false;
              notifyListeners();
            });
            break;
          }
        case MazeAlgorithm.Prim:
          {
            mazePrim.startMazeGenaration().then((_) {
              this.isRunning = false;
              notifyListeners();
            });
            break;
          }
      }
    }
  }
}
