import 'package:flutter/material.dart';
import 'package:path_finder/Enums/mazeAlgorithm.dart';
import 'package:path_finder/Enums/searchAlgorithm.dart';
import 'package:path_finder/Model/board.dart';

import 'appLocalizations.dart';

class Settings extends StatefulWidget {
  Board board;
  Settings(this.board, {Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double _speedSearch;
  double _speedPath;
  double _speedMaze;
  double _speedAnimation;
  double _weightValue;
  Map<SearchAlgorithm, String> searchAlgorithms;
  Map<MazeAlgorithm, String> mazeAlgorithms;

  SearchAlgorithm selectedSearch;
  MazeAlgorithm selectedMaze;

  @override
  void initState() {
    super.initState();
    _speedSearch = widget.board.speedSearch.roundToDouble();
    _speedPath = widget.board.speedPath.roundToDouble();
    _speedMaze = widget.board.speedMaze.roundToDouble();
    _speedAnimation = widget.board.speedAnimation.roundToDouble();
    _weightValue = widget.board.weightValue.roundToDouble();

    selectedSearch = widget.board.selectedSearchAlgorithm;
    selectedMaze = widget.board.selectedMazeAlgorithm;
  }

  @override
  Widget build(BuildContext context) {
    searchAlgorithms = {
      SearchAlgorithm.BFS: AppLocalizations.of(context).translate('bfs'),
      SearchAlgorithm.Dijkstra:
          AppLocalizations.of(context).translate('dijkstra'),
      SearchAlgorithm.AStar: AppLocalizations.of(context).translate('a_star'),
    };
    mazeAlgorithms = {
      MazeAlgorithm.RecursiveBacktracking:
          AppLocalizations.of(context).translate('recursive_backtracking'),
      MazeAlgorithm.Prim: AppLocalizations.of(context).translate('prim'),
    };

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).translate('settings'),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).translate('search_algorithm'),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: DropdownButton<SearchAlgorithm>(
                isExpanded: true,
                items: searchAlgorithms
                    .map((key, value) {
                      return MapEntry(
                          key,
                          DropdownMenuItem<SearchAlgorithm>(
                            value: key,
                            child: Text(value),
                          ));
                    })
                    .values
                    .toList(),
                value: selectedSearch,
                style: TextStyle(color: Colors.white),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                dropdownColor: Colors.black,
                onChanged: (newValue) {
                  setState(() {
                    selectedSearch = newValue;
                    widget.board.selectedSearchAlgorithm = selectedSearch;
                    // BFS is unweighted so we need to delete the weights from the grid
                    widget.board.clearBoard();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).translate('maze_algorithm'),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Align(
                alignment: Alignment.center,
                child: DropdownButton<MazeAlgorithm>(
                  isExpanded: true,
                  items: mazeAlgorithms
                      .map((key, value) {
                        return MapEntry(
                            key,
                            DropdownMenuItem<MazeAlgorithm>(
                              value: key,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ));
                      })
                      .values
                      .toList(),
                  value: selectedMaze,
                  style: TextStyle(color: Colors.white),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  dropdownColor: Colors.black,
                  onChanged: (newValue) {
                    setState(() {
                      selectedMaze = newValue;
                      widget.board.selectedMazeAlgorithm = selectedMaze;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('weight_value'),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Slider(
              value: _weightValue,
              onChanged: (value) {
                setState(() {
                  _weightValue = value;
                  widget.board.weightValue = value.toInt();
                });
              },
              label: _weightValue.round().toString() +
                  AppLocalizations.of(context).translate('units'),
              activeColor: Color(0xFF5900b3),
              divisions: 30,
              min: 0,
              max: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('delay_search'),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Slider(
              value: _speedSearch,
              onChanged: (value) {
                setState(() {
                  _speedSearch = value;
                  widget.board.speedSearch = value.toInt();
                });
              },
              label: _speedSearch.round().toString() + " ms",
              activeColor: Color(0xFF5900b3),
              divisions: 10,
              min: 0,
              max: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('delay_path'),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Slider(
              value: _speedPath,
              onChanged: (value) {
                setState(() {
                  _speedPath = value;
                  widget.board.speedPath = value.toInt();
                });
              },
              label: _speedPath.round().toString() + " ms",
              activeColor: Color(0xFF5900b3),
              divisions: 8,
              min: 0,
              max: 400,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('delay_maze'),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Slider(
              value: _speedMaze,
              onChanged: (value) {
                setState(() {
                  _speedMaze = value;
                  widget.board.speedMaze = value.toInt();
                });
              },
              label: _speedMaze.round().toString() + " ms",
              activeColor: Color(0xFF5900b3),
              divisions: 10,
              min: 0,
              max: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('delay_ani'),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Slider(
              value: _speedAnimation,
              onChanged: (value) {
                setState(() {
                  _speedAnimation = value;
                  widget.board.speedAnimation = value.toInt();
                });
              },
              label: _speedAnimation.round().toString() + " ms",
              activeColor: Color(0xFF5900b3),
              divisions: 10,
              min: 1,
              max: 1000,
            ),
          ],
        ),
      ),
    );
  }
}
