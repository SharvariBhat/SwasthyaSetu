import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(SwasthyaSetuApp());
}

class SwasthyaSetuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwasthyaSetu',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: LoginScreen(),
    );
  }
}