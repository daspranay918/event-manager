import 'package:flutter/material.dart';
import 'profile_tile.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<ProfileTile> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff11141A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white10,
          width: .8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 6,
        ),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            ...List.generate(
              children.length,
              (index) => Column(
                children: [

                  children[index],

                  if (index != children.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 1,
                        thickness: .5,
                        color: Colors.white10,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}