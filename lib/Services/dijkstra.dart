import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:path_finder/Model/board.dart';
import 'package:path_finder/Model/node.dart';
import 'package:flutter/material.dart';

class Dijkstra {
  @required
  Board board;
  List<List<int>> directions;

  Dijkstra(this.board) {
    directions = [
      [0, -1],
      [0, 1],
      [1, 0],
      [-1, 0]
    ];
  }

  Future<void> start() async {
    print("Dijkstra");
    await _dijkstraAux(board.start).then((predecessors) async {
      if (predecessors != null) await _showPath(predecessors);
    });
  }

  _showPath(predecessors) async {
    // Create shortes path in grid
    if (board.finish != null) {
      Node aux = predecessors[board.finish];
      while (aux != null) {
        if (!board.isFinished)
          await Future.delayed(Duration(milliseconds: board.speedPath));
        if (aux != board.finish && aux != board.start) {
          aux.setPath();
        }
        aux = predecessors[aux];
      }
    }
  }

  int _minHeapComparison(Node node, Node anotherNode) {
    if (node.distance < anotherNode.distance)
      return -1;
    else if (node.distance > anotherNode.distance)
      return 1;
    else
      return 0;
  }

  Future<HashMap<Node, Node>> _dijkstraAux(Node node) async {
    List<Node> visited = board.visitedNodes;

    HashMap<Node, Node> predecessor = HashMap();

    HeapPriorityQueue<Node> heapPriorityQueue =
        HeapPriorityQueue(_minHeapComparison);

    // Define distance from start node as 0
    node.distance = 0;
    predecessor[node] = null;
    visited.add(node);
    node.setVisited();
    heapPriorityQueue.add(node);

    while (heapPriorityQueue.isNotEmpty) {
      // Get root from min heap
      node = heapPriorityQueue.removeFirst();

      if (node.isFinish) {
        node.setVisited();
        visited.add(node);
        return predecessor;
      }

      // Get neighbors
      List<Node> neighbors = _getNeighbors(node);

      // Define distance of neighbors and add to heap
      if (neighbors.isNotEmpty) {
        for (Node neighbor in neighbors) {
          visited.add(neighbor);
          double distance = node.distance + neighbor.weight + 1;
          if (neighbor.distance > distance &&
              !neighbor.visited &&
              !neighbor.isWall) {
            neighbor.distance = distance;
            // Add node as his parent
            predecessor[neighbor] = node;
            heapPriorityQueue.add(neighbor);
          }
        }
      }
      node.setVisited();
    }
    return null;
  }

  List<Node> _getNeighbors(node) {
    List<Node> neighbors = List<Node>();

    for (List<int> direction in directions) {
      int x = node.x + direction[0];
      int y = node.y + direction[1];
      if (_isValidPosition(x, y)) {
        neighbors.add(board.grid[x][y]);
      }
    }
    return neighbors;
  }

  _isValidPosition(int x, int y) {
    return (x < board.rowCount && x >= 0 && y < board.columnCount && y >= 0);
  }
}
