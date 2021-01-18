import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
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
  List records;

  @override
  void initState() {
    super.initState();
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
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
    recog
        .map((e) => {
              if (e["confidenceInClass"] >
                  0.55) //Change this value to increase sensitivity
                {
                  saveToList.add(e["detectedClass"]),
                  saveToList.add(
                      "Confidence rate: ${(e["confidenceInClass"] * 100).toStringAsFixed(0)}" +
                          "%")
                }
            })
        .toList();
    if (saveToList == null || saveToList.length == 0) {
      return errList;
    }
    return saveToList;
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
            constraints: BoxConstraints(maxHeight: 150),
            //decoration: BoxDecoration(color: Colors.black),
            child: ListView.separated(
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
          Container(
            child: ElevatedButton.icon(
              icon: Icon(Icons.storage),
              label: Text("View Records"),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo[400],
              ),
              onPressed: () => {},
            ),
          )
        ],
      )),
    );
  }
}
