import 'package:path_finder/Model/board.dart';
import 'package:flutter/material.dart';
import 'dart:math';

enum Orientation { VERTICAL, HORIZONTAL }

class MazeRecursiveDivision {
  @required
  Board board;

  MazeRecursiveDivision(this.board) {}

  Future<void> startMazeGenaration() async {
    print("Recursive division maze");

    await _divideGrid(0, 0, board.rowCount, board.columnCount);
  }

  Future<void> _divideGrid(int x, int y, int width, int height) async {
    if (width < 3 || height < 3) return;

    // Get best orientation
    bool isHorizontal =
        Orientation.HORIZONTAL == _getOrientation(width, height);

    // Define the wall
    Random rng = Random();
    int wallX = x + (isHorizontal ? 0 : rng.nextInt(width - 1));
    int wallY = y + (isHorizontal ? rng.nextInt(height - 1) : 0);

    // Define the passage
    int passaseX = wallX + (isHorizontal ? rng.nextInt(width) : 0);
    int passageY = wallY + (isHorizontal ? 0 : rng.nextInt(height));

    // Define orientation of bissection
    int directionX = isHorizontal ? 1 : 0;
    int directionY = isHorizontal ? 0 : 1;

    // Define the length of wall
    int length = isHorizontal ? width : height;

    for (int i = 0; i < length; i++) {
      //Create wall
      if (wallX != passaseX || wallY != passageY) {
        board.grid[wallX][wallY].setWall(true);
        board.walls.add(board.grid[wallX][wallY]);
      }
      wallX += directionX;
      wallY += directionY;
    }

    await Future.delayed(Duration(milliseconds: board.speedMaze));

    int newX = x;
    int newY = y;

    int newWidth = isHorizontal ? width : wallX - x;
    int newHeight = isHorizontal ? wallY - y : height;
    await _divideGrid(newX, newY, newWidth, newHeight);

    newX = isHorizontal ? x : wallX + 1;
    newY = isHorizontal ? wallY + 1 : y;

    newWidth = isHorizontal ? width : x + width - wallX - 1;
    newHeight = isHorizontal ? y + height - wallY - 1 : height;
    await _divideGrid(newX, newY, newWidth, newHeight);
  }

  // Evict a biased maze
  Orientation _getOrientation(width, height) {
    if (width < height)
      return Orientation.HORIZONTAL;
    else if (width > height)
      return Orientation.VERTICAL;
    else {
      Random rng = Random();
      return rng.nextBool() ? Orientation.VERTICAL : Orientation.HORIZONTAL;
    }
  }
}
