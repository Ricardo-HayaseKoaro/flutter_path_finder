import 'package:path_finder/Model/board.dart';
import 'package:path_finder/Model/node.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MazeKruskal {
  @required
  Board board;
  List<List<String>> sets;
  List<Node> walls;

  MazeKruskal(this.board) {
    this.sets = List.generate(
        board.rowCount, (i) => List.generate(board.columnCount, (j) => ("")));
    walls = List<Node>();
  }

  Future<void> startMazeGenaration() async {
    print("Kruskal maze");
    _fillWalls();
    walls.shuffle();
    while (walls.isNotEmpty) {
      Node wall = walls.removeLast();
      Map<String, Node> neighbors = _getNeighbors(wall);
      Node south = neighbors["s"];
      Node north = neighbors["n"];
      Node west = neighbors["w"];
      Node east = neighbors["e"];
      String setNorth;
      String setSouth;
      String setWest;
      String setEast;
      String setWall = sets[wall.x][wall.y];

      if (north != null) setNorth = sets[north.x][north.y];
      if (south != null) setSouth = sets[south.x][south.y];
      if (west != null) setWest = sets[west.x][west.y];
      if (east != null) setEast = sets[east.x][east.y];

      if (setNorth != setSouth) {
        if (north != null &&
            south != null &&
            !north.mazeVisited &&
            !south.mazeVisited) {
          wall.setWall(false);
          north.setWall(false);
          south.setWall(false);
          _visitNeighbors(wall);
          _visitNeighbors(north);
          _visitNeighbors(south);
          setSouth = setNorth;
          setWall = setNorth;
        }
      } else if (setWest != setEast) {
        if (east != null &&
            west != null &&
            !east.mazeVisited &&
            !west.mazeVisited) {
          wall.setWall(false);
          east.setWall(false);
          west.setWall(false);
          _visitNeighbors(wall);
          _visitNeighbors(east);
          _visitNeighbors(west);
          setEast = setWest;
          setWall = setWest;
        }
      }
    }
  }

  _visitNeighbors(Node node) {
    board.grid[node.x][node.y].mazeVisited = true;
    if (node.x + 1 < board.rowCount)
      board.grid[node.x + 1][node.y].mazeVisited = true;
    if (node.x - 1 >= 0) board.grid[node.x - 1][node.y].mazeVisited = true;
    if (node.y + 1 < board.columnCount)
      board.grid[node.x][node.y + 1].mazeVisited = true;
    if (node.y - 1 >= 0) board.grid[node.x][node.y - 1].mazeVisited = true;
  }

  Map<String, Node> _getNeighbors(Node node) {
    int x = node.x;
    int y = node.y;

    Map<String, Node> neighbors = Map<String, Node>();

    //get edges
    if (x - 1 >= 0) {
      Node vertice = board.grid[x - 1][y];
      neighbors["s"] = vertice; //south cell
    }
    if (x + 1 < board.rowCount) {
      Node vertice = board.grid[x + 1][y];
      neighbors["n"] = vertice; //north cell
    }
    if (y - 1 >= 0) {
      Node vertice = board.grid[x][y - 1];
      neighbors["w"] = vertice; //west cell
    }
    if (y + 1 < board.columnCount) {
      Node vertice = board.grid[x][y + 1];
      neighbors["e"] = vertice; //east cell
    }
    return neighbors;
  }

  // Fill the entire grid with walls and return the set of sets for each cell
  _fillWalls() {
    for (List<Node> rows in board.grid) {
      for (Node node in rows) {
        if (!node.isFinish && !node.isStart) {
          node.setWall(true);
          board.walls.add(node);
          sets[node.x][node.y] =
              "x" + node.x.toString() + "y" + node.y.toString();
          walls.add(node);
        }
      }
    }
  }
}

class Tree {
  Tree parent;

  Tree() {
    parent = null;
  }

  Tree _getRoot() {
    return this.parent != null ? parent._getRoot() : this;
  }

  _joinTree(Tree tree) {
    tree._getRoot().parent = this;
  }

  bool _isConnected(Tree tree) {
    if (this._getRoot() == null && tree._getRoot() == null) {
      return false;
    }
    return identical(this._getRoot(), tree._getRoot());
  }
}
