import 'package:next_meet/models/event_draft.dart';
import 'package:next_meet/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventService {
  final _supabase = Supabase.instance.client;

  Future<void> createEvent({
    required EventDraft event,
    required String creatorId,
    required String bannerImageUrl,
  }) async {
    await _supabase.from('events').insert({
      'creator_id': creatorId,

      // Basic Info
      'title': event.title,
      'description': event.description,
      'category': event.category,

      // Images
      'banner_image': bannerImageUrl,
      'gallery_images': event.galleryImages,

      // Visibility
      'is_private': event.isPrivate,

      // Event Mode
      'event_mode': event.eventMode,

      // Location
      'venue': event.venue,
      'address': event.address,
      'city': event.city,
      'state': event.state,
      'country': event.country,

      // Online
      'meeting_link': event.meetingLink,

      // Date & Time
      'start_date': event.startDate?.toString().split(' ')[0],
      'end_date': event.endDate?.toString().split(' ')[0],

      'start_time': event.startTime,
      'end_time': event.endTime,

      // Registration
      'registration_type': event.registrationType,
      'allow_registration_after_start': event.allowRegistrationAfterStart,
      'max_participants': event.maxParticipants,

      // Tickets
      'ticket_type': event.ticketType,
      'currency': event.currency,
      'ticket_price': event.ticketPrice,

      // Organizer
      'show_organizer_contact': event.showOrganizerContact,
      'organizer_contact': event.organizerContact,

      // Status
      'status': 'Published',
    });
  }

  Future<List<EventModel>> getPublishedEvents() async {
    final response = await _supabase
        .from('events')
        .select()
        .eq('status', 'Published')
        .order('created_at', ascending: false);

    return (response as List)
        .map((event) => EventModel.fromJson(event as Map<String, dynamic>))
        .toList();
  }
}
