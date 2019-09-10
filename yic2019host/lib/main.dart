import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
final databaseReference = FirebaseDatabase.instance.reference();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Product Sans'
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          Container(
            margin: EdgeInsets.only(left: 30,top: 10),
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context,index) {
                return Container(
                  height: 200,
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                );
              },
            )
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