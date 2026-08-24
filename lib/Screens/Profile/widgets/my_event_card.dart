import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:next_meet/core/theme.dart';
import 'package:next_meet/models/event_model.dart';

class MyEventCard extends StatelessWidget {
  final EventModel event;
  final String date;
  final String location;
  final String status;
  final VoidCallback? onDelete;

  const MyEventCard({
    super.key,
    required this.event,
    required this.date,
    required this.location,
    required this.status, 
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    Color badgeBackground;

    switch (status) {
      case "ACTIVE":
        badgeColor = const Color(0xff4ADE80);
        badgeBackground = const Color(0xff17361F);
        break;

      case "UPCOMING":
        badgeColor = const Color(0xff60A5FA);
        badgeBackground = const Color(0xff152A44);
        break;

      case "PAST":
        badgeColor = Colors.grey;
        badgeBackground = const Color(0xff2A2A2A);
        break;

      case "PRIVATE":
        badgeColor = const Color(0xffFACC15);
        badgeBackground = const Color(0xff3C3210);
        break;

      default:
        badgeColor = Colors.white;
        badgeBackground = Colors.black26;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff11141A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: SizedBox(
        height: 185,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 118,
                child: CachedNetworkImage(
                  imageUrl: event.bannerImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: badgeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    event.category,
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white70,
                        size: 15,
                      ),

                      SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          date,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white70,
                        size: 15,
                      ),

                      SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          location,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      const SizedBox(width: 10),

                      Expanded(
                        child: SizedBox(
                          height: 38,
                          child: OutlinedButton.icon(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline, size: 16),
                            label: const FittedBox(
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ],
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
