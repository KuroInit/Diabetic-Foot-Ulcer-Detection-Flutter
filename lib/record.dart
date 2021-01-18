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
    var s = sharedPreferences.getStringList('userRecord');
    //print(s);
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
        title: Text("Records"),
        backgroundColor: Colors.indigo[400],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Center(child: Text("Second Page")),
          FlatButton(
            onPressed: loadData,
            child: Text("Load Data"),
            color: Colors.green,
          ),
          FlatButton(
            onPressed: sPClear,
            child: Text("Clear"),
            color: Colors.red,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 300),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _local.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  color: Colors.amber[index],
                  child: Center(child: Text('${_local[index]}')),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          )
        ],
      )),
    );
  }
}
