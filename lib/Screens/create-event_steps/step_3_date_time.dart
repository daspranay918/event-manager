import 'package:flutter/material.dart';

class Step3DateTime extends StatelessWidget {
  final String eventMode;

  final DateTime? startDate;
  final DateTime? endDate;

  final String startTime;
  final String endTime;

  final VoidCallback onSelectStartDate;
  final VoidCallback onSelectEndDate;

  final VoidCallback onSelectStartTime;
  final VoidCallback onSelectEndTime;

  final ValueChanged<String?> onEventModeChanged;

  const Step3DateTime({
    super.key,
    required this.eventMode,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.onSelectStartDate,
    required this.onSelectEndDate,
    required this.onSelectStartTime,
    required this.onSelectEndTime,
    required this.onEventModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date & Time',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        DropdownButtonFormField<String>(
          initialValue: eventMode.isEmpty ? null : eventMode,
          decoration: const InputDecoration(labelText: 'Event Mode'),
          items: const [
            DropdownMenuItem(value: 'Online', child: Text('Online')),
            DropdownMenuItem(value: 'Offline', child: Text('Offline')),
            DropdownMenuItem(value: 'Hybrid', child: Text('Hybrid')),
          ],
          onChanged: onEventModeChanged,
        ),

        const SizedBox(height: 20),

        ListTile(
          title: const Text('Start Date'),
          subtitle: Text(
            startDate == null
                ? 'Select Start Date'
                : startDate.toString().split(' ')[0],
          ),
          trailing: const Icon(Icons.calendar_month),
          onTap: onSelectStartDate,
        ),

        ListTile(
          title: const Text('End Date'),
          subtitle: Text(
            endDate == null
                ? 'Select End Date'
                : endDate.toString().split(' ')[0],
          ),
          trailing: const Icon(Icons.calendar_month),
          onTap: onSelectEndDate,
        ),

        const SizedBox(height: 10),

        ListTile(
          title: const Text('Start Time'),
          subtitle: Text(startTime.isEmpty ? 'Select Start Time' : startTime),
          trailing: const Icon(Icons.access_time),
          onTap: onSelectStartTime,
        ),

        ListTile(
          title: const Text('End Time'),
          subtitle: Text(endTime.isEmpty ? 'Select End Time' : endTime),
          trailing: const Icon(Icons.access_time),
          onTap: onSelectEndTime,
        ),
      ],
    );
  }
}
