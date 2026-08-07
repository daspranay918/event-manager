import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:next_meet/Screens/Profile/widgets/logout_button.dart';
import 'package:next_meet/Screens/Profile/widgets/profile_actions.dart';
import 'package:next_meet/Screens/Profile/widgets/profile_section.dart';
import 'package:next_meet/Screens/Profile/widgets/profile_stats.dart';
import 'package:next_meet/Screens/Profile/widgets/profile_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;

      // Navigate to Login Screen
      // Replace with your route
      context.go('/login');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090909),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            children: [
              /// Header
              const ProfileHeader(),

              // SizedBox(height: 5),
              const ProfileInfo(),

              const SizedBox(height: 12),

              const ProfileActions(),

              const SizedBox(height: 8),

              const ProfileStats(),
              const SizedBox(height: 8),
              const ProfileSection(
                title: "Account",
                children: [
                  ProfileTile(
                    icon: Icons.person_outline,
                    title: "Personal Information",
                  ),
                  ProfileTile(
                    icon: Icons.confirmation_number_outlined,
                    title: "My Tickets",
                  ),
                  ProfileTile(
                    icon: Icons.favorite_border,
                    title: "Saved Events",
                  ),
                  ProfileTile(icon: Icons.history, title: "Event History"),
                ],
              ),

              const SizedBox(height: 8),

              ProfileSection(
                title: "Organizer",
                children: [
                  ProfileTile(
                    icon: Icons.calendar_month_outlined,
                    title: "My Events",
                    onTap: (){
                      context.push('/my-events');
                    },
                  ),
                  const ProfileTile(
                    icon: Icons.bar_chart_outlined,
                    title: "Analytics",
                  ),
                  const ProfileTile(
                    icon: Icons.star_border_rounded,
                    title: "Reviews",
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const ProfileSection(
                title: "Settings",
                children: [
                  ProfileTile(
                    icon: Icons.notifications_none_outlined,
                    title: "Notifications",
                  ),
                  ProfileTile(
                    icon: Icons.lock_outline_rounded,
                    title: "Privacy & Security",
                  ),
                  ProfileTile(
                    icon: Icons.help_outline_rounded,
                    title: "Help & Support",
                  ),
                  ProfileTile(
                    icon: Icons.description_outlined,
                    title: "Terms & Policies",
                  ),
                ],
              ),

              const SizedBox(height: 8),

              LogoutButton(
                onTap: logout,
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
