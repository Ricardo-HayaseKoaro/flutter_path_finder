import 'package:flutter/material.dart';
import 'package:path_finder/Model/node.dart';

class GridSquare extends StatefulWidget {
  final Node _node;
  final int i;
  final int j;

  GridSquare({
    Key key,
    @required node,
    i,
    j,
  })  : this._node = node,
        this.i = i,
        this.j = j,
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
    if (widget._node.isWall) {
      return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Theme.of(context).primaryColor,
              border: Border.all(color: Theme.of(context).primaryColor)),
          width: 35,
          height: 35);
    } else if (widget._node.isStart) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Theme.of(context).primaryColor,
            border: Border.all(color: Theme.of(context).primaryColor)),
        width: 35,
        height: 35,
        child: Icon(
          Icons.flag,
          color: Colors.green[600],
        ),
      );
    } else if (widget._node.isFinish) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Theme.of(context).primaryColor,
            border: Border.all(color: Theme.of(context).primaryColor)),
        width: 35,
        height: 35,
        child: Icon(
          Icons.flag,
          color: Colors.red[600],
        ),
      );
    } else if (widget._node.isPath) {
      return AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Colors.yellow,
              border: Border.all(color: Theme.of(context).primaryColor)),
          width: 35,
          height: 35,
          child: Text(widget._node.val.toString() ?? ""));
    } else {
      return AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: widget._node.visited ? Colors.red : Colors.white,
            border: Border.all(color: Theme.of(context).primaryColor)),
        width: 35,
        height: 35,
      );
    }
  }
}
