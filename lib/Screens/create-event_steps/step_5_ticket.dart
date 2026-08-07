import 'package:flutter/material.dart';

class Step5Ticket extends StatelessWidget {
  final String ticketType;
  final String selectedCurrency;

  final TextEditingController ticketPriceController;

  final ValueChanged<String?> onTicketTypeChanged;
  final ValueChanged<String?> onCurrencyChanged;

  const Step5Ticket({
    super.key,
    required this.ticketType,
    required this.selectedCurrency,
    required this.ticketPriceController,
    required this.onTicketTypeChanged,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    const currencies = ['INR', 'USD', 'EUR', 'GBP', 'AED', 'AUD', 'CAD', 'JPY'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ticket Settings',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        DropdownButtonFormField<String>(
          initialValue: ticketType.isEmpty ? null : ticketType,
          decoration: const InputDecoration(labelText: 'Ticket Type'),
          items: const [
            DropdownMenuItem(value: 'Free', child: Text('Free')),
            DropdownMenuItem(value: 'Paid', child: Text('Paid')),
          ],
          onChanged: onTicketTypeChanged,
        ),

        const SizedBox(height: 20),

        if (ticketType == 'Paid') ...[
          DropdownButtonFormField<String>(
            initialValue: selectedCurrency,
            decoration: const InputDecoration(labelText: 'Currency'),
            items: currencies.map((currency) {
              return DropdownMenuItem(value: currency, child: Text(currency));
            }).toList(),
            onChanged: onCurrencyChanged,
          ),

          const SizedBox(height: 16),

          TextField(
            controller: ticketPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Ticket Price'),
          ),
        ],
      ],
    );
  }
}
