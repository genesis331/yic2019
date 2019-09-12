import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
      ThemeData(primarySwatch: Colors.indigo, fontFamily: 'Open Sans'),
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
//  var upcomingVisitorsRef =
//  FirebaseDatabase.instance.reference().child('data').limitToFirst(5);

  @override
  void initState() {
    super.initState();
//    databaseReference.child('/data').once().then((DataSnapshot snapshot) {
//      return snapshot.value != null
//          ? Navigator.of(context).pushReplacement(PageRouteBuilder(
//        pageBuilder: (c, a1, a2) => HomePage(),
//        transitionsBuilder: (c, anim, a2, child) =>
//            FadeTransition(opacity: anim, child: child),
//        transitionDuration: Duration(milliseconds: 1500),
//      ))
//          : Scaffold.of(context).showSnackBar(SnackBar(
//          content:
//          Text('Please make sure you\'re connected to the Internet.')));
//    });
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
                    Text('for Clients',
                        style: TextStyle(color: Colors.white, fontSize: 22)),
//                    Container(
//                      padding: EdgeInsets.only(top: 50),
//                      child: CircularProgressIndicator(),
//                    )
                  ],
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          )),
    );
  }
}