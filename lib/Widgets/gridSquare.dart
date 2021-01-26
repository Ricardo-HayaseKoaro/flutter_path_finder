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
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: widget._node.isWall
                ? Theme.of(context).primaryColor
                : Colors.white,
            border: Border.all(color: Theme.of(context).primaryColor)),
        width: 35,
        height: 35);
  }
}
