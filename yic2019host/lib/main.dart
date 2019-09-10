import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
final databaseReference = FirebaseDatabase.instance.reference();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Product Sans'
      ),
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var upcomingVisitorsRef = FirebaseDatabase.instance.reference().child('data').limitToFirst(5);

  @override
  void initState() {
    super.initState();
      databaseReference.child('/data').once().then((DataSnapshot snapshot) {
        return snapshot.value != null ?
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => HomePage(),
                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 1500),
          )
        )
            : print('Fail bij');
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
                  Text('IntelliGuard',style: TextStyle(color: Colors.white,fontSize: 38,fontWeight: FontWeight.bold)),
                  Text('for Hosts',style: TextStyle(color: Colors.white,fontSize: 22)),
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(),
                  )
                ],
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        )
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var upcomingVisitorsRef = FirebaseDatabase.instance.reference().child('data').limitToFirst(5);

  void launchBottomSheet() {
    showModalBottomSheet(context: context, builder: (BuildContext context) => Container(
      height: 100,
      color: Color(0xFF000000),
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),topRight: Radius.circular(30.0))
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(' Dashboard',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
            )
          ),
          Container(
            margin: EdgeInsets.only(left: 35),
            child: Row(
              children: <Widget>[
                Text("Upcoming Visitors",style: TextStyle(color: Colors.white),textAlign: TextAlign.left)
              ],
            )
          ),
          StreamBuilder(
            stream: upcomingVisitorsRef.onValue,
            builder: (context,snap) {
              return snap.data.snapshot.value == null
                  ? SizedBox(
                      height: 350,
                    )
                  : Container(
                  margin: EdgeInsets.only(left: 30,top: 10),
                  height: 350,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snap.data.snapshot.value.length - 1,
                    itemBuilder: (context,index) {
                      return Container(
                          height: 250,
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
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Container(
//                        padding: EdgeInsets.only(top: 25,left: 30),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(top: 25,left: 30),
                                      child: Text('Visiting Date',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8))),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(snap.data.snapshot.value[index + 1]['date'],style: TextStyle(color: Colors.white,fontSize: 25)),
                                      padding: EdgeInsets.only(top: 5,left: 30),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text('Visitor Name',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8))),
                                      padding: EdgeInsets.only(top: 18,left: 30),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(snap.data.snapshot.value[index + 1]['name'],style: TextStyle(color: Colors.white,fontSize: 25)),
                                      padding: EdgeInsets.only(top: 5,left: 30),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text('Visitor Company',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8))),
                                      padding: EdgeInsets.only(top: 18,left: 30),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(snap.data.snapshot.value[index + 1]['company'],style: TextStyle(color: Colors.white,fontSize: 25)),
                                      padding: EdgeInsets.only(top: 5,left: 30),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text('Level Pass',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8))),
                                      padding: EdgeInsets.only(top: 18,left: 30),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(snap.data.snapshot.value[index + 1]['level'].toString(),style: TextStyle(color: Colors.white,fontSize: 40)),
                                      padding: EdgeInsets.only(top: 5,left: 30),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text('Press card to do more',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8),fontSize: 10)),
                                      padding: EdgeInsets.only(top: 25),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ],
                            ),
                          )
                      );
                    },
                  )
              );
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 10,left: 30),
            child: Row(
              children: <Widget>[
                ButtonTheme(
                  height: 50,
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: new RaisedButton.icon(onPressed: launchBottomSheet, icon: Icon(Icons.more_horiz), label: Text("See All"),color: Colors.indigo,textColor: Color.fromRGBO(255, 255, 255, 0.9),),
                )
              ],
            ),
          ),
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
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: new RaisedButton.icon(onPressed: launchBottomSheet, icon: Icon(Icons.add), label: Text("Register"),color: Colors.indigo,textColor: Color.fromRGBO(255, 255, 255, 0.9),),
              )
            ],
          ),
        )
      ),
    );
  }
}

dynamic readRecord(){
  var receivedData;
  databaseReference.child('/data').once().then((DataSnapshot snapshot) {
    receivedData = snapshot.value;
    for (var o = 1 ; o <= receivedData.length - 1; o++) {
      print(receivedData[o]);
    }
  });
}

void createRecord(){
  var rng = new Random();
  var rngnum = "";
  for (var i = 0; i < 8; i++) {
    rngnum += rng.nextInt(10).toString();
  }
  print(rngnum);
}