import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detections.dart';

class userRecords extends StatefulWidget {
  @override
  _userRecordsState createState() => _userRecordsState();
}

class _userRecordsState extends State<userRecords> {
  SharedPreferences sharedPreferences;
  List<Detection> _local = [];

  void loadData() async {
    _local = [];
    var s = sharedPreferences.getStringList('userRecord');
    print(s);
    var list = s.map((e) => Detection.fromMap(json.decode(e))).toList();

    setState(() {
      _local = list;
    });
  }

  @override
  void initState() {
    sPInit();
    super.initState();
  }

  sPInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  sPClear() async {
    await sharedPreferences.remove('userRecord');
    _local = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Records")),
        backgroundColor: Colors.indigo[400],
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: loadData,
              child: Icon(
                Icons.refresh,
                size: 26,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          FlatButton(
            onPressed: sPClear,
            child: Text("Clear"),
            color: Colors.red,
          ),
          Container(
            child: Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: _local.length,
                  itemBuilder: (BuildContext context, int index) {
                    int point, newPoint = 0;
                    Icon tile;
                    Color data = Colors.indigo[400];
                    if (index != 0) {
                      switch (_local[index].detection) {
                        case "No Ulcer":
                          newPoint = 5;
                          break;
                        case "High Risk":
                          newPoint = 2;
                          break;
                        case "Medium Risk":
                          newPoint = 3;
                          break;
                        case "Low Risk":
                          newPoint = 4;
                          break;
                        case "Severe Risk":
                          newPoint = 1;
                          break;
                      }

                      switch (_local[index - 1].detection) {
                        case "No Ulcer":
                          point = 5;
                          break;
                        case "High Risk":
                          point = 2;
                          break;
                        case "Medium Risk":
                          point = 3;
                          break;
                        case "Low Risk":
                          point = 4;
                          break;
                        case "Severe Risk":
                          point = 1;
                          break;
                      }

                      if (newPoint > point) {
                        tile = Icon(
                          Icons.arrow_circle_up,
                          color: Colors.green[700],
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      child:
                                          Text('${_local[index].confidence}'))),
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
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
