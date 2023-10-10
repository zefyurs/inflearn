import 'package:flutter/material.dart';
import 'package:inflearn/common/view/splash_screen.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const Scaffold(backgroundColor: Colors.white, body: SplashScreen()),
    );
  }
}
