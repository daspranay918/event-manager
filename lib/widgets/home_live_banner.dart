import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';

class HomeLiveBanner extends StatelessWidget {
  const HomeLiveBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  // New Town, Kolkata. © OpenStreetMap contributors, CC BY-SA 2.0.
  // https://commons.wikimedia.org/wiki/File:New_Town,_Kolkata.png
  // https://creativecommons.org/licenses/by-sa/2.0/
  static const _mapImage =
      'https://thumb.wikimedia.org/wikipedia/commons/thumb/4/40/'
      'New_Town%2C_Kolkata.png/500px-New_Town%2C_Kolkata.png';

  @override
  Widget build(BuildContext context) {
    const fallback = ColoredBox(color: AppColors.secondaryDark);
    return Semantics(
      button: true,
      child: Material(
        color: AppColors.secondaryDark,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Colors.white24),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: _mapImage,
                fit: BoxFit.cover,
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.black26],
                  ),
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                child: SizedBox(
                  height: 180,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.map_outlined, color: AppColors.gold),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Discover events',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward, color: AppColors.gold),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '© OpenStreetMap contributors · CC BY-SA 2.0',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
