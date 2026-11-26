import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_meet/core/theme.dart';
import 'package:next_meet/providers/bottom_nav_provider.dart';
import 'package:next_meet/providers/published_events_provider.dart';
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
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(publishedEventsProvider);
            await ref.read(publishedEventsProvider.future);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),

                  const SizedBox(height: 16),

                  HomeLiveBanner(
                    onTap: () => ref.read(bottomNavProvider.notifier).state = 1,
                  ),

                  const SizedBox(height: 16),

                  const HomeCategories(),

                  const SizedBox(height: 20),

                  const ActiveEventsSection(),

                  const SizedBox(height: 20),

                  const PastEventsSection(),

                  const SizedBox(height: 20),

                  const UpcomingEventsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
