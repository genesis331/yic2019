import 'dart:math';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final databaseReference = FirebaseDatabase.instance.reference();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          fontFamily: 'Open Sans',
          textTheme: TextTheme(body1: TextStyle(color: Colors.white))),
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    databaseReference.once().then((DataSnapshot snapshot) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (c, a1, a2) => HomePage(),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 1500)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text('IntelliGuard',
                    style:
                        TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
                Text('for Hosts', style: TextStyle(fontSize: 22)),
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      )),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic formName;
  dynamic formCompany;
  dynamic formDate;
  dynamic formICNo;
  dynamic formLevel;
  dynamic formTime;
  var upcomingVisitorsRef =
      FirebaseDatabase.instance.reference().child('data').limitToFirst(5);
  var allVisitorsRef = FirebaseDatabase.instance.reference().child('data');

  void updateFormData(formIndex, formData) {
    if (formIndex == 0) {
      setState(() {
        formName = formData;
      });
    } else if (formIndex == 1) {
      setState(() {
        formCompany = formData;
      });
    } else if (formIndex == 2) {
      setState(() {
        formDate = formData;
      });
    } else if (formIndex == 3) {
      setState(() {
        formICNo = formData;
      });
    } else if (formIndex == 4) {
      setState(() {
        formLevel = formData;
      });
    } else if (formIndex == 5) {
      setState(() {
        formTime = formData;
      });
    }
  }

  void submitFormData(context) {
    String newRecord = createRecord();
    if (formName != null &&
        formCompany != null &&
        formDate != null &&
        formICNo != null &&
        formLevel != null &&
        formTime != null) {
      databaseReference.child('data').once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          for (int o = 0; o <= snapshot.value.length - 1; o++) {
            if (newRecord == snapshot.value[o]['visitid'].toString()) {
              submitFormData(context);
            }
            if (o == snapshot.value.length - 1) {
              if (snapshot.value.length == 0) {
                var newRecordRef =
                    FirebaseDatabase.instance.reference().child('data/0');
                newRecordRef.update({
                  'company': formCompany,
                  'date': formDate,
                  'icno': formICNo,
                  'level': formLevel,
                  'name': formName,
                  'visitid': newRecord,
                  'time': formTime,
                }).then((Future) {
                  Navigator.pop(context);
                });
              } else {
                var newRecordRef = FirebaseDatabase.instance
                    .reference()
                    .child('data/' + snapshot.value.length.toString());
                newRecordRef.set({
                  'company': formCompany,
                  'date': formDate,
                  'icno': formICNo,
                  'level': formLevel,
                  'name': formName,
                  'visitid': newRecord,
                  'time': formTime,
                }).then((Future) {
                  Navigator.pop(context);
                });
              }
            }
          }
        } else {
          var newRecordRef =
              FirebaseDatabase.instance.reference().child('data/0');
          newRecordRef.update({
            'company': formCompany,
            'date': formDate,
            'icno': formICNo,
            'level': formLevel,
            'name': formName,
            'visitid': newRecord,
            'time': formTime,
          }).then((Future) {
            Navigator.pop(context);
          });
        }
      });
    }
  }

  void launchBottomSheet() {
    bool chip1 = false;
    bool chip2 = false;
    bool chip3 = false;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              color: Color(0xFF000000),
              child: new Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0))),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 30, top: 30),
                              child: Icon(Icons.add)),
                          Container(
                            margin: EdgeInsets.only(left: 10, top: 30),
                            child: Text('Visitor Registration',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(left: 40, top: 35, right: 40),
                              child: TextField(
                                onChanged: (inputtext) {
                                  updateFormData(0, inputtext);
                                },
                                decoration: InputDecoration(
                                    labelText: "Visitor\'s Name",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    )),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 40, top: 20, right: 40),
                              child: TextField(
                                onChanged: (inputtext) {
                                  updateFormData(1, inputtext);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Visitor\'s Company',
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    )),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 40, top: 20, right: 40),
                              child: ButtonTheme(
                                height: 50,
                                minWidth: double.infinity,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: new RaisedButton.icon(
                                  onPressed: () {
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2019),
                                        lastDate: DateTime(2030),
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return Theme(
                                            data: ThemeData.dark(),
                                            child: child,
                                          );
                                        }).then((inputdate) {
                                      setState(() {
                                        var inputDateFormat =
                                            new DateFormat('yyyy-MM-dd');
                                        updateFormData(2,
                                            inputDateFormat.format(inputdate));
                                      });
                                    });
                                  },
                                  icon: Icon(Icons.date_range),
                                  label: Text(formDate ?? 'Pick a Date'),
                                  color: Colors.indigo,
                                  textColor: Color.fromRGBO(255, 255, 255, 0.9),
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 40, top: 20, right: 40),
                              child: ButtonTheme(
                                height: 50,
                                minWidth: double.infinity,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: new RaisedButton.icon(
                                  onPressed: () {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return Theme(
                                            data: ThemeData.dark(),
                                            child: child,
                                          );
                                        }).then((inputtime) {
                                      setState(() {
                                        var tempHour;
                                        var tempMinute;
                                        if (inputtime.hour < 10) {
                                          tempHour = '0' + inputtime.hour.toString();
                                        } else {
                                          tempHour = inputtime.hour.toString();
                                        }
                                        if (inputtime.minute < 10) {
                                          tempMinute = '0' + inputtime.minute.toString();
                                        } else {
                                          tempMinute = inputtime.minute.toString();
                                        }
                                        updateFormData(
                                            5,
                                            tempHour + ':' + tempMinute);
                                      });
                                    });
                                  },
                                  icon: Icon(Icons.date_range),
                                  label: Text(formTime ?? 'Pick a Time'),
                                  color: Colors.indigo,
                                  textColor: Color.fromRGBO(255, 255, 255, 0.9),
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 40, top: 20, right: 40),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (inputtext) {
                                  updateFormData(3, inputtext);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Visitor\'s IC Number',
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    )),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: ChoiceChip(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      label: Text('Level 1'),
                                      selected: chip1,
                                      onSelected: (inputval) {
                                        chip1 = inputval;
                                        chip2 = false;
                                        chip3 = false;
                                        updateFormData(4, 1);
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: ChoiceChip(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      label: Text('Level 2'),
                                      selected: chip2,
                                      onSelected: (inputval) {
                                        chip2 = inputval;
                                        chip1 = false;
                                        chip3 = false;
                                        updateFormData(4, 2);
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: ChoiceChip(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      label: Text('Level 3'),
                                      selected: chip3,
                                      onSelected: (inputval) {
                                        chip3 = inputval;
                                        chip1 = false;
                                        chip2 = false;
                                        updateFormData(4, 3);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 40, top: 45, right: 40, bottom: 30),
                                child: ButtonTheme(
                                  height: 50,
                                  minWidth: 200,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: new RaisedButton.icon(
                                    onPressed: () {
                                      submitFormData(context);
                                    },
                                    icon: Icon(Icons.add),
                                    label: Text("Register"),
                                    color: Colors.indigo,
                                    textColor:
                                        Color.fromRGBO(255, 255, 255, 0.9),
                                  ),
                                )),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(20, 30, 0, 40),
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: Text('Dashboard',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              )),
          Container(
              margin: EdgeInsets.only(left: 35),
              child: Row(
                children: <Widget>[
                  Text("Upcoming Visitors", textAlign: TextAlign.left)
                ],
              )),
          StreamBuilder(
              stream: upcomingVisitorsRef.onValue,
              builder: (context, snap) {
                if (snap.hasData &&
                    !snap.hasError &&
                    snap.data.snapshot.value != null) {
                  return Container(
                      margin: EdgeInsets.only(left: 30, top: 10),
                      height: 320,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snap.data.snapshot.value.length,
                        itemBuilder: (context, index) {
                          if (dateTimeValidation(
                              snap.data.snapshot.value[index]['date'],
                              snap.data.snapshot.value[index]['time'])) {
                            return GestureDetector(
                                onLongPress: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (c, a1, a2) =>
                                            VisitorOverviewScreen(
                                                cardCount: index,
                                                dbdata: snap.data.snapshot.value),
                                        transitionDuration:
                                        Duration(milliseconds: 400),
                                      ));
                                },
                                child: Hero(
                                  tag: 'visitorCard' + index.toString(),
                                  child: Container(
                                      height: 300,
                                      width: 300,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Colors.indigo[800],
                                            Colors.indigo[400],
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        top: 25, left: 30),
                                                    child: new Material(
                                                      color: Colors.transparent,
                                                      child: Text('Visiting Date',
                                                          style: TextStyle(
                                                              color:
                                                              Color.fromRGBO(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  0.8))),
                                                    ))
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                        snap.data.snapshot
                                                            .value[index]['date'],
                                                        style: TextStyle(
                                                            fontSize: 25)),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 5, left: 30),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text('Visitor Name',
                                                        style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                255,
                                                                255,
                                                                255,
                                                                0.8))),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 18,
                                                      left: 30,
                                                      right: 30),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                        snap.data.snapshot
                                                            .value[index]['name'],
                                                        style: TextStyle(
                                                            fontSize: 25)),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 5,
                                                      left: 30,
                                                      right: 30),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text('Visitor Company',
                                                        style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                255,
                                                                255,
                                                                255,
                                                                0.8))),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 18,
                                                      left: 30,
                                                      right: 30),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                        snap.data.snapshot
                                                            .value[index]
                                                        ['company'],
                                                        style: TextStyle(
                                                            fontSize: 25)),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 5, left: 30),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                        'Long press card to do more',
                                                        style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                255,
                                                                255,
                                                                255,
                                                                0.8),
                                                            fontSize: 10)),
                                                  ),
                                                  padding:
                                                  EdgeInsets.only(top: 50),
                                                )
                                              ],
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                            ),
                                          ],
                                        ),
                                      )),
                                ));
                          } else {
                            return GestureDetector(
                                onLongPress: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (c, a1, a2) =>
                                            VisitorOverviewScreen(
                                                cardCount: index,
                                                dbdata: snap.data.snapshot.value),
                                        transitionDuration:
                                        Duration(milliseconds: 400),
                                      ));
                                },
                                child: Hero(
                                  tag: 'visitorCard' + index.toString(),
                                  child: Container(
                                      height: 300,
                                      width: 300,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Colors.red[800],
                                            Colors.red[400],
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        top: 25, left: 30),
                                                    child: new Material(
                                                      color: Colors.transparent,
                                                      child: Text('Visiting Date',
                                                          style: TextStyle(
                                                              color:
                                                              Color.fromRGBO(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  0.8))),
                                                    ))
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                        snap.data.snapshot
                                                            .value[index]['date'],
                                                        style: TextStyle(
                                                            fontSize: 25)),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 5, left: 30),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text('Visitor Name',
                                                        style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                255,
                                                                255,
                                                                255,
                                                                0.8))),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 18,
                                                      left: 30,
                                                      right: 30),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                        snap.data.snapshot
                                                            .value[index]['name'],
                                                        style: TextStyle(
                                                            fontSize: 25)),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 5,
                                                      left: 30,
                                                      right: 30),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text('Visitor Company',
                                                        style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                255,
                                                                255,
                                                                255,
                                                                0.8))),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 18,
                                                      left: 30,
                                                      right: 30),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                        snap.data.snapshot
                                                            .value[index]
                                                        ['company'],
                                                        style: TextStyle(
                                                            fontSize: 25)),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 5, left: 30),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: new Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                        'Long press card to do more',
                                                        style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                255,
                                                                255,
                                                                255,
                                                                0.8),
                                                            fontSize: 10)),
                                                  ),
                                                  padding:
                                                  EdgeInsets.only(top: 50),
                                                )
                                              ],
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                            ),
                                          ],
                                        ),
                                      )),
                                ));
                          }
                        },
                      ));
                } else {
                  return Container(
                    height: 320,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }),
          StreamBuilder(
              stream: upcomingVisitorsRef.onValue,
              builder: (context, snap) {
                return Container(
                  padding: EdgeInsets.only(top: 10, left: 30),
                  child: Row(
                    children: <Widget>[
                      ButtonTheme(
                        height: 50,
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: new RaisedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllVisitorScreen(
                                        dbdata: snap.data.snapshot.value,
                                        dbref: allVisitorsRef)));
                          },
                          icon: Icon(Icons.more_horiz),
                          label: Text("See All"),
                          color: Colors.indigo,
                          textColor: Color.fromRGBO(255, 255, 255, 0.9),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ButtonTheme(
                  height: 50,
                  minWidth: 200,
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: new RaisedButton.icon(
                    onPressed: launchBottomSheet,
                    icon: Icon(Icons.add),
                    label: Text("Register"),
                    color: Colors.indigo,
                    textColor: Color.fromRGBO(255, 255, 255, 0.9),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class VisitorOverviewScreen extends StatefulWidget {
  final int cardCount;
  final dynamic dbdata;
  VisitorOverviewScreen({Key key, this.cardCount, this.dbdata})
      : super(key: key);
  @override
  _VisitorOverviewScreenState createState() => _VisitorOverviewScreenState();
}

class _VisitorOverviewScreenState extends State<VisitorOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    HapticFeedback.lightImpact();
    if (dateTimeValidation(
        widget.dbdata[widget.cardCount]['date'],
        widget.dbdata[widget.cardCount]['time'])) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Hero(
              tag: 'visitorCard' + widget.cardCount.toString(),
              child: Container(
                  height: 600,
                  width: 350,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.indigo[800],
                        Colors.indigo[400],
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(top: 25, left: 30),
                                child: new Material(
                                  color: Colors.transparent,
                                  child: Text('Visiting Date',
                                      style: TextStyle(
                                          color: Color.fromRGBO(255, 255, 255, 0.8))),
                                ))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(widget.dbdata[widget.cardCount]['date'],
                                    style: TextStyle(fontSize: 25)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(top: 18, left: 30),
                                child: new Material(
                                  color: Colors.transparent,
                                  child: Text('Visiting Time',
                                      style: TextStyle(
                                          color: Color.fromRGBO(255, 255, 255, 0.8))),
                                ))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(widget.dbdata[widget.cardCount]['time'],
                                    style: TextStyle(fontSize: 25)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text('Visitor Name',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.8))),
                              ),
                              padding: EdgeInsets.only(top: 18, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(widget.dbdata[widget.cardCount]['name'],
                                    style: TextStyle(fontSize: 25)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text('Visitor Company',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.8))),
                              ),
                              padding: EdgeInsets.only(top: 18, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(
                                    widget.dbdata[widget.cardCount]['company'],
                                    style: TextStyle(fontSize: 25)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text('IC Number',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.8))),
                              ),
                              padding: EdgeInsets.only(top: 18, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(widget.dbdata[widget.cardCount]['icno'],
                                    style: TextStyle(fontSize: 25)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text('Pass Level',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.8))),
                              ),
                              padding: EdgeInsets.only(top: 18, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(
                                    widget.dbdata[widget.cardCount]['level']
                                        .toString(),
                                    style: TextStyle(fontSize: 40)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text('Visit ID',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.8))),
                              ),
                              padding: EdgeInsets.only(top: 18, left: 30),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: new Material(
                                  color: Colors.transparent,
                                  child: new BarCodeImage(
                                    data: widget.dbdata[widget.cardCount]['visitid']
                                        .toString(),
                                    codeType: BarCodeType.Code39,
                                    lineWidth: 1.75,
                                    barHeight: 80.0,
                                    hasText: true,
                                    foregroundColor: Colors.white,
                                  )),
                              padding: EdgeInsets.only(top: 10),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: ButtonTheme(
                                height: 50,
                                minWidth: 150,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                                child: new RaisedButton.icon(
                                  onPressed: () {
                                    deleteRecord(widget.cardCount, context);
                                  },
                                  icon: Icon(Icons.delete),
                                  label: Text("Delete"),
                                  color: Colors.red,
                                  textColor: Color.fromRGBO(255, 255, 255, 0.9),
                                ),
                              ),
                              padding: EdgeInsets.only(top: 25, bottom: 25),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            )),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Hero(
              tag: 'visitorCard' + widget.cardCount.toString(),
              child: Container(
                  height: 600,
                  width: 350,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.red[800],
                        Colors.red[400],
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(top: 25, left: 30),
                                child: new Material(
                                  color: Colors.transparent,
                                  child: Text('Visiting Date',
                                      style: TextStyle(
                                          color: Color.fromRGBO(255, 255, 255, 0.8))),
                                ))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(widget.dbdata[widget.cardCount]['date'],
                                    style: TextStyle(fontSize: 25)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(top: 18, left: 30),
                                child: new Material(
                                  color: Colors.transparent,
                                  child: Text('Visiting Time',
                                      style: TextStyle(
                                          color: Color.fromRGBO(255, 255, 255, 0.8))),
                                ))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(widget.dbdata[widget.cardCount]['time'],
                                    style: TextStyle(fontSize: 25)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text('Visitor Name',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.8))),
                              ),
                              padding: EdgeInsets.only(top: 18, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(widget.dbdata[widget.cardCount]['name'],
                                    style: TextStyle(fontSize: 25)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text('Visitor Company',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.8))),
                              ),
                              padding: EdgeInsets.only(top: 18, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(
                                    widget.dbdata[widget.cardCount]['company'],
                                    style: TextStyle(fontSize: 25)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text('IC Number',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.8))),
                              ),
                              padding: EdgeInsets.only(top: 18, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(widget.dbdata[widget.cardCount]['icno'],
                                    style: TextStyle(fontSize: 25)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text('Pass Level',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.8))),
                              ),
                              padding: EdgeInsets.only(top: 18, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text(
                                    widget.dbdata[widget.cardCount]['level']
                                        .toString(),
                                    style: TextStyle(fontSize: 40)),
                              ),
                              padding: EdgeInsets.only(top: 5, left: 30),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: new Material(
                                color: Colors.transparent,
                                child: Text('Visit ID',
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.8))),
                              ),
                              padding: EdgeInsets.only(top: 18, left: 30),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: new Material(
                                  color: Colors.transparent,
                                  child: new BarCodeImage(
                                    data: widget.dbdata[widget.cardCount]['visitid']
                                        .toString(),
                                    codeType: BarCodeType.Code39,
                                    lineWidth: 1.75,
                                    barHeight: 80.0,
                                    hasText: true,
                                    foregroundColor: Colors.white,
                                  )),
                              padding: EdgeInsets.only(top: 10),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: ButtonTheme(
                                height: 50,
                                minWidth: 150,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                                child: new RaisedButton.icon(
                                  onPressed: () {
                                    deleteRecord(widget.cardCount, context);
                                  },
                                  icon: Icon(Icons.delete),
                                  label: Text("Delete"),
                                  color: Colors.red,
                                  textColor: Color.fromRGBO(255, 255, 255, 0.9),
                                ),
                              ),
                              padding: EdgeInsets.only(top: 25, bottom: 25),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            )),
      );
    }
  }
}

