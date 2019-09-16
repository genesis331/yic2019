import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
      ThemeData(primarySwatch: Colors.indigo, fontFamily: 'Open Sans',textTheme: TextTheme(body1: TextStyle(color: Colors.white))),
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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('Hello World'),
        )
    );
  }
}