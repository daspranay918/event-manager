import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return PopScope(

      canPop: false,

      child: Scaffold(

        appBar: AppBar(
          title: const Text("Home"),
        ),

        body: const Center(

          child: Text(

            "Welcome To Eventora",

            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}