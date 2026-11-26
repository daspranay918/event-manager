import 'dart:io';

import 'package:next_meet/core/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:next_meet/Screens/create-event_steps/step_1_visibility.dart';
import 'package:next_meet/Screens/create-event_steps/step_2_basic_info.dart';
import 'package:next_meet/Screens/create-event_steps/step_3_date_time.dart';
import 'package:next_meet/Screens/create-event_steps/step_4_registration.dart';
import 'package:next_meet/Screens/create-event_steps/step_5_ticket.dart';
import 'package:next_meet/Screens/create-event_steps/step_6_location.dart';
import 'package:next_meet/Services/event_service.dart';
import 'package:next_meet/Services/storage_service.dart';
import 'package:next_meet/models/event_draft.dart';
import 'package:next_meet/providers/bottom_nav_provider.dart';
import 'package:next_meet/providers/published_events_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  File? selectedBannerImage;
  int _formVersion = 0;

  final ImagePicker _imagePicker = ImagePicker();
  final EventService _eventService = EventService();

  final StorageService _storageService = StorageService();

  bool isPublishing = false;

  bool isPrivate = false;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCategory;

  String eventMode = '';

  DateTime? startDate;
  DateTime? endDate;

  String startTime = '';
  String endTime = '';

  String registrationType = '';

  bool allowRegistrationAfterStart = false;

  bool hasParticipantLimit = false;

  final maxParticipantsController = TextEditingController();

  String ticketType = '';
  String selectedCurrency = 'INR';

  String selectedCountry = 'India';

  String selectedState = 'West Bengal';

  final ticketPriceController = TextEditingController();

  final venueController = TextEditingController();

  final addressController = TextEditingController();

  final cityController = TextEditingController();

  final meetingLinkController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    maxParticipantsController.dispose();
    ticketPriceController.dispose();
    venueController.dispose();
    addressController.dispose();
    cityController.dispose();
    meetingLinkController.dispose();
    super.dispose();
  }

  Future<void> publishEvent(EventDraft event) async {
    try {
      setState(() {
        isPublishing = true;
      });

      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      final bannerUrl = await _storageService.uploadEventBanner(
        imageFile: File(event.bannerImage),
        userId: user.id,
      );

      await _eventService.createEvent(
        event: event,
        creatorId: user.id,
        bannerImageUrl: bannerUrl,
      );
      if (!mounted) return;
      ref.invalidate(publishedEventsProvider);
      ref.invalidate(myEventsProvider);
      setState(() {
        _formVersion++;
        selectedBannerImage = null;
        isPrivate = false;
        selectedCategory = null;
        eventMode = '';
        startDate = null;
        endDate = null;
        startTime = '';
        endTime = '';
        registrationType = '';
        allowRegistrationAfterStart = false;
        hasParticipantLimit = false;
        ticketType = '';
        selectedCurrency = 'INR';
        selectedCountry = 'India';
        selectedState = 'West Bengal';
      });
      for (final controller in [
        titleController,
        descriptionController,
        maxParticipantsController,
        ticketPriceController,
        venueController,
        addressController,
        cityController,
        meetingLinkController,
      ]) {
        controller.clear();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event published successfully')),
      );
      ref.read(bottomNavProvider.notifier).state = 0;
      context.go('/navigation');
    } catch (e, stackTrace) {
      debugPrint('ERROR: $e');
      debugPrint('STACK: $stackTrace');

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isPublishing = false;
        });
      }
    }
  }

  Future<void> pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null && mounted) {
      setState(() {
        startDate = date;
        if (endDate?.isBefore(date) ?? false) endDate = null;
      });
    }
  }

  Future<void> pickEndDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: startDate ?? DateTime.now(),
    );

    if (date != null && mounted) {
      setState(() {
        endDate = date;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> pickStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null && mounted) {
      setState(() {
        startTime = _formatTime(time);
      });
    }
  }

  Future<void> pickEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null && mounted) {
      setState(() {
        endTime = _formatTime(time);
      });
    }
  }

  Future<void> pickBannerImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null || !mounted) return;

    setState(() {
      selectedBannerImage = File(image.path);
    });
  }

  void submit() {
    if (isPublishing) return;
    FocusScope.of(context).unfocus();
    final offline = eventMode == 'Offline' || eventMode == 'Hybrid';
    final online = eventMode == 'Online' || eventMode == 'Hybrid';
    final limit = int.tryParse(maxParticipantsController.text.trim());
    final price = double.tryParse(ticketPriceController.text.trim());
    final sameDay = startDate != null && startDate == endDate;
    final errors = <String>[
      if (titleController.text.trim().isEmpty) 'Enter an event title.',
      if (descriptionController.text.trim().isEmpty) 'Enter a description.',
      if (selectedCategory == null) 'Select a category.',
      if (selectedBannerImage == null) 'Add a cover image.',
      if (eventMode.isEmpty) 'Select the event mode.',
      if (startDate == null || endDate == null ||
          startTime.isEmpty || endTime.isEmpty) 'Set the start and end date and time.'
      else if (sameDay && endTime.compareTo(startTime) <= 0)
        'The end time must be after the start time.',
      if (registrationType.isEmpty) 'Select the registration type.',
      if (hasParticipantLimit && (limit == null || limit <= 0))
        'Enter a participant limit greater than zero.',
      if (ticketType.isEmpty) 'Select a ticket type.',
      if (ticketType == 'Paid' && (price == null || !price.isFinite || price <= 0))
        'Enter a ticket price greater than zero.',
      if (online && meetingLinkController.text.trim().isEmpty)
        'Enter the meeting link.',
      if (offline && (venueController.text.trim().isEmpty ||
          addressController.text.trim().isEmpty || cityController.text.trim().isEmpty))
        'Enter the venue, address, and city.',
    ];
    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(errors.first)));
      return;
    }

    publishEvent(EventDraft(
      isPrivate: isPrivate,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategory!,
      bannerImage: selectedBannerImage!.path,
      eventMode: eventMode,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      registrationType: registrationType,
      allowRegistrationAfterStart: allowRegistrationAfterStart,
      hasParticipantLimit: hasParticipantLimit,
      maxParticipants: hasParticipantLimit ? limit : null,
      ticketType: ticketType,
      currency: selectedCurrency,
      ticketPrice: ticketType == 'Paid' ? price! : 0,
      venue: offline ? venueController.text.trim() : '',
      address: offline ? addressController.text.trim() : '',
      city: offline ? cityController.text.trim() : '',
      state: selectedState,
      country: selectedCountry,
      meetingLink: online ? meetingLinkController.text.trim() : '',
    ));
  }

  Widget _section(IconData icon, Widget fields) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold, size: 23),
          const SizedBox(height: 10),
          fields,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Create event'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: IgnorePointer(
              ignoring: isPublishing,
              child: SingleChildScrollView(
                key: ValueKey(_formVersion),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _section(
                      Icons.visibility_outlined,
                      Step1Visibility(
                        isPrivate: isPrivate,
                        onChanged: (value) {
                          setState(() {
                            isPrivate = value;
                          });
                        },
                      ),
                    ),

                    _section(
                      Icons.edit_note,
                      Step2BasicInfo(
                        titleController: titleController,
                        descriptionController: descriptionController,
                        selectedCategory: selectedCategory,
                        selectedBannerImage: selectedBannerImage,
                        onBannerTap: pickBannerImage,
                        onCategoryChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    ),

                    _section(
                      Icons.calendar_month_outlined,
                      Step3DateTime(
                        eventMode: eventMode,
                        startDate: startDate,
                        endDate: endDate,
                        startTime: startTime,
                        endTime: endTime,
                        onEventModeChanged: (value) {
                          setState(() {
                            eventMode = value ?? '';
                          });
                        },
                        onSelectStartDate: pickStartDate,
                        onSelectEndDate: pickEndDate,
                        onSelectStartTime: pickStartTime,
                        onSelectEndTime: pickEndTime,
                      ),
                    ),
                    _section(
                      Icons.people_outline,
                      Step4Registration(
                        registrationType: registrationType,
                        allowRegistrationAfterStart: allowRegistrationAfterStart,
                        hasParticipantLimit: hasParticipantLimit,
                        maxParticipantsController: maxParticipantsController,
                        onRegistrationTypeChanged: (value) {
                          setState(() {
                            registrationType = value ?? '';
                          });
                        },
                        onAllowRegistrationChanged: (value) {
                          setState(() {
                            allowRegistrationAfterStart = value;
                          });
                        },
                        onParticipantLimitChanged: (value) {
                          setState(() {
                            hasParticipantLimit = value;
                          });
                        },
                      ),
                    ),
                    _section(
                      Icons.confirmation_number_outlined,
                      Step5Ticket(
                        ticketType: ticketType,
                        selectedCurrency: selectedCurrency,
                        ticketPriceController: ticketPriceController,
                        onTicketTypeChanged: (value) {
                          setState(() {
                            ticketType = value ?? '';
                          });
                        },
                        onCurrencyChanged: (value) {
                          setState(() {
                            selectedCurrency = value ?? 'INR';
                          });
                        },
                      ),
                    ),
                    _section(
                      Icons.place_outlined,
                      Step6Location(
                        eventMode: eventMode,
                        venueController: venueController,
                        addressController: addressController,
                        cityController: cityController,
                        meetingLinkController: meetingLinkController,
                        selectedState: selectedState,
                        selectedCountry: selectedCountry,
                        onStateChanged: (value) {
                          setState(() {
                            selectedState = value ?? 'West Bengal';
                          });
                        },
                        onCountryChanged: (value) {
                          setState(() {
                            selectedCountry = value ?? 'India';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: isPublishing ? null : submit,
                  icon: isPublishing
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.publish_outlined),
                  label: Text(isPublishing ? 'Publishing…' : 'Publish event'),
                  style: FilledButton.styleFrom(foregroundColor: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
