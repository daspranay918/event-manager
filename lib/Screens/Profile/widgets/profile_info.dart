import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key, required this.profile, required this.onEdit});

  final Map<String, dynamic> profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final avatar = (profile['avatar_url'] as String? ?? '').trim();
    final summary = ['occupation', 'organization', 'location']
        .map((key) => (profile[key] as String? ?? '').trim())
        .where((value) => value.isNotEmpty)
        .join(' · ');
    final bio = (profile['bio'] as String? ?? '').trim();

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: AppColors.gold,
              child: CircleAvatar(
                radius: 53,
                backgroundColor: AppColors.secondaryDark,
                foregroundImage: avatar.isEmpty ? null : NetworkImage(avatar),
                child: const Icon(Icons.person_outline, color: AppColors.gold, size: 44),
              ),
            ),
            Positioned(
              right: -4,
              bottom: 0,
              child: IconButton.filled(
                tooltip: 'Edit profile photo',
                onPressed: onEdit,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Icons.photo_camera_outlined, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          profile['full_name'] as String? ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        if (summary.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(summary, textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey)),
        ],
        if (bio.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(bio, textAlign: TextAlign.center),
        ],
      ],
    );
  }
}
