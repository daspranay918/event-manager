import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Stack(
          clipBehavior: Clip.none,
          children: [

            Container(
              width: 110,
              height: 110,
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryGold,
                  width: 1.3,
                ),
              ),
              child: const CircleAvatar(
                backgroundImage: NetworkImage('https://i.pinimg.com/736x/7f/b6/05/7fb60538564ceef755080d388a5148ea.jpg'),
              ),
            ),

            Positioned(
              right: -2,
              bottom: 8,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        const Text(
          "Pranay Das",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          "Flutter Developer",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [

            Icon(
              Icons.location_on_outlined,
              size: 17,
              color: AppColors.primaryGold,
            ),

            SizedBox(width: 4),

            Text(
              "Jaipur, Rajasthan",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}