import 'package:path_finder/Model/board.dart';
import 'package:path_finder/Model/node.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MazePrim {
  @required
  Board board;
  Set<Node> frontierNodes;
  List<List<int>> directions;
  List<List<int>> immediateDirections;

  MazePrim(this.board) {
    frontierNodes = Set<Node>();
    directions = [
      [0, -2],
      [0, 2],
      [2, 0],
      [-2, 0]
    ];
    immediateDirections = [
      [0, -1],
      [0, 1],
      [1, 0],
      [-1, 0]
    ];
  }

  Future<void> startMazeGenaration() async {
    print("Kruskal maze");
    // Fill the grid with walls
    _fillWalls();

    // Pick a random node
    Node startNode = _getFirstRandomNode();
    startNode.setWall(false);
    // Add frontiers nodes of start node
    frontierNodes.addAll(_frontierNodesOf(startNode));
    Random rng = Random();

    while (frontierNodes.isNotEmpty) {
      //Pick random node from frontier nodes
      Node frontierNode =
          frontierNodes.elementAt(rng.nextInt(frontierNodes.length));

      //Get its neighbors: cells in distance 2 in state path (no wall)
      List<Node> frontierNeighbors = _passagesNodesOf(frontierNode);

      if (frontierNeighbors.isNotEmpty) {
        //Pick a random neighbor
        Node neighbor =
            frontierNeighbors.removeAt(rng.nextInt(frontierNeighbors.length));
        // connect both nodes
        await Future.delayed(Duration(milliseconds: board.speedMaze)).then((_) {
          _connectNodes(frontierNode, neighbor);
        });
      }
      //Compute the frontier nodes of the chosen node cell and add them to the frontier list
      frontierNodes.addAll(_frontierNodesOf(frontierNode));
      frontierNodes.remove(frontierNode);
    }
    // If start and finish not defined as wall at start of generation it will bug the maze
    board.finish.setWall(false);
    board.start.setWall(false);

    //Unlock start and finish
    _unlockNode(board.start);
    _unlockNode(board.finish);
  }

  // Check if node is blocked by 4 walls and then remove one random wall
  _unlockNode(Node node) {
    List<Node> frontier = List<Node>();
    int nWalls = 0;
    for (List<int> direction in immediateDirections..shuffle()) {
      int newX = node.x + direction[0];
      int newY = node.y + direction[1];
      if (_isValidPosition(newX, newY) && board.grid[newX][newY].isWall) {
        nWalls++;
        if (nWalls >= 4) {
          board.grid[newX][newY].setWall(false);
        }
      }
    }
  }

  List<Node> _immediateFrontiersOf(Node node) {
    List<Node> frontier = List<Node>();
    for (List<int> direction in immediateDirections) {
      int newX = node.x + direction[0];
      int newY = node.y + direction[1];
      if (_isValidPosition(newX, newY) && board.grid[newX][newY].isWall) {
        frontier.add(board.grid[newX][newY]);
      }
    }
    return frontier;
  }

  _connectNodes(Node node, Node anotherNode) {
    int xBetweenNodes = ((node.x + anotherNode.x) ~/ 2);
    int yBetweenNodes = ((node.y + anotherNode.y) ~/ 2);
    Node wallBetween = board.grid[xBetweenNodes][yBetweenNodes];
    node.setWall(false);
    wallBetween.setWall(false);
    anotherNode.setWall(false);
  }

  // get a node to start maze
  Node _getFirstRandomNode() {
    final rng = new Random();
    Node node =
        board.grid[rng.nextInt(board.rowCount)][rng.nextInt(board.columnCount)];
    while (node.isFinish && node.isStart) {
      node = board.grid[rng.nextInt(board.rowCount)]
          [rng.nextInt(board.columnCount)];
    }
    return node;
  }

  //Frontier nodes: wall nodes in a distance of 2
  List<Node> _frontierNodesOf(Node node) {
    List<Node> frontier = List<Node>();
    for (List<int> direction in directions) {
      int newX = node.x + direction[0];
      int newY = node.y + direction[1];
      if (_isValidPosition(newX, newY) && board.grid[newX][newY].isWall) {
        frontier.add(board.grid[newX][newY]);
      }
    }
    return frontier;
  }

  //Frontier nodes: passage (no wall) cells in a distance of 2
  List<Node> _passagesNodesOf(Node node) {
    List<Node> frontier = List<Node>();
    for (List<int> direction in directions) {
      int newX = node.x + direction[0];
      int newY = node.y + direction[1];
      if (_isValidPosition(newX, newY) && !board.grid[newX][newY].isWall) {
        frontier.add(board.grid[newX][newY]);
      }
    }
    return frontier;
  }

  _isValidPosition(int x, int y) {
    return (x < board.rowCount && x >= 0 && y < board.columnCount && y >= 0);
  }

  // Fill the entire grid with walls and return the set of sets for each cell
  _fillWalls() {
    for (List<Node> rows in board.grid) {
      for (Node node in rows) {
        node.setWall(true);
        board.walls.add(node);
      }
    }
  }
}
