import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> login() async {

    final email =
        emailController.text.trim();

    final password =
        passwordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      await AuthService().signIn(
        email: email,
        password: password,
      );

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Login Successful",
            ),
          ),
        );

        context.go('/home');
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [

          /// BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/background2.jpeg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// DARK OVERLAY
          Container(
            color: Colors.black
                .withOpacity(0.84),
          ),

          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  /// TOP SECTION
                  Center(
                    child: Column(
                      children: [

                        Image.asset(
                          "assets/images/logo.png",
                          height: 95,
                        ),

                        const SizedBox(height: 2),

                        RichText(
                          text: const TextSpan(
                            children: [

                              TextSpan(
                                text: "Event",

                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight:
                                      FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),

                              TextSpan(
                                text: "iva",

                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight:
                                      FontWeight.w700,
                                  color:
                                      Color(0xFFF6C453),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 5),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: [

                            Container(
                              width: 35,
                              height: 1,
                              color:
                                  const Color(
                                0xFFF6C453,
                              ),
                            ),

                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(
                                horizontal: 8,
                              ),

                              child: Text(
                                "WE PLAN • YOU CELEBRATE",

                                style: TextStyle(
                                  color:
                                      Colors.white70,
                                  fontSize: 9,
                                  letterSpacing: 1,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),
                            ),

                            Container(
                              width: 35,
                              height: 1,
                              color:
                                  const Color(
                                0xFFF6C453,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 7),

                        const Text(
                          "All Types of Social, Private &\nCorporate Event Management",

                          textAlign:
                              TextAlign.center,

                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10.5,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// WELCOME
                  const Text(
                    "Welcome Back!",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    "Login to continue",

                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// EMAIL FIELD
                  buildTextField(
                    controller:
                        emailController,

                    hint:
                        "Email or Phone Number",

                    icon:
                        Icons.person_outline,
                  ),

                  const SizedBox(height: 10),

                  /// PASSWORD FIELD
                  buildTextField(
                    controller:
                        passwordController,

                    hint: "Password",

                    icon:
                        Icons.lock_outline,

                    isPassword: true,
                  ),

                  const SizedBox(height: 6),

                  /// FORGOT PASSWORD
                  Align(
                    alignment:
                        Alignment.centerRight,

                    child: TextButton(

                      onPressed: () {},

                      style:
                          TextButton.styleFrom(
                        padding:
                            EdgeInsets.zero,

                        minimumSize:
                            const Size(0, 0),

                        tapTargetSize:
                            MaterialTapTargetSize
                                .shrinkWrap,
                      ),

                      child: const Text(
                        "Forgot Password?",

                        style: TextStyle(
                          color: Color(
                            0xFFF6C453,
                          ),

                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// LOGIN BUTTON
                  CustomButton(
                    text: "Login",
                    onTap: login,
                    isLoading:
                        isLoading,
                  ),

                  const SizedBox(height: 14),

                  /// DIVIDER
                  Row(
                    children: [

                      Expanded(
                        child: Container(
                          height: 1,
                          color:
                              Colors.white12,
                        ),
                      ),

                      const Padding(
                        padding:
                            EdgeInsets.symmetric(
                          horizontal: 8,
                        ),

                        child: Text(
                          "or continue with",

                          style: TextStyle(
                            color:
                                Colors.white60,
                            fontSize: 10.5,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          height: 1,
                          color:
                              Colors.white12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// SOCIAL BUTTONS
                  Row(
                    children: [

                      /// GOOGLE
                      Expanded(
                        child:
                            GestureDetector(

                          onTap: () {},

                          child:
                              socialButton(
                            image:
                                "assets/images/google.png",

                            text:
                                "Google",
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      /// FACEBOOK
                      Expanded(
                        child:
                            socialButton(
                          image:
                              "assets/images/facebook.png",

                          text:
                              "Facebook",
                        ),
                      ),

                      const SizedBox(width: 8),

                      /// APPLE
                      Expanded(
                        child:
                            socialButton(
                          image:
                              "assets/images/apple.png",

                          text:
                              "Apple",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// REGISTER
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [

                      const Text(
                        "Don't have an account?",

                        style: TextStyle(
                          color:
                              Colors.white70,
                          fontSize: 12.5,
                        ),
                      ),

                      TextButton(

                        onPressed: () {
                          context.go(
                              '/register');
                        },

                        style:
                            TextButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:
                                6,
                          ),

                          minimumSize:
                              const Size(
                            0,
                            0,
                          ),

                          tapTargetSize:
                              MaterialTapTargetSize
                                  .shrinkWrap,
                        ),

                        child: const Text(
                          "Sign Up",

                          style: TextStyle(
                            color: Color(
                              0xFFF6C453,
                            ),

                            fontWeight:
                                FontWeight
                                    .bold,

                            fontSize:
                                12.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({

    required TextEditingController
        controller,

    required String hint,

    required IconData icon,

    bool isPassword = false,
  }) {

    return Container(

      height: 51,

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(15),

        color: Colors.white
            .withOpacity(0.04),

        border: Border.all(
          color: Colors.white
              .withOpacity(0.06),

          width: 1,
        ),
      ),

      child: TextField(

        controller: controller,

        obscureText:
            isPassword
                ? obscurePassword
                : false,

        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),

        cursorColor:
            const Color(0xFFF6C453),

        decoration: InputDecoration(

          border: InputBorder.none,
          enabledBorder:
              InputBorder.none,
          focusedBorder:
              InputBorder.none,
          disabledBorder:
              InputBorder.none,

          hintText: hint,

          hintStyle: TextStyle(
            color: Colors.white
                .withOpacity(0.45),

            fontSize: 12,
          ),

          contentPadding:
              const EdgeInsets.only(
            top: 16,
            left: 10,
          ),

          prefixIcon: Padding(
            padding:
                const EdgeInsets.all(6),

            child: Container(
              decoration: BoxDecoration(
                color:
                    const Color(0xFFF6C453)
                        .withOpacity(
                  0.14,
                ),

                borderRadius:
                    BorderRadius
                        .circular(10),
              ),

              child: Icon(
                icon,

                color:
                    const Color(0xFFF6C453),

                size: 22,
              ),
            ),
          ),

          prefixIconConstraints:
              const BoxConstraints(
            minWidth: 54,
            minHeight: 54,
          ),

          suffixIcon:
              isPassword

                  ? IconButton(

                      onPressed: () {

                        setState(() {
                          obscurePassword =
                              !obscurePassword;
                        });
                      },

                      icon: Icon(
                        obscurePassword
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,

                        color:
                            Colors.white60,

                        size: 18,
                      ),
                    )

                  : null,
        ),
      ),
    );
  }

  Widget socialButton({

    required String image,

    required String text,
  }) {

    return Container(

      height: 46,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
      ),

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(13),

        border: Border.all(
          color: Colors.white10,
        ),

        color: Colors.white
            .withOpacity(0.03),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Image.asset(
            image,
            height: 16,
          ),

          const SizedBox(width: 5),

          Text(
            text,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10.5,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}