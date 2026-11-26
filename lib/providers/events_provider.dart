import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:next_meet/models/event_model.dart';
import 'package:next_meet/Services/event_service.dart';

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService();
});

// final publishedEventsProvider =
//     FutureProvider<List<EventModel>>((ref) async {
//   return ref.read(eventServiceProvider).getPublishedEvents();
// });