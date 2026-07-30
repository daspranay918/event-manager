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

        RadioGroup<bool>(
          groupValue: isPrivate,
          onChanged: (bool? value) {
            if (value != null) {
              onChanged(value);
            }
          },
          child: Column(
            children: const [
              RadioListTile<bool>(
                value: false,
                title: Text('Public Event'),
                subtitle: Text(
                  'Anyone can discover and join.',
                ),
              ),
              RadioListTile<bool>(
                value: true,
                title: Text('Private Event'),
                subtitle: Text(
                  'Visible only to invited people.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}