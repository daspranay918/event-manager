import 'dart:io';
import 'package:flutter/material.dart';
import 'package:next_meet/widgets/banener_picker.dart';

class Step2BasicInfo extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  final String? selectedCategory;

  final ValueChanged<String?> onCategoryChanged;
  final File? selectedBannerImage;

  final VoidCallback onBannerTap;

  const Step2BasicInfo({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.selectedBannerImage,
    required this.onBannerTap,
  });

  @override
  Widget build(BuildContext context) {
    const categories = [
      'Workshop',
      'Hackathon',
      'Sports',
      'Cultural',
      'Seminar',
      'Placement',
      'Club Event',
      'Other',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Event Title'),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Description'),
        ),

        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          initialValue: selectedCategory,
          decoration: const InputDecoration(labelText: 'Category'),
          items: categories.map((category) {
            return DropdownMenuItem(value: category, child: Text(category));
          }).toList(),
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 20),

        BannerPicker(selectedImage: selectedBannerImage, onTap: onBannerTap),
      ],
    );
  }
}
