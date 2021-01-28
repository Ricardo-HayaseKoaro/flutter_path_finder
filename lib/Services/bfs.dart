import 'dart:collection';
import 'package:path_finder/Model/board.dart';
import 'package:path_finder/Model/node.dart';
import 'package:flutter/material.dart';

class BFS {
  @required
  Board board;

  BFS(this.board);

  Future<void> startBFS() async {
    print("BFS");
    await _bfsAux(board.start).then((predecessors) {
      _showPath(predecessors);
    });
  }

  Future<void> _showPath(predecessors) {
    // Create shortes path in grid
    if (board.finish != null) {
      Node aux = predecessors[board.finish];
      while (aux != null) {
        if (aux != board.finish && aux != board.start) aux.setPath();
        aux = predecessors[aux];
      }
    }
  }

  Future<HashMap<Node, Node>> _bfsAux(Node node) async {
    List<Node> visited = board.visitedNodes;
    HashMap<Node, Node> predecessor = HashMap();

    //Create queueu and add start node
    Queue queue = Queue();
    queue.add(node);
    visited.add(node);
    node.setVisited();
    predecessor[node] = null;

    while (queue.isNotEmpty) {
      //Pop
      Node auxNode = queue.removeFirst();

      // Get all adjacent vertices of the
      // dequeued vertex s. If a adjacent
      // has not been visited, then mark it
      // visited and enqueue it
      for (Node item in _getNeighbors(auxNode)) {
        if (!item.visited && !item.isWall) {
          if (item == board.finish) {
            predecessor[item] = auxNode;
            return predecessor;
          }
          queue.add(item);
          visited.add(item);
          if (!board.isFinished)
            await Future.delayed(Duration(microseconds: 1500));
          item.setVisited();
          predecessor[item] = auxNode;
        }
      }
    }
    return null;
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
}
