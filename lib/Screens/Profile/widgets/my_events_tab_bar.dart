import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';

class MyEventsTabBar extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const MyEventsTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xff11141A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10, width: .8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabItem(
              title: "Active",
              isSelected: selectedTab == 0,
              onTap: () => onTabChanged(0),
            ),
          ),

          const _Divider(),

          Expanded(
            child: _TabItem(
              title: "Upcoming",
              isSelected: selectedTab == 1,
              onTap: () => onTabChanged(1),
            ),
          ),

          const _Divider(),

          Expanded(
            child: _TabItem(
              title: "Past",
              isSelected: selectedTab == 2,
              onTap: () => onTabChanged(2),
            ),
          ),

          const _Divider(),

          Expanded(
            child: _TabItem(
              title: "Private",
              isSelected: selectedTab == 3,
              onTap: () => onTabChanged(3),
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
    return Container(width: .8, height: 28, color: Colors.white10);
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primaryGold : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(left: 8, right: 8, bottom: 2),
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGold : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
