import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/LoginPage.dart';
import 'package:flutter_firebase/Auth.dart';
import 'dart:async';

import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();

    _mockChekForSession().then((status) {
      if (status) {
        _navigateToHome();
      } else {
        _navigateToHome2();
      }
    });
  }

  Future<bool> _mockChekForSession() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});

    return false;
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void _navigateToHome2() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => Auth()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: 0.5,
              //child: Image.asset(''),
            ),
            Shimmer.fromColors(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'BlogApp',
                    style: TextStyle(
                        fontSize: 80.0,
                        fontFamily: 'Pacifico',
                        shadows: <Shadow>[
                          Shadow(
                              blurRadius: 18.0,
                              color: Colors.black87,
                              offset: Offset.fromDirection(120, 12))
                        ]),
                  ),
                ),
                baseColor: Color(0xff7f00ff),
                highlightColor: Color(0xffe100ff))
          ],
        ),
      ),
    );
  }
}
