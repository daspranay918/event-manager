import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _ActionButton(
            icon: Icons.edit_outlined,
            text: "Edit Profile",
          ),
        ),

        SizedBox(width: 14),

        Expanded(
          child: _ActionButton(
            icon: Icons.share_outlined,
            text: "Share Profile",
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ActionButton({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},

      child: Container(
        height: 43,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color.fromARGB(255, 188, 133, 14),
            width: 1,
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              color: AppColors.primaryGold,
              size: 18,
            ),

            const SizedBox(width: 8),

            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}