import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_meet/models/event_model.dart';
import 'package:next_meet/providers/published_events_provider.dart';

DateTime _combineDateTime(DateTime date, String time) {
  final parts = time.split(':');

  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

  return DateTime(date.year, date.month, date.day, hour, minute);
}



final activeEventsProvider = Provider<List<EventModel>>((ref) {
  //using this line in the active_event_screen part in home page
  final events = ref.watch(publishedEventsProvider).value ?? []; // here we checking the event is starting or not

  final now = DateTime.now();

  return events.where((event) {
    final start = _combineDateTime(event.startDate, event.startTime);

    final end = _combineDateTime(event.endDate, event.endTime);

    return !now.isBefore(start) && !now.isAfter(end);
    // now.isAfter(start) && now.isBefore(end);
  }).toList();
});


final upcomingEventsProvider = Provider<List<EventModel>>((ref) {
  final events = ref.watch(publishedEventsProvider).value ?? [];

  final now = DateTime.now();

  return events.where((event) {
    final start = _combineDateTime(event.startDate, event.startTime);

    return start.isAfter(now);
  }).toList();
});


final pastEventsProvider = Provider<List<EventModel>>((ref) {
  final events = ref.watch(publishedEventsProvider).value ?? [];

  final now = DateTime.now();

  return events.where((event) {
    final end = _combineDateTime(event.endDate, event.endTime);

    return end.isBefore(now);
  }).toList();
});
