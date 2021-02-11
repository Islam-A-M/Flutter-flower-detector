import '../screens/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart' as splash;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return splash.SplashScreen(
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text(
        'Flower Recognizer',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.white,
        ),
      ),
      image: Image.asset('assets/flower.png'),
      gradientBackground: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.004, 1],
          colors: [Color(0xFFa8c063), Color(0xFF56ab2f)]),
      photoSize: 50,
      loaderColor: Colors.white,
    );
  }
}
