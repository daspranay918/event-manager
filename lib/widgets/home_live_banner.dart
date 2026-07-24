import 'package:flutter/material.dart';

class HomeLiveBanner extends StatelessWidget {
  const HomeLiveBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white24,
        width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Image.asset(
            "assets/images/banner.jpg", // <-- Replace with your image
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}