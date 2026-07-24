import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_meet/core/theme.dart';
// import 'package:next_meet/providers/published_events_provider.dart';
import 'package:next_meet/widgets/active_event_section.dart';
import 'package:next_meet/widgets/home_header.dart';
import 'package:next_meet/widgets/home_live_banner.dart';
import 'package:next_meet/widgets/home_categories.dart';
import 'package:next_meet/widgets/past_event_section.dart';
import 'package:next_meet/widgets/upcoming_events_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                HomeHeader(),

                SizedBox(height: 18),

                HomeLiveBanner(),

                SizedBox(height: 18),

                HomeCategories(),

                SizedBox(height: 24),

                ActiveEventsSection(),

                SizedBox(height: 24),

                PastEventsSection(),

                SizedBox(height: 24),

                UpcomingEventsSection(),

                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}