class AllVisitorScreen extends StatefulWidget {
  final dynamic dbdata;
  final dynamic dbref;
  AllVisitorScreen({Key key, this.dbdata, this.dbref}) : super(key: key);
  @override
  _AllVisitorScreenState createState() => _AllVisitorScreenState();
}

class _AllVisitorScreenState extends State<AllVisitorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: Text('Visitors',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              )),
          StreamBuilder(
            stream: widget.dbref.onValue,
            builder: (context, snap) {
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.snapshot.value != null) {
                return Container(
                    height: 520,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snap.data.snapshot.value.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>
                                        VisitorOverviewScreen(
                                            cardCount: index,
                                            dbdata: snap.data.snapshot.value),
                                    transitionDuration:
                                        Duration(milliseconds: 400),
                                  ));
                            },
                            child: Hero(
                              tag: 'visitorCard' + index.toString(),
                              child: Container(
                                  height: 200,
                                  width: 300,
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.indigo[800],
                                        Colors.indigo[400],
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                                padding: EdgeInsets.only(
                                                    top: 25, left: 30),
                                                child: new Material(
                                                  color: Colors.transparent,
                                                  child: Text('Visiting Date',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.8))),
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: new Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                    snap.data.snapshot
                                                        .value[index]['date'],
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                              ),
                                              padding: EdgeInsets.only(
                                                  top: 5, left: 30),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: new Material(
                                                color: Colors.transparent,
                                                child: Text('Visitor Name',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            255,
                                                            255,
                                                            255,
                                                            0.8))),
                                              ),
                                              padding: EdgeInsets.only(
                                                  top: 18, left: 30),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: new Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                    snap.data.snapshot
                                                        .value[index]['name'],
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                              ),
                                              padding: EdgeInsets.only(
                                                  top: 5, left: 30),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ));
                      },
                    ));
              } else {
                return Container(
                  height: 520,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ]));
  }
}

String createRecord() {
  var rng = new Random();
  var rngnum = "";
  for (var i = 0; i < 8; i++) {
    rngnum += rng.nextInt(10).toString();
  }
  return rngnum;
}

void deleteRecord(recordindex, context) {
  databaseReference.child('data').once().then((DataSnapshot snapshot) {
    var synclist = new List<dynamic>.from(snapshot.value);
    synclist.removeAt(recordindex);
    var newRecordRef = FirebaseDatabase.instance.reference().child('data/');
    newRecordRef.set(synclist).then((Future) {
      Navigator.pop(context);
    });
  });
}

bool dateTimeValidation(inputdate, inputtime) {
  var now = new DateTime.now();
  var testInput = inputdate + ' ' + inputtime +':00.000000';
  if (DateTime.parse(testInput).difference(now).isNegative){
    return false;
  } else {
    return true;
  }
}