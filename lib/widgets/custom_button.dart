import 'package:flutter/material.dart';

import '../core/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),

        height: 54,
        width: double.infinity,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),

          gradient: const LinearGradient(
            colors: [Color(0xFFF6C453), Color(0xFFE0A82E)],
          ),

          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGold.withOpacity(0.35),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),

        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
