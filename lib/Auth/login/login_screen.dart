import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              "assets/images/background1.jpeg",
              fit: BoxFit.cover,
            ),
          ),

          /// DARK OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),

          /// MAIN CONTENT
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 70),

                      /// LOGO
                      Image.asset(
                        "assets/images/logo.png",
                        height: 190,
                      ),

                      const SizedBox(height: 10),

                      /// TITLE
                      const Text(
                        "Eventora",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Create. Plan. Celebrate.",
                        style: TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 30),

                      /// FEATURE ICONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Column(
                            children: [
                              Icon(Icons.event, color: Colors.orange),
                              SizedBox(height: 5),
                              Text("Create Events",
                                  style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.group, color: Colors.purple),
                              SizedBox(height: 5),
                              Text("Manage Guests",
                                  style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.explore, color: Colors.pink),
                              SizedBox(height: 5),
                              Text("Explore",
                                  style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// EMAIL FIELD
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon:
                          const Icon(Icons.email, color: Colors.orange),
                          hintText: "Email or Phone Number",
                          hintStyle:
                          const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF12263A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// PASSWORD FIELD
                      TextField(
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon:
                          const Icon(Icons.lock, color: Colors.orange),
                          suffixIcon: const Icon(Icons.visibility,
                              color: Colors.white54),
                          hintText: "Password",
                          hintStyle:
                          const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF12263A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// REMEMBER + FORGOT
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.end,
                        children: const [

                          Text("Forgot Password?",
                              style:
                              TextStyle(color: Colors.orange)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// LOGIN BUTTON
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFF8C14A),
                              Color(0xFFFFA726)
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Login →",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text("or continue with",
                          style:
                          TextStyle(color: Colors.white70)),

                      const SizedBox(height: 20),

                      /// SOCIAL BUTTONS
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          _socialBtn("Google"),
                          _socialBtn("Facebook"),
                          _socialBtn("Apple"),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// SIGN UP
                      const Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.white70),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style:
                              TextStyle(color: Colors.orange),
                            )
                          ],
                        ),
                      ),

                      const Spacer(), // 🔥 pushes content properly

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SOCIAL BUTTON
  Widget _socialBtn(String text) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF12263A),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}