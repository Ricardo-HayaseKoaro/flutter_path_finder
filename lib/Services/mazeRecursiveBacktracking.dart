import 'package:path_finder/Model/board.dart';
import 'package:path_finder/Model/node.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MazeRecursiveBacktracking {
  @required
  Board board;

  MazeRecursiveBacktracking(this.board);

  Future<void> startMazeGenaration() async {
    print("Recursive backtracking maze");
    _fillWalls();
    Node node = _getFirstRandomNode();
    await _auxRecursiveBacktracking(node).then((_) {
      // Check if finish or start node is blocked by walls
      _checkBlocked(board.start);
      _checkBlocked(board.finish);
    });
  }

  _checkBlocked(Node node) {
    List<Map<String, Node>> neighbors = _getNeighbors(node)..shuffle();
    bool blocked = true;
    for (Map<String, Node> neighbor in neighbors) {
      // if therei is at least one node that is node a wall then is not blocked
      blocked = blocked && neighbor["wall"].isWall;
    }
    if (blocked) {
      Node aux = neighbors.last["wall"];
      aux.setWall(false);
    }
  }

  Future<void> _auxRecursiveBacktracking(Node node) async {
    node.setWall(false);
    node.mazeVisited = true;
    Node adjacentNode = _getRandomAdjacentNode(node);
    while (adjacentNode != null) {
      await Future.delayed(Duration(milliseconds: board.speedMaze))
          .then((_) async {
        await _auxRecursiveBacktracking(adjacentNode);
        adjacentNode = _getRandomAdjacentNode(node);
      });
    }
  }

  // get a random node, from one of the 4 directions
  Node _getRandomAdjacentNode(Node node) {
    List<Map<String, Node>> neighbors = _getNeighbors(node)..shuffle();
    while (neighbors.isNotEmpty) {
      Node adjacentNode = neighbors.last["node"];
      Node wall = neighbors.last["wall"];
      // carve wall between them
      if (!adjacentNode.mazeVisited) {
        wall.mazeVisited = true;
        wall.setWall(false);
        return adjacentNode;
      } else
        neighbors.removeLast();
    }
    return null;
  }

  // fill the entire grid with walls
  void _fillWalls() {
    for (List<Node> rows in board.grid) {
      for (Node node in rows) {
        if (!node.isFinish && !node.isStart) {
          node.setWall(true);
          board.walls.add(node);
        }
      }
    }
  }

  // get a node to start maze
  Node _getFirstRandomNode() {
    final rng = new Random();
    return board.grid[rng.nextInt(board.rowCount)]
        [rng.nextInt(board.columnCount)];
  }

  List<Map<String, Node>> _getNeighbors(node) {
    int x = node.x;
    int y = node.y;

    List<Map<String, Node>> neighbors = List<Map<String, Node>>();
    // Map will store the neighbors wich is 2 blocks from node, and the wall between them

    if (x - 2 >= 0) {
      Map<String, Node> map = Map<String, Node>();
      map["wall"] = board.grid[x - 1][y];
      map["node"] = board.grid[x - 2][y];
      neighbors.add(map);
    }
    if (x + 2 < board.rowCount) {
      Map<String, Node> map = Map<String, Node>();
      map["wall"] = board.grid[x + 1][y];
      map["node"] = board.grid[x + 2][y];
      neighbors.add(map);
    }
    if (y - 2 >= 0) {
      Map<String, Node> map = Map<String, Node>();
      map["wall"] = board.grid[x][y - 1];
      map["node"] = board.grid[x][y - 2];
      neighbors.add(map);
    }
    if (y + 2 < board.columnCount) {
      Map<String, Node> map = Map<String, Node>();
      map["wall"] = board.grid[x][y + 1];
      map["node"] = board.grid[x][y + 2];
      neighbors.add(map);
    }
    return neighbors;
  }
}
