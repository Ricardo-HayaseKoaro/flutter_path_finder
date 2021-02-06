import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:path_finder/Model/board.dart';
import 'package:path_finder/Model/node.dart';
import 'package:flutter/material.dart';

class AStar {
  @required
  Board board;
  List<List<int>> directions;

  AStar(this.board) {
    directions = [
      [0, -1],
      [0, 1],
      [1, 0],
      [-1, 0]
    ];
  }

  Future<void> start() async {
    print("A* Search");
    await _aStartAux(board.start).then((predecessors) async {
      if (predecessors != null) await _showPath(predecessors);
    });
  }

  _showPath(predecessors) async {
    // Create shortest path in grid
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

  Future<HashMap<Node, Node>> _aStartAux(Node node) async {
    // For node n, fScore[n] := gScore[n] + h(n). fScore[n] represents our current best guess as to
    // how short a path from start to finish can be if it goes through n.
    // gScore will be stored distance property of each node.
    Map<Node, double> fScore = Map<Node, double>();

    // The set of discovered nodes that may need to be (re-)expanded.
    // Initially, only the start node is known.
    HeapPriorityQueue<Node> openSet =
        HeapPriorityQueue((Node node, Node anotherNode) {
      if ((fScore[node] ?? double.infinity) <
          (fScore[anotherNode] ?? double.infinity))
        return -1;
      else if ((fScore[node] ?? double.infinity) >
          (fScore[anotherNode] ?? double.infinity))
        return 1;
      else
        return 0;
    });

    //User to clear nodes
    List<Node> visited = board.visitedNodes;

    // Used to find the sortest path after search is completed
    HashMap<Node, Node> predecessor = HashMap();

    // Define distance from start node as 0
    predecessor[node] = null;
    openSet.add(node);
    node.setVisited(); // For purposes of UI feedback
    node.distance = 0; // gScore
    fScore[node] = _calculateHeuristic(node);
    while (openSet.isNotEmpty) {
      if (!board.isFinished)
        await Future.delayed(Duration(milliseconds: board.speedSearch));

      // Get root from min heap
      node = openSet.removeFirst();
      visited.add(node);
      node.setVisited();

      // Cant use node.isfinish because it will bug the ui
      if (node == board.finish) {
        return predecessor;
      }

      // Get neighbors
      List<Node> neighbors = _getNeighbors(node);

      // Define distance of neighbors and add to heap
      if (neighbors.isNotEmpty) {
        for (Node neighbor in neighbors) {
          // Added to visited here so we can clear the distance after completed
          visited.add(neighbor);
          double gScoreAux = node.distance + neighbor.weight.toDouble();
          if (neighbor.distance > gScoreAux &&
              !neighbor.visited &&
              !neighbor.isWall) {
            neighbor.distance = gScoreAux;
            // Add node as his parent
            predecessor[neighbor] = node;
            fScore[neighbor] =
                neighbor.distance + _calculateHeuristic(neighbor);
            if (!openSet.contains(neighbor)) {
              openSet.add(neighbor);
            }
          }
        }
      }
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

  double _calculateHeuristic(Node node) {
    return ((node.x - board.finish.x).abs() + (node.y - board.finish.y).abs())
        .toDouble();
  }
}
