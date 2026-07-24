import 'package:flutter/material.dart';

class Step1Visibility extends StatelessWidget {
  final bool isPrivate;
  final ValueChanged<bool> onChanged;

  const Step1Visibility({
    super.key,
    required this.isPrivate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Visibility',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Choose who can discover this event.',
        ),

        const SizedBox(height: 30),

        RadioListTile<bool>(
          value: false,
          groupValue: isPrivate,
          title: const Text('Public Event'),
          subtitle: const Text(
            'Anyone can discover and join.',
          ),
          onChanged: (value) {
            onChanged(value!);
          },
        ),

        RadioListTile<bool>(
          value: true,
          groupValue: isPrivate,
          title: const Text('Private Event'),
          subtitle: const Text(
            'Visible only to invited people.',
          ),
          onChanged: (value) {
            onChanged(value!);
          },
        ),
      ],
    );
  }
}