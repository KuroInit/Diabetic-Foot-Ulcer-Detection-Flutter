import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detections.dart';

class UserRecords extends StatefulWidget {
  @override
  _UserRecordsState createState() => _UserRecordsState();
}

class _UserRecordsState extends State<UserRecords> {
  SharedPreferences sharedPreferences;
  List<Detection> _local = [];

  void loadData() async {
    _local = [];
    var s = sharedPreferences.getStringList('userRecord');
    print(s);
    var list = s.map((e) => Detection.fromMap(json.decode(e))).toList();

    setState(() {
      _local.addAll(list);
    });
  }

  @override
  void initState() {
    sPInit();
    sPRefresh();
    super.initState();
  }

  sPInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("Hello");
  }

  sPClear() async {
    await sharedPreferences.remove('userRecord');
    _local = [];
    setState(() {});
  }

  sPRefresh() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var s = pref.getStringList('userRecord');
    if (s != null) {
      var list = s.map((e) => Detection.fromMap(json.decode(e))).toList();
      setState(() {
        _local = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Container(
                margin: EdgeInsets.only(right: 40), child: Text("Records"))),
        backgroundColor: Colors.indigo[400],
      ),
      body: SafeArea(
          child: Column(
        children: [
          // FlatButton(
          //   onPressed: sPClear,
          //   child: Text("Clear"),
          //   color: Colors.red,
          // ),
          Container(
            child: Flexible(
              child: Container(
                margin: EdgeInsets.only(right: 10, left: 10, top: 10),
                child: _local.length != 0
                    ? ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: _local.length,
                        itemBuilder: (BuildContext context, int index) {
                          int point, newPoint = 0;
                          Icon tile;
                          Color data = Colors.indigo[400];
                          if (index != 0) {
                            if (_local[index].detection.contains(new RegExp(
                                r'No Ulcer',
                                caseSensitive: false))) {
                              newPoint = 5;
                            } else if (_local[index].detection.contains(
                                new RegExp(r'Low Risk',
                                    caseSensitive: false))) {
                              newPoint = 4;
                            } else if (_local[index].detection.contains(
                                new RegExp(r'Medium Risk',
                                    caseSensitive: false))) {
                              newPoint = 3;
                            } else if (_local[index].detection.contains(
                                new RegExp(r'High Risk',
                                    caseSensitive: false))) {
                              newPoint = 2;
                            } else if (_local[index].detection.contains(
                                new RegExp(r'Severe Risk',
                                    caseSensitive: false))) {
                              newPoint = 1;
                            }

                            if (_local[index - 1].detection.contains(new RegExp(
                                r'No Ulcer',
                                caseSensitive: false))) {
                              point = 5;
                            } else if (_local[index - 1].detection.contains(
                                new RegExp(r'Low Risk',
                                    caseSensitive: false))) {
                              point = 4;
                            } else if (_local[index - 1].detection.contains(
                                new RegExp(r'Medium Risk',
                                    caseSensitive: false))) {
                              point = 3;
                            } else if (_local[index - 1].detection.contains(
                                new RegExp(r'High Risk',
                                    caseSensitive: false))) {
                              point = 2;
                            } else if (_local[index - 1].detection.contains(
                                new RegExp(r'Severe Risk',
                                    caseSensitive: false))) {
                              point = 1;
                            }

                            if (newPoint > point) {
                              tile = Icon(
                                Icons.arrow_circle_up,
                                color: Colors.green[700],
                                size: 30,
                              );
                            } else if (newPoint == point) {
                              tile = Icon(
                                Icons.crop_square,
                                color: Colors.orange[600],
                                size: 30,
                              );
                            } else {
                              tile = Icon(
                                Icons.arrow_circle_down,
                                color: Colors.red[700],
                                size: 30,
                              );
                            }
                          } else {
                            tile = Icon(
                              Icons.circle,
                              color: data,
                              size: 30,
                            );
                          }

                          return Container(
                            height: 75,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Center(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 27),
                                        child: Text(
                                            'Detected Class: ${_local[index].detection}'),
                                      ),
                                    ),
                                    Center(
                                        child: Container(
                                            child: Text(
                                                '${_local[index].confidence}'))),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: tile,
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      )
                    : Container(
                        child:
                            Center(child: Text("No Records have been found"))),
              ),
            ),
          )
        ],
      )),
    );
  }
}
