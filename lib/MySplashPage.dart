import 'package:flutter/material.dart';
import 'package:voicebot/HomePage.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashPage extends StatefulWidget {


  @override
  State<MySplashPage> createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 7,
      navigateAfterSeconds: Homepage() ,
      imageBackground: Image.asset("assets/back.png").image,
      useLoader: true,
      loaderColor: Colors.pink,
      loadingText: Text("Loading..", style: TextStyle(color: Colors.white),),

    );
  }
}
