import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("FAQ"),
          backgroundColor: Colors.indigo[400],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  color: Colors.indigoAccent[200],
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                            "How do I upload picture from galley?",
                            style: TextStyle(color: Colors.white),
                          ),
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(5),
                                child: Image.asset(
                                  "assets/faq/gallery.png",
                                  fit: BoxFit.cover,
                                )),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 15, left: 5, right: 5, bottom: 10),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "You can click the button that is circled above to have access to the photos that you have taken and are in the gallery.",
                                style: TextStyle(
                                    color: Colors.black, wordSpacing: 2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.indigoAccent[200],
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                            "How do I upload picture from Camera?",
                            style: TextStyle(color: Colors.white),
                          ),
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(5),
                                child: Image.asset("assets/faq/camera.png")),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 15, left: 5, right: 5, bottom: 10),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: Text(
                                "You can click the button that is circled above to have access to the camera and use it in getting a prediction.",
                                style: TextStyle(
                                    color: Colors.black, wordSpacing: 2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.indigoAccent[200],
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                            "Why does the prediction say no prediction?",
                            style: TextStyle(color: Colors.white),
                          ),
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Text(
                                  "If the output for the prediction shows \n\n[No predictions] \n\nMeans that our AI was unable to have a clear distinct answer after analysing the photograph.\nTo avoid this, try taking the picture with a btter lighting condition and better focus.",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.indigoAccent[200],
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                            "Why do the predictions mean?",
                            style: TextStyle(color: Colors.white),
                          ),
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(5),
                                width: 250,
                                child: Image.asset(
                                  "assets/faq/detections.png",
                                  fit: BoxFit.cover,
                                )),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 15, left: 5, right: 5, bottom: 10),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: Text(
                                "The prediction that is displayed is usually one of 5 classifications.\n\n[ No Ulcer ] \n\nMeans that the model detects the foot is an healthy foot. \n\n[ Low Risk and Medium Risk] \n\nMeans that your ulcer has been categorised as towards the lower end of severity.\nShould be consulted to the doctor immediately. \n\n[High Risk and Severe Risk] \n\nMeans that your ulcer has been categorised as being towards higher end of severity.\nShould be consulted to the doctor immediately.",
                                style: TextStyle(
                                    color: Colors.black, wordSpacing: 2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.indigoAccent[200],
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                            "Is this an alternative for a doctor?",
                            style: TextStyle(color: Colors.white),
                          ),
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                  "No, this is not meant to be used as alternative to a consulting physician. \n\nPlease ask your consulting physician before using this."),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.indigoAccent[200],
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                            "What are the symbols next to my records?",
                            style: TextStyle(color: Colors.white),
                          ),
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Image.asset("assets/faq/stock.png"),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        width: 200,
                                        child: Text(
                                          "The blue-dot refers to the first record ever made on the device.",
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        width: 200,
                                        child: Text(
                                          "\nThe red and green refers to deprovements or improvements compared to the previous record.",
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        width: 200,
                                        child: Text(
                                          "\nThe orange square refers to stagnations compared to the previous record.",
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.people),
                      label: Text("The developers")),
                )
              ],
            ),
          ),
        ));
  }
}
