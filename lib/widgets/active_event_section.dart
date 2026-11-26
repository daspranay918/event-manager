import 'package:next_meet/Screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_meet/models/event_model.dart';
import 'package:next_meet/providers/home_events_provider.dart';
import 'package:next_meet/widgets/active_event_card.dart';

class ActiveEventsSection extends ConsumerWidget {
  const ActiveEventsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<EventModel> events = ref.watch(activeEventsProvider);

    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              const Text(
                "Active Events",
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
                      appBar: AppBar(title: const Text('Active Events')),
                      body: const Center(
                        child: Text('All active events will appear here.'),
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
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "No Active Events",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          else
            SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];

                  final location =
                      (event.city?.trim().isNotEmpty ?? false)
                          ? "${event.city}, ${event.country ?? ""}"
                          : "Location Unknown";

                  return ActiveEventCard(
                    onTap: () => EventDetailsScreen.open(context, event, EventDetailStatus.live),
                    image: event.bannerImage,
                    title: event.title,
                    category: event.category,
                    location: location,
                    distance: event.eventMode,
                    likes: "0",
                    comments: "0",
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
