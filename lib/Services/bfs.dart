import 'dart:collection';
import 'package:path_finder/Model/board.dart';
import 'package:path_finder/Model/node.dart';
import 'package:flutter/material.dart';

class BFS {
  @required
  Board board;

  BFS(this.board);

  void startBFS() {
    print("BFS");
    if (board.start == null) {
      print("start null");
      return;
    }
    if (board.finish == null) {
      print("finish null");
      return;
    }
    _bfsAux(board.start).then((finishNode) async {
      await Future.delayed(Duration(milliseconds: 400));
      _bfsShortestPath(finishNode);
    });
  }

  Future<Node> _bfsAux(Node node) async {
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
          board.visitedNodes.add(item);
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
      neighbors.add(board.grid[x - 1][y]);
    }
    if (x + 1 < board.rowCount) {
      neighbors.add(board.grid[x + 1][y]);
    }
    if (y - 1 >= 0) {
      neighbors.add(board.grid[x][y - 1]);
    }
    if (y + 1 < board.columnCount) {
      neighbors.add(board.grid[x][y + 1]);
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
}
