import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

final databaseReference = FirebaseDatabase.instance.reference();
bool isAdmin = false;

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
    checkAdminStatus();
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
var ticketsRef = FirebaseDatabase.instance.reference().child('ticket');
var adminDataRef = FirebaseDatabase.instance.reference().child('admin_guard');

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

void checkAdminStatus() {
  final LocalStorage storage = new LocalStorage('adminPassword');
  databaseReference.child('admin_guard').once().then((DataSnapshot snapshot) {
    if (snapshot.value == storage.getItem('adminPassword')) {
      isAdmin = true;
    } else {
      isAdmin = false;
    }
  });
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
              margin: EdgeInsets.only(top: 20),
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
                          icon: Icon(Icons.warning),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TicketsScreen()));
                          },
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ),
            StreamBuilder(
              stream: ticketsRef.onValue,
              builder: (context, snap) {
                if (snap.hasData &&
                    !snap.hasError &&
                    snap.data.snapshot.value != null) {
                  int index1 = snap.data.snapshot.value.length - 1;
                  return GestureDetector(
                    onLongPress: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => TicketOverviewScreen(
                                ticketIndex:
                                    snap.data.snapshot.value.length - 1,
                                ticketData: snap.data.snapshot.value),
                            transitionDuration: Duration(milliseconds: 400),
                          ));
                    },
                    child: Hero(
                      tag: 'ticketcard' + index1.toString(),
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 15, 10),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                          snap.data.snapshot.value[
                                              snap.data.snapshot.value.length -
                                                  1]['status'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                      child: Text(snap.data.snapshot.value[
                                          snap.data.snapshot.value.length -
                                              1]['date']),
                                      padding: EdgeInsets.only(left: 10),
                                    ),
                                    Container(
                                      child: Text(snap.data.snapshot.value[
                                          snap.data.snapshot.value.length -
                                              1]['time']),
                                      padding: EdgeInsets.only(left: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(40, 0, 15, 10),
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  scrollDirection: prefix1.Axis.horizontal,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                            snap.data.snapshot.value[snap.data
                                                    .snapshot.value.length -
                                                1]['issue'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28)),
                                      ),
                                      Container(
                                        child: Text('at '),
                                        padding: EdgeInsets.only(left: 10),
                                      ),
                                      Container(
                                        child: Text(
                                            snap.data.snapshot.value[snap.data
                                                    .snapshot.value.length -
                                                1]['area'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text('Priority: '),
                                      ),
                                      Container(
                                        child: Text(
                                            snap
                                                .data
                                                .snapshot
                                                .value[snap.data.snapshot.value
                                                        .length -
                                                    1]['priority']
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
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
                  );
                }
              },
            ),
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
                                deleteRecord(widget.cardCount, context);
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
                                deleteRecord(widget.cardCount, context);
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
  final LocalStorage storage = new LocalStorage('adminPassword');
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
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
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
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: Row(
                        children: <Widget>[
                          Text('Admin Password: '),
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                    child: TextField(
                      autofocus: true,
                      controller: TextEditingController()
                        ..text = storage.getItem('adminPassword'),
                      onChanged: (inputtext) {
                        storage.setItem('adminPassword', inputtext);
                      },
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      )),
                    ),
                  )
                ],
              ),
            ),
          )
        ]));
  }
}

class TicketsScreen extends StatelessWidget {
  bool selectedAreaChip1 = false;
  bool selectedAreaChip2 = false;
  bool selectedAreaChip3 = false;
  bool selectedAreaChip4 = false;
  bool selectedAreaChip5 = false;
  bool selectedPriorityChip1 = false;
  bool selectedPriorityChip2 = false;
  bool selectedPriorityChip3 = false;
  String issueName;
  String selectedArea;
  int selectedPriority;

