import 'dart:io';

import 'package:flutter/material.dart';

class BannerPicker extends StatelessWidget {
  final File? selectedImage;

  final VoidCallback onTap;

  const BannerPicker({
    super.key,
    required this.selectedImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 180,
        width: double.infinity,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey),
        ),

        child: selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(selectedImage!, fit: BoxFit.cover),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 50),

                  SizedBox(height: 10),

                  Text('Select Banner Image'),
                ],
              ),
      ),
    );
  }
}
