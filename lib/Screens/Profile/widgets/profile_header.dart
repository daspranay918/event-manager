import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 52, // smaller
              ),

              const SizedBox(width: 8),

              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: "Event",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: "iva",
                      style: TextStyle(
                        color: AppColors.primaryGold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 22,
            ),
            Positioned(
              top: 1,
              right: 1,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGold,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 18),

        const Icon(
          Icons.more_vert,
          color: Colors.white,
          size: 22,
        ),
      ],
    );
  }
}