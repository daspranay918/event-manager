import 'package:flutter_riverpod/legacy.dart';
import 'package:next_meet/models/event_draft.dart';

final eventProvider =
    StateProvider<EventDraft>((ref) => const EventDraft());