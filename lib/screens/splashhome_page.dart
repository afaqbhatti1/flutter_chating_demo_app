import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:class_mates/screens/home_page.dart';
import 'package:flutter/material.dart';

class SplashPageHome extends StatefulWidget {
  const SplashPageHome({super.key});

  @override
  State<SplashPageHome> createState() => _SplashPageHomeState();
}

class _SplashPageHomeState extends State<SplashPageHome> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        "assets/logo_app.png",
        width: MediaQuery.of(context).size.width * 0.7,
      ),
      nextScreen: const HomePage(),
      duration: 5,
      splashIconSize: 200,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
