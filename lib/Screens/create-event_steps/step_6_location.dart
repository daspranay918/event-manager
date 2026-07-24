import 'package:flutter/material.dart';

class Step6Location extends StatelessWidget {
  final String eventMode;

  final TextEditingController venueController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController meetingLinkController;

  final String selectedState;
  final String selectedCountry;

  final ValueChanged<String?> onStateChanged;
  final ValueChanged<String?> onCountryChanged;

  const Step6Location({
    super.key,
    required this.eventMode,
    required this.venueController,
    required this.addressController,
    required this.cityController,
    required this.meetingLinkController,
    required this.selectedState,
    required this.selectedCountry,
    required this.onStateChanged,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool showOfflineFields =
        eventMode == 'Offline' || eventMode == 'Hybrid';

    final bool showOnlineFields =
        eventMode == 'Online' || eventMode == 'Hybrid';

    const countries = [
      'India',
      'USA',
      'UK',
      'Canada',
      'Australia',
      'UAE',
      'Germany',
      'France',
      'Singapore',
      'Japan',
    ];

    const states = [
      'West Bengal',
      'Bihar',
      'Assam',
      'Sikkim',
      'Odisha',
      'Jharkhand',
      'Maharashtra',
      'Karnataka',
      'Tamil Nadu',
      'Kerala',
      'Delhi',
      'Rajasthan',
      'Uttar Pradesh',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        if (showOnlineFields) ...[
          TextField(
            controller: meetingLinkController,
            decoration: const InputDecoration(labelText: 'Meeting Link'),
          ),

          const SizedBox(height: 16),
        ],

        if (showOfflineFields) ...[
          TextField(
            controller: venueController,
            decoration: const InputDecoration(labelText: 'Venue Name'),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: addressController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Address'),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: cityController,
            decoration: const InputDecoration(labelText: 'City'),
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: selectedState,
            decoration: const InputDecoration(labelText: 'State'),
            items: states.map((state) {
              return DropdownMenuItem(value: state, child: Text(state));
            }).toList(),
            onChanged: onStateChanged,
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: selectedCountry,
            decoration: const InputDecoration(labelText: 'Country'),
            items: countries.map((country) {
              return DropdownMenuItem(value: country, child: Text(country));
            }).toList(),
            onChanged: onCountryChanged,
          ),
        ],
      ],
    );
  }
}
