import 'dart:math' as math;

import 'package:next_meet/Screens/event_details_screen.dart';
import 'package:next_meet/Screens/upcoming_events_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_meet/models/event_model.dart';
import 'package:next_meet/providers/home_events_provider.dart';
import 'package:next_meet/widgets/upcoming_event_card.dart';

class UpcomingEventsSection extends ConsumerWidget {
  const UpcomingEventsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<EventModel> events = ref.watch(upcomingEventsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          children: [
            const Icon(
              Icons.schedule,
              color: Color(0xff22C55E),
              size: 18,
            ),

            const SizedBox(width: 8),

            const Text(
              "Upcoming Events",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            TextButton(
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const UpcomingEventsScreen(),
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
              ),
              child: const Row(
                children: [
                  Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xffF6C453),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Color(0xffF6C453),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        if (events.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                "No Upcoming Events",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: math.min(events.length, 5),
            itemBuilder: (context, index) {
              final event = events[index];

              final location =
                  (event.city?.trim().isNotEmpty ?? false)
                      ? "${event.city}, ${event.country ?? ""}"
                      : "Location Unknown";

              return UpcomingEventCard(
                onTap: () => EventDetailsScreen.open(context, event, EventDetailStatus.upcoming),
                image: event.bannerImage,
                day: event.startDate.day.toString(),
                month: _month(event.startDate.month),
                title: event.title,
                category: event.category,
                location: location,
                time: event.startTime,
              );
            },
          ),
      ],
    );
  }

  String _month(int month) {
    const months = [
      '',
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return months[month];
  }
}