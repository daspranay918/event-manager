import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';

class ActiveEventCard extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final String title;
  final String category;
  final String location;
  final String distance;
  final String likes;
  final String comments;

  const ActiveEventCard({
    super.key,
    required this.onTap,
    required this.image,
    required this.title,
    required this.category,
    required this.location,
    required this.distance,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Shows about 2.3 cards on mobile.
    final cardWidth = screenWidth * 0.34;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12, width: .8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: Image.network(
                    image,
                    height: 92,
                    width: double.infinity,
                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 92,
                        color: Colors.grey.shade900,
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.white54),
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "LIVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const Positioned(
                  right: 4,
                  top: 4,
                  child: Icon(Icons.more_vert, color: Colors.white, size: 18),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Like & Comment
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 14),

                      const SizedBox(width: 3),

                      Text(
                        likes,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white70,
                        size: 14,
                      ),

                      const SizedBox(width: 3),

                      Text(
                        comments,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: AppColors.primaryGold,
                      ),

                      const SizedBox(width: 3),

                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    distance,
                    style: const TextStyle(color: Colors.white60, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
