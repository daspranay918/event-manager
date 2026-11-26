import 'dart:io';

import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';

class BannerPicker extends StatelessWidget {
  const BannerPicker({
    super.key,
    required this.selectedImage,
    required this.onTap,
  });

  final File? selectedImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final image = selectedImage;
    return Material(
      color: AppColors.secondaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 144,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image != null) Image.file(image, fit: BoxFit.cover),
              Align(
                alignment: image == null ? Alignment.center : Alignment.bottomCenter,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: image == null ? Colors.transparent : Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_photo_alternate_outlined, color: AppColors.gold),
                        const SizedBox(width: 8),
                        Text(image == null ? 'Add cover image' : 'Change cover image'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
