import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:next_meet/core/theme.dart';
import 'package:next_meet/models/event_model.dart';

enum EventDetailStatus { live, upcoming, past }

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.event, required this.status});

  final EventModel event;
  final EventDetailStatus status;

  static void open(BuildContext context, EventModel event, EventDetailStatus status) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => EventDetailsScreen(event: event, status: status),
      ),
    );
  }

  String get _location => [event.venue, event.address, event.city, event.country]
      .whereType<String>()
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toSet()
      .join(', ');

  String _time(BuildContext context) {
    final value = event.startTime.trim();
    final match = RegExp(r'^(\d{1,2}):(\d{2})(?::\d{2}(?:\.\d+)?)?$').firstMatch(value);
    if (match == null) return value;
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    if (hour > 23 || minute > 59) return value;
    return TimeOfDay(hour: hour, minute: minute).format(context);
  }

  Future<void> _copy(BuildContext context, String text, String confirmation) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(confirmation)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final live = status == EventDetailStatus.live;
    final date = MaterialLocalizations.of(context).formatMediumDate(event.startDate);
    final time = _time(context);
    final online = event.eventMode.toLowerCase() == 'online';
    final location = online ? 'Online event' : _location;

    return DefaultTabController(
      length: live ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.event_outlined, color: AppColors.gold),
              ),
              const SizedBox(width: 8),
              const Text.rich(
                TextSpan(
                  text: 'Event',
                  style: TextStyle(fontWeight: FontWeight.w700),
                  children: [
                    TextSpan(text: 'ora', style: TextStyle(color: AppColors.gold)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Copy event info',
              icon: const Icon(Icons.ios_share),
              onPressed: () => _copy(
                context,
                [event.title, date, time, location, event.description]
                    .where((part) => part.trim().isNotEmpty)
                    .join('\n'),
                'Event info copied',
              ),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF10151D), Color(0xFF0A0E14)],
                      ),
                      border: Border.all(color: AppColors.gold.withValues(alpha: .29)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _banner(),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title, style: const TextStyle(
                                fontSize: 29, fontWeight: FontWeight.w700, height: 1.15,
                              )),
                              if (event.category.trim().isNotEmpty) ...[
                                const SizedBox(height: 5),
                                Text(event.category, style: const TextStyle(
                                  color: AppColors.gold, fontSize: 16,
                                )),
                              ],
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 18,
                                runSpacing: 10,
                                children: [
                                  _Metadata(icon: Icons.calendar_today_outlined, text: date),
                                  if (time.isNotEmpty)
                                    _Metadata(icon: Icons.schedule, text: time),
                                ],
                              ),
                              if (location.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                _Metadata(icon: Icons.place_outlined, text: location),
                              ],
                              if (event.description.trim().isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Text(event.description, style: const TextStyle(height: 1.5)),
                              ],
                              const SizedBox(height: 20),
                              _panel(Row(
                                children: [
                                  _stat(Icons.favorite, event.likesCount, 'Likes', Colors.redAccent),
                                  const SizedBox(
                                    height: 36,
                                    child: VerticalDivider(width: 1, color: Colors.white12),
                                  ),
                                  _stat(Icons.chat_bubble_outline, event.commentsCount, 'Comments', AppColors.textWhite),
                                  const SizedBox(
                                    height: 36,
                                    child: VerticalDivider(width: 1, color: Colors.white12),
                                  ),
                                  _stat(Icons.people_outline, event.registeredCount, 'Registered', AppColors.gold),
                                ],
                              )),
                              if (!online && location.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                _panel(Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded,
                                        size: 32, color: AppColors.gold),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(location),
                                          const SizedBox(height: 4),
                                          TextButton.icon(
                                            onPressed: () => _copy(
                                              context, location, 'Address copied',
                                            ),
                                            icon: const Icon(Icons.copy_outlined, size: 16),
                                            label: const Text('Copy address'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ],
                          ),
                        ),
                        if (live)
                          const TabBar(
                            labelColor: AppColors.gold,
                            unselectedLabelColor: AppColors.textGrey,
                            indicatorColor: AppColors.gold,
                            dividerColor: Colors.white12,
                            tabs: [Tab(text: 'Live Chat'), Tab(text: 'Details')],
                          ),
                        if (live)
                          SizedBox(
                            height: 156,
                            child: TabBarView(
                              children: [
                                const _LiveChatPreview(),
                                SingleChildScrollView(child: _details()),
                              ],
                            ),
                          )
                        else
                          _details(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _banner() {
    const fallback = ColoredBox(
      color: AppColors.secondaryDark,
      child: Center(child: Icon(Icons.image_outlined, size: 36, color: AppColors.gold)),
    );
    final label = switch (status) {
      EventDetailStatus.live => 'LIVE NOW',
      EventDetailStatus.upcoming => 'UPCOMING',
      EventDetailStatus.past => 'ENDED',
    };
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
      child: AspectRatio(
        aspectRatio: 1.95,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (event.bannerImage.trim().isEmpty)
              fallback
            else
              CachedNetworkImage(
                imageUrl: event.bannerImage,
                fit: BoxFit.cover,
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
            ),
            PositionedDirectional(
              start: 12,
              top: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: status == EventDetailStatus.live
                      ? const Color(0xFFC3151D)
                      : Colors.black87,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(label, style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: .5,
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _details() {
    final details = <(IconData, String)>[
      if (event.eventMode.isNotEmpty) (Icons.event_outlined, event.eventMode),
      if (event.registrationType.isNotEmpty)
        (Icons.how_to_reg_outlined, 'Registration: ${event.registrationType}'),
      if (event.ticketType.isNotEmpty)
        (Icons.confirmation_number_outlined, '${event.ticketType} tickets'),
      if (event.maxParticipants case final limit?)
        (Icons.people_outline, 'Capacity: $limit'),
    ];
    if (details.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: _panel(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (icon, text) in details)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _Metadata(icon: icon, text: text),
            ),
        ],
      )),
    );
  }

  Widget _panel(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .025),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _stat(IconData icon, int count, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 19, color: color),
          const SizedBox(height: 4),
          Text('$count', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(label, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
        ],
      ),
    );
  }
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: AppColors.gold),
        const SizedBox(width: 8),
        Flexible(child: Text(text, style: const TextStyle(color: AppColors.textGrey))),
      ],
    );
  }
}

class _LiveChatPreview extends StatelessWidget {
  const _LiveChatPreview();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Live chat is coming soon.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
          ),
          const TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Type a message…',
              suffixIcon: Icon(Icons.send_rounded),
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
