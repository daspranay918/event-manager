import 'package:flutter/material.dart';
import 'package:next_meet/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            event.bannerImage,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) {
              return Container(
                height: 180,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.image),
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(event.category),

                const SizedBox(height: 6),

                Text(
                  '${event.city ?? ''}, ${event.country ?? ''}',
                ),

                const SizedBox(height: 6),

                Text(
                  '${event.startDate.day}/${event.startDate.month}/${event.startDate.year}',
                ),

                const SizedBox(height: 6),

                Text(
                  event.ticketType == 'Free'
                      ? 'Free'
                      : '${event.ticketPrice}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}