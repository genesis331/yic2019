import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';

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
          pageBuilder: (c, a1, a2) => HomeScreen(),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 1000)));
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
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold)),
                Text('for Guards',
                    style: TextStyle(color: Colors.white, fontSize: 22)),
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

var allVisitorsRef = FirebaseDatabase.instance.reference().child('data');

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 30, 0, 30),
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: Text('Dashboard',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 250,
                    height: 60,
                    child: ButtonTheme(
                      height: 50,
                      minWidth: double.infinity,
                      shape: new RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: new RaisedButton.icon(
                        onPressed: () {
                          databaseReference
                              .child('data')
                              .once()
                              .then((DataSnapshot snapshot) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllVisitorScreen(
                                        dbdata: snapshot.value,
                                        dbref: allVisitorsRef)));
                          });
                        },
                        icon: Icon(Icons.remove_red_eye),
                        label: Text("See Visitors"),
                        color: Colors.indigo,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Colors.indigo,
                      ),
                      child: ButtonTheme(
                        height: 50,
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsScreen()));
                          },
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 10, right: 10),
              height: 140,
              width: double.infinity,
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
            )
          ],
        ));
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
    if (dateTimeValidation(widget.dbdata[widget.cardCount]['date'],
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
                                  style: TextStyle(color: Colors.white)),
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
                                  style: TextStyle(color: Colors.white)),
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
                                style: TextStyle(color: Colors.white)),
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
                                style: TextStyle(color: Colors.white)),
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
                                style: TextStyle(color: Colors.white)),
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
                                style: TextStyle(color: Colors.white)),
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
                                print('Test');
                              },
                              icon: Icon(Icons.delete),
                              label: Text("Delete"),
                              color: Colors.red,
                              textColor: Colors.white,
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
                                  style: TextStyle(color: Colors.white)),
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
                                  style: TextStyle(color: Colors.white)),
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
                                style: TextStyle(color: Colors.white)),
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
                                style: TextStyle(color: Colors.white)),
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
                                style: TextStyle(color: Colors.white)),
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
                                style: TextStyle(color: Colors.white)),
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
                                print('Test');
                              },
                              icon: Icon(Icons.delete),
                              label: Text("Delete"),
                              color: Colors.red,
                              textColor: Colors.white,
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
                      scrollDirection: prefix0.Axis.vertical,
                      itemCount: snap.data.snapshot.value.length,
                      itemBuilder: (context, index) {
                        if (dateTimeValidation(
                            snap.data.snapshot.value[index]['date'],
                            snap.data.snapshot.value[index]['time'])) {
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
                                                                Colors.white)),
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
                                                          color: Colors.white)),
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
                        } else {
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
                                                                Colors.white)),
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
                                                          color: Colors.white)),
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
                        }
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

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 30, 0, 30),
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Text('Settings',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
          ),
        ]));
  }
}

bool dateTimeValidation(inputdate, inputtime) {
  var now = new DateTime.now();
  var testInput = inputdate + ' ' + inputtime + ':00.000000';
  if (DateTime.parse(testInput).difference(now).isNegative) {
    return false;
  } else {
    return true;
  }
}
