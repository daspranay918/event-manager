import 'dart:io';

import 'package:flutter/material.dart';
import 'package:next_meet/models/event_draft.dart';

class Step7Preview extends StatelessWidget {
  final EventDraft event;

  const Step7Preview({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preview Event',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // Banner
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade300,
            ),
            child: event.bannerImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(event.bannerImage),
                      fit: BoxFit.cover,
                    ),
                  )
                : const Center(child: Text('No Banner Selected')),
          ),

          const SizedBox(height: 20),

          _sectionTitle('Basic Information'),

          _infoTile('Title', event.title),
          _infoTile('Description', event.description),
          _infoTile('Category', event.category),

          const SizedBox(height: 20),

          _sectionTitle('Visibility'),

          _infoTile('Visibility', event.isPrivate ? 'Private' : 'Public'),

          const SizedBox(height: 20),

          _sectionTitle('Date & Time'),

          _infoTile('Event Mode', event.eventMode),

          _infoTile(
            'Start Date',
            event.startDate?.toString().split(' ')[0] ?? '-',
          ),

          _infoTile('End Date', event.endDate?.toString().split(' ')[0] ?? '-'),

          _infoTile('Start Time', event.startTime),

          _infoTile('End Time', event.endTime),

          const SizedBox(height: 20),

          _sectionTitle('Registration'),

          _infoTile('Registration Type', event.registrationType),

          _infoTile(
            'Allow Registration After Start',
            event.allowRegistrationAfterStart ? 'Yes' : 'No',
          ),

          _infoTile(
            'Max Participants',
            event.maxParticipants?.toString() ?? 'Unlimited',
          ),

          const SizedBox(height: 20),

          _sectionTitle('Tickets'),

          _infoTile('Ticket Type', event.ticketType),

          _infoTile('Currency', event.currency),

          _infoTile('Price', '${event.ticketPrice}'),

          const SizedBox(height: 20),

          _sectionTitle('Location'),

          if (event.meetingLink.isNotEmpty)
            _infoTile('Meeting Link', event.meetingLink),

          if (event.venue.isNotEmpty) _infoTile('Venue', event.venue),

          if (event.address.isNotEmpty) _infoTile('Address', event.address),

          if (event.city.isNotEmpty) _infoTile('City', event.city),

          if (event.state.isNotEmpty) _infoTile('State', event.state),

          if (event.country.isNotEmpty) _infoTile('Country', event.country),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
