import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:next_meet/Auth/login/login_screen.dart';
import 'package:next_meet/Screens/home_screen.dart';
import 'package:next_meet/Screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventora',
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home:const SplashScreen(),
    );
  }
}

