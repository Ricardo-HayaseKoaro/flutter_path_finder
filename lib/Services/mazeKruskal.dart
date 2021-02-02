import 'package:path_finder/Model/board.dart';
import 'package:path_finder/Model/node.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MazeKruskal {
  @required
  Board board;
  List<List<Tree>> sets;
  List<Map<String, Node>> listEdges;

  MazeKruskal(this.board) {
    this.sets = List.generate(board.rowCount,
        (i) => List.generate(board.columnCount, (j) => (Tree())));
    this.listEdges = List<Map<String, Node>>();
  }

  Future<void> startMazeGenaration() async {
    print("Kruskal maze");
    _fillWalls();
    listEdges.shuffle();
    while (listEdges.isNotEmpty) {
      // Get random edge
      Map<String, Node> randomEdge = listEdges.removeLast();
      Node nodeV1 = randomEdge["v1"];
      Node nodeV2 = randomEdge["v2"];
      Node wall = randomEdge["wall"];

      // Get each vertice his set
      Tree set1 = sets[nodeV1.x][nodeV1.y];
      Tree set2 = sets[nodeV2.x][nodeV2.y];
      Tree set3 = sets[wall.x][wall.y];

      if (!set1._isConnected(set2) &&
          !set3._isConnected(set2) &&
          !set3._isConnected(set1) &&
          !wall.mazeVisited &&
          !nodeV1.mazeVisited &&
          !nodeV2.mazeVisited) {
        //Connect both vertice
        nodeV1.setWall(false);
        nodeV2.setWall(false);
        wall.setWall(false);
        wall.mazeVisited = true;
        nodeV1.mazeVisited = true;
        nodeV2.mazeVisited = true;
        set1._joinTree(set2);
        set1._joinTree(set3);
      }
    }
  }

  //Return a list of maps that store edge vertice of node as key and wall between them as content of map
  _getEdges(Node node) {
    int x = node.x;
    int y = node.y;

    //get edges
    if (x - 2 >= 0) {
      Map<String, Node> map = Map<String, Node>();
      Node vertice = board.grid[x - 2][y];
      Node wall = board.grid[x - 1][y];
      map["v1"] = node;
      map["v2"] = vertice;
      map["wall"] = wall;
      listEdges.add(map);
    }
    if (x + 2 < board.rowCount) {
      Map<String, Node> map = Map<String, Node>();
      Node vertice = board.grid[x + 2][y];
      Node wall = board.grid[x + 1][y];
      map["v1"] = node;
      map["v2"] = vertice;
      map["wall"] = wall;
      listEdges.add(map);
    }
    if (y - 2 >= 0) {
      Map<String, Node> map = Map<String, Node>();
      Node vertice = board.grid[x][y - 2];
      Node wall = board.grid[x][y - 1];
      map["v1"] = node;
      map["v2"] = vertice;
      map["wall"] = wall;
      listEdges.add(map);
    }
    if (y + 2 < board.columnCount) {
      Map<String, Node> map = Map<String, Node>();
      Node vertice = board.grid[x][y + 2];
      Node wall = board.grid[x][y + 1];
      map["v1"] = node;
      map["v2"] = vertice;
      map["wall"] = wall;
      listEdges.add(map);
    }
    return listEdges;
  }

  // Fill the entire grid with walls and return the set of sets for each cell
  _fillWalls() {
    for (List<Node> rows in board.grid) {
      for (Node node in rows) {
        if (!node.isFinish && !node.isStart) {
          node.setWall(true);
          board.walls.add(node);
          sets[node.x][node.y] = Tree();
          _getEdges(node);
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
