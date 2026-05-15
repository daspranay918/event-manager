import 'package:flutter/material.dart';
import 'package:next_meet/Screens/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(), // 🔁 change this
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background2.jpeg"), // 🔁 replace
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🔹 Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          /// 🔹 Main Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                /// 🔹 Center Content
                Column(
                  children: [
                    const SizedBox(height: 80),

                    /// 🔹 Logo
                    Image.asset(
                      "assets/images/logo.png", // 🔁 replace
                      height: 220,
                    ),

                    const SizedBox(height: 10),

                    /// 🔹 App Name
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Event",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: "ora",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD700), // gold
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// 🔹 Divider Line
                    Container(
                      width: 150,
                      height: 2,
                      color: const Color(0xFFFFD700),
                    ),

                    const SizedBox(height: 10),

                    /// 🔹 Tagline
                    const Text(
                      "CREATE. PLAN. CELEBRATE.",
                      style: TextStyle(
                        color: Colors.white70,
                        letterSpacing: 2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                /// 🔹 Bottom Section
                Column(
                  children: [

                    /// 🔹 Icons Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.calendar_today, color: Color(0xFFFFD700)),
                          Icon(Icons.people, color: Color(0xFFFFD700)),
                          Icon(Icons.confirmation_num, color: Color(0xFFFFD700)),
                          Icon(Icons.celebration, color: Color(0xFFFFD700)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 Indicator Line
                    Container(
                      height: 2,
                      width: 200,
                      color: Colors.white24,
                    ),

                    const SizedBox(height: 10),

                    /// 🔹 Dots Indicator
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     buildDot(true),
                    //     buildDot(false),
                    //     buildDot(false),
                    //   ],
                    // ),

                    const SizedBox(height: 30),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Dot Widget
  // static Widget buildDot(bool isActive) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 5),
  //     width: isActive ? 10 : 8,
  //     height: isActive ? 10 : 8,
  //     decoration: BoxDecoration(
  //       color: isActive ? const Color(0xFFFFD700) : Colors.white38,
  //       shape: BoxShape.circle,
  //     ),
  //   );
  // }
}
