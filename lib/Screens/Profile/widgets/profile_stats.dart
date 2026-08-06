import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xff12141B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x14FFFFFF),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _StatItem(
              value: "12",
              title: "Events",
            ),
          ),

          _Divider(),

          Expanded(
            child: _StatItem(
              value: "240",
              title: "Followers",
            ),
          ),

          _Divider(),

          Expanded(
            child: _StatItem(
              value: "180",
              title: "Following",
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 42,
      color: Colors.white10,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String title;

  const _StatItem({
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primaryGold,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 4),

        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}