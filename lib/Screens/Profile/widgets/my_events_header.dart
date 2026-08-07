import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:next_meet/core/theme.dart';

class MyEventsHeader extends StatelessWidget {
  const MyEventsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => context.pop(),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),

        const SizedBox(width: 14),

        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: "My ",
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: "Events",
                style: TextStyle(color: AppColors.primaryGold),
              ),
            ],
          ),
        ),

        const Spacer(),

        Image.asset(
          "assets/images/logo.png",
          height: 52,
        ),
      ],
    );
  }
}