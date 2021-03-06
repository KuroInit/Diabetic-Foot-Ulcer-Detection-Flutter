import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'record.dart';
import 'package:intl/intl.dart';
import 'detections.dart';
import 'infopage.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TfliteHome(),
      routes: {
        '/records': (_) => UserRecords(),
        '/infopage': (_) => InfoPage()
      },
    );
  }
}

class TfliteHome extends StatefulWidget {
  @override
  _TfliteHomeState createState() => _TfliteHomeState();
}

class _TfliteHomeState extends State<TfliteHome> {
  File _image;
  bool _busy = false;

  List _recognitions;
  Map<String, String> records = {};
  SharedPreferences sharedPreferences;
  List<Detection> _record = [];

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var s = sharedPreferences.getStringList('userRecord');
    if (s != null) {
      _record = s.map((e) => Detection.fromMap(json.decode(e))).toList();
    }
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
          model: "assets/tflite/model.tflite",
          labels: "assets/tflite/labels.txt",
          numThreads: 2,
          isAsset: true,
          useGpuDelegate: false);
      print(res);
    } on PlatformException {
      print(" Failed to load model");
    }
  }

  selectImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      _busy = true;
    });
    predictImage(image);
  }

  selectImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    print(image.path);
    setState(() {
      _busy = true;
    });
    predictImage(image);
  }

  predictImage(File image) async {
    if (image == null) return;

    await ssdMobile(image);

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  ssdMobile(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,
        model: "SSDMobileNet",
        numResultsPerClass: 1,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.1,
        asynch: true);

    setState(() {
      _recognitions = saveToList(recognitions);
    });
  }

  List<dynamic> saveToList(List<dynamic> recog) {
    if (recog == null) return [];
    List<dynamic> saveToList = [];
    List<String> errList = ["No predictions"];
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat.yMd().add_jms();
    String formatted = formatter.format(now);
    recog
        .map((e) => {
              if (e["confidenceInClass"] >
                  0.40) //Change this value to increase sensitivity
                {
                  saveToList.add(e["detectedClass"]),
                  saveToList.add(
                      "Confidence rate: ${(e["confidenceInClass"] * 100).toStringAsFixed(0)}" +
                          "%"),
                }
            })
        .toList();
    print(recog);
    if (saveToList == null || saveToList.length == 0) {
      return errList;
    }

    var item = {
      saveToList[0].toString() + "\n\n" + formatted: saveToList[1].toString()
    };
    records.addAll(item);

    if (records != null) {
      saveData(records);
    }

    return saveToList;
  }

  void saveData(Map<String, String> map) {
    //_record = [];
    map.forEach((k, v) => _record.add(Detection(k, v)));
    var saved = _record.map((e) => json.encode(e.toMap())).toList();
    sharedPreferences.setStringList("userRecord", saved);
    _record = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo[400],
        centerTitle: true,
        elevation: 0,
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info_outline_rounded),
              onPressed: (() => {Navigator.of(context).pushNamed('/infopage')}))
        ],
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(245, 220, 220, 220),
            ),
            constraints: BoxConstraints.expand(
              height: 200.0,
              width: 350.0,
            ),
            child: _image == null
                ? Center(
                    child: Text(
                      "Please Select an Image",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Image.file(
                    _image,
                    fit: BoxFit.scaleDown,
                  ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: _recognitions == null
                ? Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                : Text("Predictions", style: TextStyle(fontSize: 20)),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 125),
            //decoration: BoxDecoration(color: Colors.black),
            child: _recognitions == null
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(child: Text("Predictions will Appear here")))
                : ListView.separated(
                    padding: const EdgeInsets.all(5),
                    itemCount: _recognitions == null ? 0 : _recognitions.length,
                    itemBuilder: (BuildContext context, int index) {
                      Color ulcer = Colors.indigo[400];
                      Color font = Colors.white;
                      var element = _recognitions[index].toString();
                      if ((element == "No Ulcer") ||
                          (element == "High Risk") ||
                          (element == "Medium Risk") ||
                          (element == "Low Risk") ||
                          (element == "Severe Risk")) {
                        switch (element) {
                          case "No Ulcer":
                            ulcer = Colors.green[700];
                            break;
                          case "High Risk":
                            ulcer = Colors.red;
                            break;
                          case "Medium Risk":
                            ulcer = Colors.orange[700];
                            break;
                          case "Low Risk":
                            ulcer = Colors.yellow[400];
                            font = Colors.black;
                            break;
                          case "Severe Risk":
                            ulcer = Colors.red[700];
                            break;
                        }
                      }
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: ulcer,
                        ),
                        height: 35,
                        child: Center(
                          child: Text(
                            "${_recognitions[index]}",
                            style: TextStyle(color: font),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //Camera Button Container
                padding: EdgeInsets.fromLTRB(20, 0, 15, 15),
                margin: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                        width: 100,
                        child: Text(
                          "Select Image From Camera",
                          textAlign: TextAlign.center,
                        )),
                    ElevatedButton.icon(
                      icon: Icon(Icons.camera),
                      label: Text("Camera"),
                      onPressed: selectImageFromCamera,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo[400],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1.5,
                          blurRadius: 7)
                    ]),
              ),
              Container(
                //Gallery Button Container
                padding: EdgeInsets.fromLTRB(20, 0, 15, 15),
                margin: EdgeInsets.all(15),
                alignment: Alignment(0.0, 0.0),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                        width: 100,
                        child: Text(
                          "Select Image From Gallery",
                          textAlign: TextAlign.center,
                        )),
                    ElevatedButton.icon(
                      icon: Icon(Icons.folder_open),
                      label: Text("Gallery"),
                      onPressed: selectImageFromGallery,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo[400],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7)
                    ]),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.storage),
                  label: Text("View Records"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[400],
                  ),
                  onPressed: () {
                    if (_record != null) {
                      Navigator.of(context).pushNamed('/records');
                    } else {
                      print("Not working");
                    }
                  },
                ),
              ),
              // Container(
              //     child: ElevatedButton.icon(
              //   icon: Icon(Icons.delete),
              //   label: Text("Delete"),
              //   style: ElevatedButton.styleFrom(primary: Colors.red),
              //   onPressed: () => {sharedPreferences.clear(), _record = []},
              // ))
            ],
          )
        ],
      )),
    );
  }
}
