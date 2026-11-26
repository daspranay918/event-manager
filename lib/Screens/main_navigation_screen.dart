import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_meet/Screens/create_event_screen.dart';
import 'package:next_meet/Screens/explore_screen.dart';
import 'package:next_meet/Screens/home_screen.dart';
import 'package:next_meet/Screens/live_screen.dart';
import 'package:next_meet/Screens/Profile/profile_screen.dart';
import 'package:next_meet/providers/bottom_nav_provider.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    final screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const CreateEventScreen(),
      const LiveScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          ref.read(bottomNavProvider.notifier).state = index;
        },

        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Home'),

          BottomNavigationBarItem(
            icon: Icon(Icons.explore), 
            label: 'Discover'),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Create',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv), 
            label: 'Live'),

          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Profile'),
        ],
      ),
    );
  }
}
