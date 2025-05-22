import 'package:flutter/material.dart';
import 'package:awamer/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF4F0FF),
        primaryColor: Color(0xFF3F4E70),
        fontFamily: 'Arial',
      ),
      home: LoginScreen(),
    );
  }
}
