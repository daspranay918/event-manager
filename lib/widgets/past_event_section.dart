import 'package:next_meet/Screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_meet/models/event_model.dart';
import 'package:next_meet/providers/home_events_provider.dart';
import 'package:next_meet/widgets/past_event_card.dart';

class PastEventsSection extends ConsumerWidget {
  const PastEventsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<EventModel> events = ref.watch(pastEventsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.history,
              color: Color(0xff8B5CF6),
              size: 18,
            ),

            const SizedBox(width: 8),

            const Text(
              "Past Events",
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
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: const Text('Past Events')),
                    body: const Center(
                      child: Text('All past events will appear here.'),
                    ),
                  ),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View All', style: TextStyle(color: Color(0xFFF6C453))),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: Color(0xFFF6C453)),
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
                "No Past Events",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          )
        else
          SizedBox(
            height: 175,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                final location =
                    (event.city?.trim().isNotEmpty ?? false)
                        ? "${event.city}, ${event.country ?? ""}"
                        : "Location Unknown";

                return PastEventCard(
                  onTap: () => EventDetailsScreen.open(context, event, EventDetailStatus.past),
                  image: event.bannerImage,
                  day: event.startDate.day.toString(),
                  month: _month(event.startDate.month),
                  title: event.title,
                  category: event.category,
                  location: location,
                  date:
                      "${event.startDate.day} ${_month(event.startDate.month)} ${event.startDate.year}",
                );
              },
            ),
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