  void addTicketScreen(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: new Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 30),
                        child: Text('New Ticket',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 40, 40, 10),
                        child: TextField(
                          onChanged: (inputtext) {
                            issueName = inputtext;
                          },
                          decoration: InputDecoration(
                              labelText: 'Ticket Title',
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        height: 80,
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: prefix1.Axis.horizontal,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: ChoiceChip(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                label: Text('Area 1'),
                                selected: selectedAreaChip1,
                                onSelected: (selectedval) {
                                  selectedAreaChip1 = selectedval;
                                  selectedAreaChip2 = false;
                                  selectedAreaChip3 = false;
                                  selectedAreaChip4 = false;
                                  selectedAreaChip5 = false;
                                  selectedArea = 'Area 1';
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: ChoiceChip(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                label: Text('Area 2'),
                                selected: selectedAreaChip2,
                                onSelected: (selectedval) {
                                  selectedAreaChip2 = selectedval;
                                  selectedAreaChip1 = false;
                                  selectedAreaChip3 = false;
                                  selectedAreaChip4 = false;
                                  selectedAreaChip5 = false;
                                  selectedArea = 'Area 2';
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: ChoiceChip(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                label: Text('Area 3'),
                                selected: selectedAreaChip3,
                                onSelected: (selectedval) {
                                  selectedAreaChip3 = selectedval;
                                  selectedAreaChip1 = false;
                                  selectedAreaChip2 = false;
                                  selectedAreaChip4 = false;
                                  selectedAreaChip5 = false;
                                  selectedArea = 'Area 3';
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: ChoiceChip(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                label: Text('Area 4'),
                                selected: selectedAreaChip4,
                                onSelected: (selectedval) {
                                  selectedAreaChip4 = selectedval;
                                  selectedAreaChip1 = false;
                                  selectedAreaChip2 = false;
                                  selectedAreaChip3 = false;
                                  selectedAreaChip5 = false;
                                  selectedArea = 'Area 4';
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: ChoiceChip(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                label: Text('Area 5'),
                                selected: selectedAreaChip5,
                                onSelected: (selectedval) {
                                  selectedAreaChip5 = selectedval;
                                  selectedAreaChip1 = false;
                                  selectedAreaChip2 = false;
                                  selectedAreaChip3 = false;
                                  selectedAreaChip4 = false;
                                  selectedArea = 'Area 5';
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: ChoiceChip(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  padding: EdgeInsets.all(15),
                                  label: Text('1'),
                                  selected: selectedPriorityChip1,
                                  onSelected: (selectedval) {
                                    selectedPriorityChip1 = selectedval;
                                    selectedPriorityChip2 = false;
                                    selectedPriorityChip3 = false;
                                    selectedPriority = 1;
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: ChoiceChip(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  padding: EdgeInsets.all(15),
                                  label: Text('2'),
                                  selected: selectedPriorityChip2,
                                  onSelected: (selectedval) {
                                    selectedPriorityChip2 = selectedval;
                                    selectedPriorityChip1 = false;
                                    selectedPriorityChip3 = false;
                                    selectedPriority = 2;
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: ChoiceChip(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  padding: EdgeInsets.all(15),
                                  label: Text('3'),
                                  selected: selectedPriorityChip3,
                                  onSelected: (selectedval) {
                                    selectedPriorityChip3 = selectedval;
                                    selectedPriorityChip1 = false;
                                    selectedPriorityChip2 = false;
                                    selectedPriority = 3;
                                  },
                                ),
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: 40),
                        child: ButtonTheme(
                          height: 50,
                          minWidth: 200,
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: new RaisedButton.icon(
                            onPressed: () {
                              submitTickets(issueName, selectedArea,
                                  selectedPriority, context);
                            },
                            icon: Icon(Icons.send),
                            label: Text("Submit"),
                            color: Colors.indigo,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 30, 0, 30),
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Text('Tickets',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            child: StreamBuilder(builder: (context, snapshot) {
              checkAdminStatus();
              if (isAdmin == true) {
                return ButtonTheme(
                  height: 50,
                  minWidth: 250,
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: new RaisedButton.icon(
                    onPressed: () {
                      addTicketScreen(context);
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add Ticket"),
                    color: Colors.indigo,
                    textColor: Colors.white,
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(top: 0),
                );
              }
            }),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            height: 450,
            width: double.infinity,
            child: StreamBuilder(
              stream: ticketsRef.onValue,
              builder: (context, snap) {
                if (snap.hasData &&
                    !snap.hasError &&
                    snap.data.snapshot.value != null) {
                  return ListView.builder(
                      itemCount: snap.data.snapshot.value.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            HapticFeedback.lightImpact();
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) =>
                                      TicketOverviewScreen(
                                          ticketIndex: index,
                                          ticketData: snap.data.snapshot.value),
                                  transitionDuration:
                                      Duration(milliseconds: 400),
                                ));
                          },
                          child: Hero(
                            tag: 'ticketcard' + index.toString(),
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                height: 140,
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
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 20, 15, 10),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                                snap.data.snapshot.value[index]
                                                    ['status'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            child: Text(snap.data.snapshot
                                                .value[index]['date']),
                                            padding: EdgeInsets.only(left: 10),
                                          ),
                                          Container(
                                            child: Text(snap.data.snapshot
                                                .value[index]['time']),
                                            padding: EdgeInsets.only(left: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 0, 15, 10),
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        scrollDirection:
                                            prefix1.Axis.horizontal,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                  snap.data.snapshot
                                                      .value[index]['issue'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 28)),
                                            ),
                                            Container(
                                              child: Text('at '),
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                            Container(
                                              child: Text(
                                                  snap.data.snapshot
                                                      .value[index]['area'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 5, 0, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text('Priority: '),
                                            ),
                                            Container(
                                              child: Text(
                                                  snap.data.snapshot
                                                      .value[index]['priority']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  );
                }
              },
            ),
          ),
        ]));
  }
}

class TicketOverviewScreen extends StatefulWidget {
  final int ticketIndex;
  final dynamic ticketData;
  TicketOverviewScreen({Key key, this.ticketIndex, this.ticketData})
      : super(key: key);
  @override
  _TicketOverviewScreenState createState() => _TicketOverviewScreenState();
}

class _TicketOverviewScreenState extends State<TicketOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Hero(
            tag: 'ticketcard' + widget.ticketIndex.toString(),
            child: SingleChildScrollView(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 15, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                  widget.ticketData[widget.ticketIndex]
                                      ['status'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              child: Text(widget.ticketData[widget.ticketIndex]
                                  ['date']),
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              child: Text(widget.ticketData[widget.ticketIndex]
                                  ['time']),
                              padding: EdgeInsets.only(left: 10),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 0, 15, 10),
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: prefix1.Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                    widget.ticketData[widget.ticketIndex]
                                        ['issue'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28)),
                              ),
                              Container(
                                child: Text('at '),
                                padding: EdgeInsets.only(left: 10),
                              ),
                              Container(
                                child: Text(
                                    widget.ticketData[widget.ticketIndex]
                                        ['area'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Text('Priority: '),
                              ),
                              Container(
                                child: Text(
                                    widget.ticketData[widget.ticketIndex]
                                            ['priority']
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            StreamBuilder(builder: (context, snap) {
                              checkAdminStatus();
                              if (isAdmin == true) {
                                return ButtonTheme(
                                  height: 50,
                                  minWidth: 150,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: new RaisedButton.icon(
                                    onPressed: () {
                                      deleteTicket(widget.ticketIndex, context);
                                    },
                                    icon: Icon(Icons.delete),
                                    label: Text("Delete"),
                                    color: Colors.red,
                                    textColor: Colors.white,
                                  ),
                                );
                              } else if (widget.ticketData[widget.ticketIndex]
                              ['status'] == 'RESOLVED') {
                                return ButtonTheme(
                                  height: 50,
                                  minWidth: 150,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: new RaisedButton.icon(
                                    disabledColor: Colors.lightGreenAccent,
                                    icon: Icon(Icons.done_all),
                                    label: Text("Resolved"),
                                    color: Colors.green,
                                    textColor: Colors.white,
                                  ),
                                );
                              } else {
                                return ButtonTheme(
                                  height: 50,
                                  minWidth: 150,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: new RaisedButton.icon(
                                    onPressed: () {
                                      markResolve(widget.ticketIndex, context);
                                    },
                                    icon: Icon(Icons.done),
                                    label: Text("Resolve"),
                                    color: Colors.green,
                                    textColor: Colors.white,
                                  ),
                                );
                              }
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
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

void deleteRecord(recordindex, context) {
  databaseReference.child('data').once().then((DataSnapshot snapshot) {
    var synclist = new List<dynamic>.from(snapshot.value);
    synclist.removeAt(recordindex);
    var newRecordRef = FirebaseDatabase.instance.reference().child('data/');
    newRecordRef.set(synclist).then((future) {
      Navigator.pop(context);
    });
  });
}

void deleteTicket(ticketindex, context) {
  databaseReference.child('ticket').once().then((DataSnapshot snapshot) {
    var synclist = new List<dynamic>.from(snapshot.value);
    synclist.removeAt(ticketindex);
    var newRecordRef = FirebaseDatabase.instance.reference().child('ticket/');
    newRecordRef.set(synclist).then((future) {
      Navigator.pop(context);
    });
  });
}

void markResolve(ticketindex, context) {
  databaseReference.child('ticket').once().then((DataSnapshot snapshot) {
    var newRecordRef = FirebaseDatabase.instance
        .reference()
        .child('ticket/' + ticketindex.toString());
    newRecordRef.update({'status': 'RESOLVED'}).then((future) {
      Navigator.pop(context);
    });
  });
}

void submitTickets(issueName, issueArea, issuePriority, context) {
  var datenow = new DateTime.now();
  var df = new DateFormat('yyyy-MM-dd').format(datenow);
  var timenow = new TimeOfDay.now();
  var tf = timenow.hour.toString() + ":" + timenow.minute.toString();
  if (issueName != null && issueArea != null && issuePriority != null) {
    databaseReference.child('ticket').once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        var newTicketRef =
            FirebaseDatabase.instance.reference().child('ticket/0');
        newTicketRef.update({
          'area': issueArea,
          'issue': issueName,
          'priority': issuePriority.toString(),
          'date': df.toString(),
          'time': tf,
          'pic': '',
          'status': 'ONGOING',
        }).then((future) {
          Navigator.pop(context);
        });
      } else {
        var newTicketRef = FirebaseDatabase.instance
            .reference()
            .child('ticket/' + snapshot.value.length.toString());
        newTicketRef.update({
          'area': issueArea,
          'issue': issueName,
          'priority': issuePriority.toString(),
          'date': df.toString(),
          'time': tf,
          'pic': '',
          'status': 'ONGOING',
        }).then((future) {
          Navigator.pop(context);
        });
      }
    });
  }
}