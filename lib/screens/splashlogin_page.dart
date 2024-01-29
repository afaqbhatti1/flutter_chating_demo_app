import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:class_mates/screens/login_page.dart';
import 'package:flutter/material.dart';

class SplashLoginPage extends StatefulWidget {
  const SplashLoginPage({super.key});

  @override
  State<SplashLoginPage> createState() => _SplashLoginPageState();
}

class _SplashLoginPageState extends State<SplashLoginPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        "assets/logo_app.png",
        width: MediaQuery.of(context).size.width * 0.7,
      ),
      nextScreen: const LoginPage(),
      duration: 4,
      splashIconSize: 200,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
