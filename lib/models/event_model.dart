class EventModel {
  final String? id;

  final String creatorId;

  final String title;

  final String description;

  final String category;

  final String bannerImage;

  final List<String> galleryImages;

  final bool isPrivate;

  final String eventMode;

  final String? venue;

  final String? address;

  final String? city;

  final String? state;

  final String? country;

  final double? latitude;

  final double? longitude;

  final String? meetingLink;

  final DateTime startDate;

  final DateTime endDate;

  final String startTime;

  final String endTime;

  final String registrationType;

  final bool allowRegistrationAfterStart;

  final int? maxParticipants;

  final String ticketType;

  final double ticketPrice;

  final String? schedule;

  final String? rules;

  final String? faq;

  final String? speakers;

  final String? sponsors;

  final String status;

  final int likesCount;

  final int commentsCount;

  final int registeredCount;

  final bool isFeatured;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  const EventModel({
    this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.category,
    required this.bannerImage,
    required this.galleryImages,
    required this.isPrivate,
    required this.eventMode,
    this.venue,
    this.address,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.meetingLink,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.registrationType,
    required this.allowRegistrationAfterStart,
    this.maxParticipants,
    required this.ticketType,
    required this.ticketPrice,
    this.schedule,
    this.rules,
    this.faq,
    this.speakers,
    this.sponsors,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.likesCount,
    required this.commentsCount,
    required this.registeredCount,
    required this.isFeatured,
  });
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      creatorId: json['creator_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      galleryImages: List<String>.from(json['gallery_images'] ?? []),
      isPrivate: json['is_private'] ?? false,
      eventMode: json['event_mode'] ?? '',
      venue: json['venue'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      meetingLink: json['meeting_link'],
      startDate:
          DateTime.tryParse(json['start_date']?.toString() ?? '') ??
          DateTime.now(),

      endDate:
          DateTime.tryParse(json['end_date']?.toString() ?? '') ??
          DateTime.now(),
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      registrationType: json['registration_type'] ?? '',
      allowRegistrationAfterStart:
          json['allow_registration_after_start'] ?? false,
      maxParticipants: json['max_participants'],
      ticketType: json['ticket_type'] ?? '',
      ticketPrice: (json['ticket_price'] ?? 0).toDouble(),
      schedule: json['schedule'],
      rules: json['rules'],
      faq: json['faq'],
      speakers: json['speakers'],
      sponsors: json['sponsors'],
      status: json['status'] ?? 'Draft',
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      registeredCount: json['registered_count'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'title': title,
      'description': description,
      'category': category,
      'banner_image': bannerImage,
      'gallery_images': galleryImages,
      'is_private': isPrivate,
      'event_mode': eventMode,
      'venue': venue,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'meeting_link': meetingLink,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'registration_type': registrationType,
      'allow_registration_after_start': allowRegistrationAfterStart,
      'max_participants': maxParticipants,
      'ticket_type': ticketType,
      'ticket_price': ticketPrice,
      'schedule': schedule,
      'rules': rules,
      'faq': faq,
      'speakers': speakers,
      'sponsors': sponsors,
      'status': status,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'registered_count': registeredCount,
      'is_featured': isFeatured,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  EventModel copyWith({
    String? id,
    String? creatorId,
    String? title,
    String? description,
    String? category,
    String? bannerImage,
    List<String>? galleryImages,
    bool? isPrivate,
    String? eventMode,
    String? venue,
    String? address,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    String? meetingLink,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    String? endTime,
    String? registrationType,
    bool? allowRegistrationAfterStart,
    int? maxParticipants,
    String? ticketType,
    double? ticketPrice,
    String? schedule,
    String? rules,
    String? faq,
    String? speakers,
    String? sponsors,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? commentsCount,
    int? registeredCount,
    bool? isFeatured,
  }) {
    return EventModel(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      bannerImage: bannerImage ?? this.bannerImage,
      galleryImages: galleryImages ?? this.galleryImages,
      isPrivate: isPrivate ?? this.isPrivate,
      eventMode: eventMode ?? this.eventMode,
      venue: venue ?? this.venue,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      meetingLink: meetingLink ?? this.meetingLink,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      registrationType: registrationType ?? this.registrationType,
      allowRegistrationAfterStart:
          allowRegistrationAfterStart ?? this.allowRegistrationAfterStart,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      ticketType: ticketType ?? this.ticketType,
      ticketPrice: ticketPrice ?? this.ticketPrice,
      schedule: schedule ?? this.schedule,
      rules: rules ?? this.rules,
      faq: faq ?? this.faq,
      speakers: speakers ?? this.speakers,
      sponsors: sponsors ?? this.sponsors,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      registeredCount: registeredCount ?? this.registeredCount,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
