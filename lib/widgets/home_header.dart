import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Logo + Text
        Expanded(
          child: Row(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 42,
              ),

              const SizedBox(width: 5),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: "Event",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: "ora",
                          style: TextStyle(
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // const SizedBox(height: 1),

                  const Text(
                    "Discover. Create. Celebrate.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Icon(
          Icons.search,
          color: Colors.white,
          size: 24,
        ),

        const SizedBox(width: 18),

        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 24,
            ),

            Positioned(
              top: 1,
              right: 0,
              child: Container(
                width: 9,
                height: 9,
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
          size: 24,
        ),
      ],
    );
  }
}