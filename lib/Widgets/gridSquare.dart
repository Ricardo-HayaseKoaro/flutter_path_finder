import 'package:flutter/material.dart';
import 'package:path_finder/Model/node.dart';

class GridSquare extends StatefulWidget {
  final Node _node;
  final int i;
  final int j;
  final Function setStart;
  final Function setFinish;

  GridSquare(
      {Key key, @required node, i, j, @required setFinish, @required setStart})
      : this._node = node,
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
        onDragCompleted: () {
          widget._node.setStart(false);
          widget._node.clear();
        },
        childWhenDragging: AnimatedContainer(
          duration: Duration(milliseconds: 800),
          decoration: BoxDecoration(
              color: Color(0xFF000066),
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
            color: Colors.green[600],
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
            color: Colors.green[600],
          ),
        ),
      );
    } else if (widget._node.isFinish) {
      return Draggable<Node>(
        data: widget._node,
        onDragCompleted: () {
          widget._node.setFinish(false);
          widget._node.clear();
        },
        childWhenDragging: AnimatedContainer(
          duration: Duration(milliseconds: 800),
          decoration: BoxDecoration(
              color: Color(0xFF000066),
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
            color: Colors.red[600],
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
            color: Colors.red[600],
          ),
        ),
      );
    } else {
      return DragTarget<Node>(
          //Set new node as start or finish
          onAccept: (Node node) {
        if (node.isFinish) {
          widget._node.setFinish(true);
          widget.setFinish(widget._node);
        }
        if (node.isStart) {
          widget._node.setStart(true);
          widget.setStart(widget._node);
        }
      }, onWillAccept: (node) {
        if (widget._node.isFinish || widget._node.isStart) {
          return false;
        }
        return true;
      }, builder: (context, candidates, rejects) {
        if (widget._node.isWall) {
          return AnimatedContainer(
              child: Text(
                widget._node.y.toString() + "," + widget._node.x.toString(),
                style: TextStyle(color: Colors.white),
              ),
              duration: Duration(microseconds: 2),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(color: Theme.of(context).primaryColor)),
              width: 35,
              height: 35);
        } else if (widget._node.isPath) {
          return AnimatedContainer(
            child: Text(
              widget._node.y.toString() + "," + widget._node.x.toString(),
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(milliseconds: 3000),
            decoration: BoxDecoration(
                color: Color(0xFF00b38f),
                border: Border.all(color: Theme.of(context).primaryColor)),
            width: 35,
            height: 35,
          );
        } else {
          return AnimatedContainer(
            child: Text(
              widget._node.y.toString() + "," + widget._node.x.toString(),
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(milliseconds: 800),
            decoration: BoxDecoration(
                color: widget._node.visited ? Colors.black : Color(0xFF000066),
                border: Border.all(color: Theme.of(context).primaryColor)),
            width: 35,
            height: 35,
          );
        }
      });
    }
  }
}
