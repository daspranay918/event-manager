import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          /// Header
          Row(
            children: [
              const Icon(
                Icons.grid_view_outlined,
                color: AppColors.primaryGold,
                size: 18,
              ),
      
              const SizedBox(width: 8),
      
              const Text(
                "Categories",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      
            ],
          ),
      
          const SizedBox(height: 10),
      
          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _CategoryCard(
                  icon: Icons.school_outlined,
                  title: "College",
                  color: Color(0xffF4B400),
                ),
                SizedBox(width: 12),
      
                _CategoryCard(
                  icon: Icons.menu_book_outlined,
                  title: "School",
                  color: Color(0xff9333EA),
                ),
                SizedBox(width: 12),
      
                _CategoryCard(
                  icon: Icons.palette_outlined,
                  title: "Art & Culture",
                  color: Color(0xffEF4444),
                ),
                SizedBox(width: 12),
      
                _CategoryCard(
                  icon: Icons.music_note_outlined,
                  title: "Music",
                  color: Color(0xff22C55E),
                ),
                SizedBox(width: 12),
      
                _CategoryCard(
                  icon: Icons.sports_soccer_outlined,
                  title: "Sports",
                  color: Color(0xff3B82F6),
                ),
                SizedBox(width: 12),
      
                _CategoryCard(
                  icon: Icons.computer_outlined,
                  title: "Tech",
                  color: Color(0xffFB923C),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white10,
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}