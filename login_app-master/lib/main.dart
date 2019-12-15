import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Kisan_Hub/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
        accentColor: Color(0xffbbc91a), //circular progress colour
        primaryColor: Color(0xffbbc91a), //app bar colour etc
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;
  var myOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    animate();
  }

  void animate() {
    myOpacity = 1.0;
    setState(() {});
    Timer(Duration(seconds: 1), () {
      checkLoginStatus();
    });
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    if (token == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => DetailPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The Kisan Hub ", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: AnimatedOpacity(
                child: Image.asset(
                  "assets/kisan_hub.png",
                ),
                opacity: myOpacity,
                duration: Duration(seconds: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
