import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:next_meet/Services/storage_service.dart';
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
    final coordinates = await _venueCoordinates(event);
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
      'latitude': coordinates?.latitude,
      'longitude': coordinates?.longitude,

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

  Future<Location?> _venueCoordinates(EventDraft event) async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS) ||
        event.eventMode.toLowerCase() == 'online' ||
        event.address.trim().isEmpty) {
      return null;
    }

    final address = [event.address, event.city, event.state, event.country]
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .join(', ');
    try {
      final results = await Geocoding()
          .locationFromAddress(address)
          .timeout(const Duration(seconds: 8));
      return results.isEmpty ? null : results.first;
    } catch (_) {
      // A venue can still be published if the device geocoder is unavailable.
      return null;
    }
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

  Future<List<EventModel>> getMyEvents() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    final response = await _supabase
        .from('events')
        .select()
        .eq('creator_id', user.id)
        .order('created_at', ascending: false);

    return (response as List)
        .map((event) => EventModel.fromJson(event as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteEvent({
    required String eventId,
    required String imageUrl,
  }) async {
    print("DELETE START");
    print("Event ID: $eventId");
    print("Image URL: $imageUrl");
    await StorageService().deleteEventBanner(imageUrl);
    print("IMAGE DELETED");

    await _supabase.from('events').delete().eq('id', eventId);
     print("DATABASE DELETE DONE");
  }
}
