class EventDraft {
  final bool isPrivate;

  // Basic Info
  final String title;
  final String description;
  final String category;

  // Images
  final String bannerImage;
  final List<String> galleryImages;

  // Date & Time
  final String eventMode;

  final DateTime? startDate;
  final DateTime? endDate;

  final String startTime;
  final String endTime;

  // Registration
  final String registrationType;

  final bool allowRegistrationAfterStart;

  final bool hasParticipantLimit;

  final int? maxParticipants;

  // Ticket
  final String ticketType;

  final String currency;

  final double ticketPrice;

  // Location
  final String venue;
  final String address;
  final String city;
  final String state;
  final String country;

  final String meetingLink;

  // Organizer
  final bool showOrganizerContact;

  final String organizerContact;

  const EventDraft({
    this.isPrivate = false,

    this.title = '',
    this.description = '',
    this.category = '',

    this.bannerImage = '',
    this.galleryImages = const [],

    this.eventMode = '',

    this.startDate,
    this.endDate,

    this.startTime = '',
    this.endTime = '',

    this.registrationType = '',

    this.allowRegistrationAfterStart = false,

    this.hasParticipantLimit = false,

    this.maxParticipants,

    this.ticketType = '',

    this.currency = 'INR',

    this.ticketPrice = 0,

    this.venue = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.country = 'India',

    this.meetingLink = '',

    this.showOrganizerContact = false,

    this.organizerContact = '',
  });

  EventDraft copyWith({
    bool? isPrivate,

    String? title,
    String? description,
    String? category,

    String? bannerImage,
    List<String>? galleryImages,

    String? eventMode,

    DateTime? startDate,
    DateTime? endDate,

    String? startTime,
    String? endTime,

    String? registrationType,

    bool? allowRegistrationAfterStart,

    bool? hasParticipantLimit,

    int? maxParticipants,

    String? ticketType,

    String? currency,

    double? ticketPrice,

    String? venue,
    String? address,
    String? city,
    String? state,
    String? country,

    String? meetingLink,

    bool? showOrganizerContact,

    String? organizerContact,
  }) {
    return EventDraft(
      isPrivate: isPrivate ?? this.isPrivate,

      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,

      bannerImage: bannerImage ?? this.bannerImage,
      galleryImages: galleryImages ?? this.galleryImages,

      eventMode: eventMode ?? this.eventMode,

      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,

      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,

      registrationType: registrationType ?? this.registrationType,

      allowRegistrationAfterStart:
          allowRegistrationAfterStart ?? this.allowRegistrationAfterStart,

      hasParticipantLimit: hasParticipantLimit ?? this.hasParticipantLimit,

      maxParticipants: maxParticipants ?? this.maxParticipants,

      ticketType: ticketType ?? this.ticketType,

      currency: currency ?? this.currency,

      ticketPrice: ticketPrice ?? this.ticketPrice,

      venue: venue ?? this.venue,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,

      meetingLink: meetingLink ?? this.meetingLink,

      showOrganizerContact: showOrganizerContact ?? this.showOrganizerContact,

      organizerContact: organizerContact ?? this.organizerContact,
    );
  }
}
