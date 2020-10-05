import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/LoginPage.dart';
import 'package:local_auth/local_auth.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  LocalAuthentication _auth = LocalAuthentication();
  bool _checkBio = false;
  bool _isBioFinger = false;

  void initState() {
    super.initState();
    _checkBiometrics();
    _listBioAndFindFingerType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Biometric'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.fingerprint,
                size: 50,
              ),
              onPressed: _starAuth,
              iconSize: 60,
            ),
            SizedBox(
              height: 15,
            ),
            Text('Authenticate'),
          ],
        ),
      ),
    );
  }

  void _checkBiometrics() async {
    try {
      final bio = await _auth.canCheckBiometrics;
      setState(() {
        _checkBio = bio;
      });
      print('Biometrics = $_checkBio');
    } catch (e) {}
  }

  void _listBioAndFindFingerType() async {
    List<BiometricType> _listType;
    try {
      _listType = await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e.message);
    }
    print('List Biometrics = $_listType');

    if (_listType.contains(BiometricType.fingerprint)) {
      setState(() {
        _isBioFinger = true;
      });
      print('Fingerprint is $_isBioFinger');
    }
  }

  void _starAuth() async {
    bool _isAuthenticated = false;
    try {
      _isAuthenticated = await _auth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint',
        useErrorDialogs: true,
        stickyAuth: true,
        //androidAuthStrings: null,
        //iOSAuthStrings: null,
      );
    } on PlatformException catch (e) {
      print(e.message);
    }
    if (_isAuthenticated) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => LoginPage()));
    }
  }
}
