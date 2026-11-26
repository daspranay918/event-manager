import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Services/auth_service.dart';
import '../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool isGoogleLoading = false;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool agreeTerms = false;

  final AuthService _authService = AuthService();

  Future<void> register() async {
    final fullName = fullNameController.text.trim();

    final email = emailController.text.trim();

    final phone = phoneController.text.trim();

    final password = passwordController.text.trim();

    final confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));

      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email")),
      );

      return;
    }

    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number")),
      );

      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );

      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));

      return;
    }

    if (!agreeTerms) {
      showDialog(
        context: context,

        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF111827),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),

            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFF6C453)),

                SizedBox(width: 10),

                Text(
                  "Terms Required",

                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),

            content: const Text(
              "Please accept Terms & Conditions before creating your account.",

              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text(
                  "OK",

                  style: TextStyle(
                    color: Color(0xFFF6C453),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account Created Successfully. Please login.")),
        );

        context.go('/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> continueWithGoogle() async {
    try {
      setState(() {
        isGoogleLoading = true;
      });

      await _authService.continueWithGoogle(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isGoogleLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
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
                image: AssetImage("assets/images/background2.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// OVERLAY
          Container(color: Colors.black.withOpacity(0.84)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// TOP SECTION
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Image.asset("assets/images/logo.png", height: 78),

                        const SizedBox(height: 8),

                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Create ",

                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),

                              TextSpan(
                                text: "Account",

                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFF6C453),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Join Eventora and start creating\nunforgettable experiences.",

                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// FULL NAME
                    buildTextField(
                      controller: fullNameController,
                      hint: "Full Name",
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 11),

                    /// EMAIL
                    buildTextField(
                      controller: emailController,
                      hint: "Email Address",
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 11),

                    /// PHONE
                    buildTextField(
                      controller: phoneController,
                      hint: "Phone Number",
                      icon: Icons.phone_outlined,
                    ),

                    const SizedBox(height: 11),

                    /// PASSWORD
                    buildTextField(
                      controller: passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 11),

                    /// CONFIRM PASSWORD
                    buildTextField(
                      controller: confirmPasswordController,
                      hint: "Confirm Password",
                      icon: Icons.lock_outline,
                      isConfirmPassword: true,
                    ),

                    const SizedBox(height: 14),

                    /// TERMS
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              agreeTerms = !agreeTerms;
                            });
                          },

                          child: Container(
                            height: 20,
                            width: 20,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),

                              border: Border.all(color: Colors.white38),

                              color: agreeTerms
                                  ? const Color(0xFFF6C453)
                                  : Colors.transparent,
                            ),

                            child: agreeTerms
                                ? const Icon(
                                    Icons.check,

                                    size: 14,

                                    color: Colors.black,
                                  )
                                : null,
                          ),
                        ),

                        const SizedBox(width: 9),

                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "I agree to the ",

                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),

                                TextSpan(
                                  text: "Terms of Service",

                                  style: TextStyle(
                                    color: Color(0xFFF6C453),

                                    fontSize: 11,
                                  ),
                                ),

                                TextSpan(
                                  text: " and ",

                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),

                                TextSpan(
                                  text: "Privacy Policy",

                                  style: TextStyle(
                                    color: Color(0xFFF6C453),

                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// BUTTON
                    CustomButton(
                      text: "Create Account",
                      onTap: register,
                      isLoading: isLoading,
                    ),

                    const SizedBox(height: 16),

                    /// DIVIDER
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: Colors.white12),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),

                          child: Text(
                            "or sign up with",

                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 10.5,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(height: 1, color: Colors.white12),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// SOCIAL BUTTONS
                    Row(
                      children: [
                        /// GOOGLE
                        Expanded(
                          child: GestureDetector(
                            onTap: isGoogleLoading ? null : continueWithGoogle,

                            child: socialButton(
                              image: "assets/images/google.png",

                              text: "Google",
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        /// FACEBOOK
                        Expanded(
                          child: socialButton(
                            image: "assets/images/facebook.png",

                            text: "Facebook",
                          ),
                        ),

                        const SizedBox(width: 8),

                        /// APPLE
                        Expanded(
                          child: socialButton(
                            image: "assets/images/apple.png",

                            text: "Apple",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// LOGIN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Text(
                          "Already have an account?",

                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.5,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            context.go('/login');
                          },

                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 5),

                            minimumSize: const Size(0, 0),

                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),

                          child: const Text(
                            "Login",

                            style: TextStyle(
                              color: Color(0xFFF6C453),

                              fontWeight: FontWeight.bold,

                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,

    required String hint,

    required IconData icon,

    bool isPassword = false,

    bool isConfirmPassword = false,
  }) {
    return Container(
      height: 50,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),

        color: Colors.white.withOpacity(0.04),

        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
      ),

      child: TextField(
        controller: controller,

        obscureText: isPassword
            ? obscurePassword
            : isConfirmPassword
            ? obscureConfirmPassword
            : false,

        style: const TextStyle(color: Colors.white, fontSize: 13),

        cursorColor: const Color(0xFFF6C453),

        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,

          hintText: hint,

          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.45),

            fontSize: 12,
          ),

          contentPadding: const EdgeInsets.only(top: 15, left: 10),

          prefixIcon: Padding(
            padding: const EdgeInsets.all(6),

            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6C453).withOpacity(0.14),

                borderRadius: BorderRadius.circular(10),
              ),

              child: Icon(icon, color: const Color(0xFFF6C453), size: 22),
            ),
          ),

          prefixIconConstraints: const BoxConstraints(
            minWidth: 54,
            minHeight: 54,
          ),

          suffixIcon: isPassword || isConfirmPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      if (isPassword) {
                        obscurePassword = !obscurePassword;
                      }

                      if (isConfirmPassword) {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      }
                    });
                  },

                  icon: Icon(
                    isPassword
                        ? obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined
                        : obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,

                    color: Colors.white60,

                    size: 18,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget socialButton({required String image, required String text}) {
    return Container(
      height: 46,

      padding: const EdgeInsets.symmetric(horizontal: 8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),

        border: Border.all(color: Colors.white10),

        color: Colors.white.withValues(alpha:0.03),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Image.asset(image, height: 16),

          const SizedBox(width: 5),

          Text(
            text,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
