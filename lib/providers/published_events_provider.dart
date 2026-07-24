import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_meet/models/event_model.dart';
import 'package:next_meet/providers/events_provider.dart';

final publishedEventsProvider =
    FutureProvider<List<EventModel>>((ref) async {
  try {
    final eventService = ref.watch(eventServiceProvider);

    return await eventService.getPublishedEvents();
  } catch (e, stack) {
    debugPrint("===============");
    debugPrint(e.toString());
    debugPrint(stack.toString());
    debugPrint("===============");
    rethrow;
  }
});