import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_meet/Screens/Profile/widgets/my_event_card.dart';
import 'package:next_meet/Screens/Profile/widgets/my_events_header.dart';
import 'package:next_meet/Screens/Profile/widgets/my_events_tab_bar.dart';
import 'package:next_meet/models/event_model.dart';
import 'package:next_meet/providers/published_events_provider.dart';

class MyEventsScreen extends ConsumerStatefulWidget {
  const MyEventsScreen({super.key});

  @override
  ConsumerState<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends ConsumerState<MyEventsScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(myEventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xff090909),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            children: [
              const MyEventsHeader(),

              const SizedBox(height: 22),

              MyEventsTabBar(
                selectedTab: selectedTab,
                onTabChanged: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
              ),

              const SizedBox(height: 20),

              Expanded(
                child: events.when(
                  data: (events) {
                    List<EventModel> filteredEvents;

                    switch (selectedTab) {
                      case 0:
                        filteredEvents = events
                            .where((event) => _getStatus(event) == "ACTIVE")
                            .toList();
                        break;

                      case 1:
                        filteredEvents = events
                            .where((event) => _getStatus(event) == "UPCOMING")
                            .toList();
                        break;

                      case 2:
                        filteredEvents = events
                            .where((event) => _getStatus(event) == "PAST")
                            .toList();
                        break;

                      case 3:
                        filteredEvents = events
                            .where((event) => event.isPrivate)
                            .toList();
                        break;

                      default:
                        filteredEvents = events;
                    }
                    if (filteredEvents.isEmpty){
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy_outlined,
                              size: 70,
                              color: Colors.white24,
                            ),

                            SizedBox(height: 18),

                            Text(
                              "No Events Yet",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              "Create your first event to get started.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];

                        return MyEventCard(
                          image: event.bannerImage,
                          title: event.title,
                          category: event.category,
                          date:
                              "${event.startDate.day}/${event.startDate.month}/${event.startDate.year} • ${event.startTime}",
                          location: (event.city?.trim().isNotEmpty ?? false)
                              ? "${event.city}, ${event.country ?? ''}"
                              : "Location Unknown",
                          status: _getStatus(event),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) {
                    return Center(
                      child: Text(
                        error.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatus(EventModel event) {
    DateTime combine(DateTime date, String time) {
      final parts = time.split(':');

      return DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    }

    final now = DateTime.now();

    final start = combine(event.startDate, event.startTime);
    final end = combine(event.endDate, event.endTime);

    if (event.isPrivate) {
      return "PRIVATE";
    }

    if (!now.isBefore(start) && !now.isAfter(end)) {
      return "ACTIVE";
    }

    if (start.isAfter(now)) {
      return "UPCOMING";
    }

    return "PAST";
  }
}
