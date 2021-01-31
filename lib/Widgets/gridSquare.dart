import 'package:flutter/material.dart';
import 'package:path_finder/Model/board.dart';
import 'package:path_finder/Model/node.dart';
import 'package:provider/provider.dart';

class GridSquare extends StatefulWidget {
  final Node _node;
  final int i;
  final int j;
  final Function setStart;
  final Function setFinish;

  GridSquare({
    Key key,
    @required node,
    i,
    j,
    @required setFinish,
    @required setStart,
  })  : this._node = node,
        this.i = i,
        this.j = j,
        this.setFinish = setFinish,
        this.setStart = setStart,
        super(key: key);

  @override
  _GridSquareState createState() => _GridSquareState();
}

class _GridSquareState extends State<GridSquare> {
  @override
  void initState() {
    super.initState();
    widget._node.addListener(() {
      this.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget._node.isStart) {
      return Draggable<Node>(
        data: widget._node,
        onDragStarted: () {
          widget._node.visited = false;
        },
        onDraggableCanceled: (_, __) {
          widget._node.setStart(true);
          widget.setStart(widget._node);
          context.read<Board>().startPathFinding();
        },
        childWhenDragging: Container(
          decoration: BoxDecoration(
              color: widget._node.isPath
                  ? Color(0xFF00b38f)
                  : widget._node.visited
                      ? Colors.black
                      : Color(0xFF000066),
              border: Border.all(color: Theme.of(context).primaryColor)),
          width: 35,
          height: 35,
        ),
        feedback: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(color: Theme.of(context).primaryColor)),
          width: 35,
          height: 35,
          child: Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF000066),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(color: Theme.of(context).primaryColor)),
          width: 35,
          height: 35,
          child: Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF00b38f),
          ),
        ),
      );
    } else if (widget._node.isFinish) {
      return Draggable<Node>(
        data: widget._node,
        onDragStarted: () {
          widget._node.visited = false;
        },
        onDraggableCanceled: (_, __) {
          widget._node.setFinish(true);
          widget.setFinish(widget._node);
          context.read<Board>().startPathFinding();
        },
        childWhenDragging: Container(
          decoration: BoxDecoration(
              color: widget._node.isPath
                  ? Color(0xFF00b38f)
                  : widget._node.visited
                      ? Colors.black
                      : Color(0xFF000066),
              border: Border.all(color: Theme.of(context).primaryColor)),
          width: 35,
          height: 35,
        ),
        feedback: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(color: Theme.of(context).primaryColor)),
          width: 35,
          height: 35,
          child: Icon(
            Icons.flag,
            color: Color(0xFF000066),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(color: Theme.of(context).primaryColor)),
          width: 35,
          height: 35,
          child: Icon(
            Icons.flag,
            color: Color(0xFF00b38f),
          ),
        ),
      );
    } else {
      return DragTarget<Node>(
          //Set new node as start or finish
          onAccept: (Node node) {
        if (node.isFinish) {
          node.setFinish(false);
          widget._node.setFinish(true);
          widget.setFinish(widget._node);
        }
        if (node.isStart) {
          node.setStart(false);
          widget._node.setStart(true);
          widget.setStart(widget._node);
        }
        if (context.read<Board>().isFinished)
          context.read<Board>().startPathFinding();
      }, onWillAccept: (node) {
        if (widget._node.isFinish || widget._node.isStart) {
          return false;
        }
        return true;
      }, onMove: (value) {
        if (context.read<Board>().isFinished &&
            widget._node != context.read<Board>().finish &&
            widget._node != context.read<Board>().start) {
          dynamic node = value.data;
          node.visited = false;
          node.clear();
          if (node.isStart) {
            widget.setStart(widget._node);
            node.visited = false;
            context.read<Board>().startPathFinding();
          }
          if (node.isFinish) {
            // Dont set isFinish, isFinish is used for UI purposes only, if set will bug
            widget.setFinish(widget._node);
            node.visited = false;
            context.read<Board>().startPathFinding();
          }
        }
      }, builder: (context, candidates, rejects) {
        return AnimatedContainer(
          duration: Duration(
              milliseconds: context.select<Board, int>((model) => model.speed)),
          decoration: BoxDecoration(
              color: widget._node.isWall
                  ? Theme.of(context).primaryColor
                  : widget._node.isPath
                      ? Color(0xFF00b38f)
                      : widget._node.visited
                          ? Colors.black
                          : Color(0xFF000066),
              border: Border.all(color: Theme.of(context).primaryColor)),
          width: 35,
          height: 35,
        );
      });
    }
  }
}
