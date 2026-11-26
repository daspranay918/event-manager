import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:next_meet/Screens/Profile/widgets/logout_button.dart';
import 'package:next_meet/Screens/Profile/widgets/profile_actions.dart';
import 'package:next_meet/Screens/Profile/widgets/profile_section.dart';
import 'package:next_meet/Screens/Profile/widgets/profile_stats.dart';
import 'package:next_meet/Screens/Profile/widgets/profile_tile.dart';
import 'package:next_meet/core/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile_screen.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>?> _profile;

  @override
  void initState() {
    super.initState();
    _profile = _loadProfile();
  }

  Future<Map<String, dynamic>?> _loadProfile() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) return null;
    return client.from('profiles').select().eq('id', user.id).maybeSingle();
  }

  Future<void> _editProfile(Map<String, dynamic> profile) async {
    final saved = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => EditProfileScreen(profile: profile)),
    );
    if (!mounted || saved == null) return;
    final updatedProfile = Future<Map<String, dynamic>?>.value(saved);
    setState(() {
      _profile = updatedProfile;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  void _showPersonalInformation() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => _PersonalInformationScreen(profile: _profile),
      ),
    );
  }

  Future<void> logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0xCC000000),
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF252D3A),
        surfaceTintColor: Colors.transparent,
        elevation: 18,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0xFF576275)),
        ),
        icon: const Icon(Icons.logout_rounded, color: AppColors.primaryGold),
        title: const Text('Log out of Eventora?'),
        content: const Text('You can sign in again at any time.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
              foregroundColor: Colors.black,
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

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
              FutureBuilder<Map<String, dynamic>?>(
                future: _profile,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    );
                  }
                  final profile = snapshot.data;
                  if (snapshot.hasError || profile == null) {
                    return Column(
                      children: [
                        const Text('Could not load your profile.'),
                        TextButton(
                          onPressed: () {
                            final pendingProfile = _loadProfile();
                            setState(() {
                              _profile = pendingProfile;
                            });
                          },
                          child: const Text('Try again'),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      ProfileInfo(profile: profile, onEdit: () => _editProfile(profile)),
                      const SizedBox(height: 12),
                      ProfileActions(onEdit: () => _editProfile(profile)),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),

              const ProfileStats(),
              const SizedBox(height: 8),
              ProfileSection(
                title: "Account",
                children: [
                  ProfileTile(
                    icon: Icons.person_outline,
                    title: "Personal Information",
                    onTap: _showPersonalInformation,
                  ),
                  const ProfileTile(
                    icon: Icons.confirmation_number_outlined,
                    title: "My Tickets",
                  ),
                  const ProfileTile(
                    icon: Icons.favorite_border,
                    title: "Saved Events",
                  ),
                  const ProfileTile(icon: Icons.history, title: "Event History"),
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

class _PersonalInformationScreen extends StatelessWidget {
  const _PersonalInformationScreen({required this.profile});

  final Future<Map<String, dynamic>?> profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'Personal Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: profile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final details = snapshot.data;
            if (snapshot.hasError || details == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Could not load your details. Go back to Profile and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                  ),
                ),
              );
            }

            final photo = (details['avatar_url'] as String? ?? '').trim();
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.gold,
                        child: CircleAvatar(
                          radius: 29,
                          backgroundColor: AppColors.secondaryDark,
                          foregroundImage: photo.isEmpty ? null : NetworkImage(photo),
                          child: const Icon(Icons.person_outline, color: AppColors.gold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _value(details, 'full_name'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 18),
                    _section('Contact & bio', Icons.person_outline, details, const {
                      'email': 'Email',
                      'phone': 'Phone',
                      'bio': 'Bio',
                    }),
                    _section('Other details', Icons.badge_outlined, details, const {
                      'occupation': 'Occupation',
                      'organization': 'Organization',
                      'location': 'City or region',
                      'website_url': 'Website',
                    }),
                    _section('Social links', Icons.link, details, const {
                      'linkedin_url': 'LinkedIn',
                      'instagram_url': 'Instagram',
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _value(Map<String, dynamic> details, String key) {
    final value = (details[key] as String? ?? '').trim();
    return value.isEmpty ? 'Not provided' : value;
  }

  Widget _section(
    String title,
    IconData icon,
    Map<String, dynamic> details,
    Map<String, String> fields,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.gold, size: 17),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          for (final field in fields.entries) ...[
            const Divider(height: 16, color: AppColors.divider),
            Text(
              field.value,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 11),
            ),
            const SizedBox(height: 3),
            SelectableText(
              _value(details, field.key),
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
