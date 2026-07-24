import 'package:flutter/material.dart';

class Step4Registration extends StatelessWidget {
  final String registrationType;

  final bool allowRegistrationAfterStart;

  final bool hasParticipantLimit;

  final TextEditingController maxParticipantsController;

  final ValueChanged<String?> onRegistrationTypeChanged;

  final ValueChanged<bool> onAllowRegistrationChanged;

  final ValueChanged<bool> onParticipantLimitChanged;

  const Step4Registration({
    super.key,
    required this.registrationType,
    required this.allowRegistrationAfterStart,
    required this.hasParticipantLimit,
    required this.maxParticipantsController,
    required this.onRegistrationTypeChanged,
    required this.onAllowRegistrationChanged,
    required this.onParticipantLimitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Registration Settings',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        DropdownButtonFormField<String>(
          initialValue: registrationType.isEmpty ? null : registrationType,
          decoration: const InputDecoration(labelText: 'Registration Type'),
          items: const [
            DropdownMenuItem(value: 'Required', child: Text('Required')),
            DropdownMenuItem(value: 'Optional', child: Text('Optional')),
          ],
          onChanged: onRegistrationTypeChanged,
        ),

        const SizedBox(height: 20),

        SwitchListTile(
          title: const Text('Allow Registration After Event Start'),
          value: allowRegistrationAfterStart,
          onChanged: onAllowRegistrationChanged,
        ),

        const SizedBox(height: 20),

        SwitchListTile(
          title: const Text('Limit Participants'),
          subtitle: const Text('Turn on if event has limited seats'),
          value: hasParticipantLimit,
          onChanged: onParticipantLimitChanged,
        ),

        if (hasParticipantLimit) ...[
          const SizedBox(height: 16),

          TextField(
            controller: maxParticipantsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Max Participants'),
          ),
        ],
      ],
    );
  }
}
