import 'dart:io';

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
import 'package:next_meet/Screens/create-event_steps/step_7_preview.dart';
import 'package:next_meet/Services/event_service.dart';
import 'package:next_meet/Services/storage_service.dart';
import 'package:next_meet/models/event_draft.dart';
import 'package:next_meet/providers/bottom_nav_provider.dart';
import 'package:next_meet/providers/event_provider.dart';
import 'package:next_meet/providers/events_provider.dart';
import 'package:next_meet/providers/published_events_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  int currentStep = 1;
  File? selectedBannerImage;

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

  void previousStep() {
    if (currentStep > 1) {
      setState(() {
        currentStep--;
      });
    }
  }

  Future<void> publishEvent() async {
    try {
      setState(() {
        isPublishing = true;
      });

      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      final event = ref.read(eventProvider); // updated data that was changed in eventDraft file

      if (event.bannerImage.isEmpty) {
        throw Exception('Banner image missing');
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
      ref.invalidate(publishedEventsProvider); // delete the catch old data readthe new data from the database thats working because of this 

      ref.read(eventProvider.notifier).state = const EventDraft();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event Published Successfully')),
        );

      }
      ref.read(bottomNavProvider.notifier).state = 0;

      if (!mounted) return;
      context.go('/navigation');
    } catch (e, stackTrace) {
      debugPrint('ERROR: $e');
      debugPrint('STACK: $stackTrace');

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

    if (date != null) {
      setState(() {
        startDate = date;
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

    if (date != null) {
      setState(() {
        endDate = date;
      });
    }
  }

  Future<void> pickStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        startTime = time.format(context);
      });
    }
  }

  Future<void> pickEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        endTime = time.format(context);
      });
    }
  }

  Future<void> pickBannerImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      selectedBannerImage = File(image.path);
    });
  }

  void nextStep() {
    if (currentStep == 7) {
      publishEvent();
      return;
    }
    if (currentStep == 1) {
      ref.read(eventProvider.notifier).state = ref
          .read(eventProvider)
          .copyWith(isPrivate: isPrivate);

      setState(() {
        currentStep = 2;
      });

      return;
    }

    if (currentStep == 2) {
      if (titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter event title')),
        );
        return;
      }

      if (descriptionController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter description')),
        );
        return;
      }

      if (selectedCategory == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select category')));
        return;
      }

      if (selectedBannerImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select banner image')),
        );
        return;
      }

      ref.read(eventProvider.notifier).state = ref
          .read(eventProvider)
          .copyWith(
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            category: selectedCategory!,
            bannerImage: selectedBannerImage!.path,
          );

      setState(() {
        currentStep = 3;
      });

      return;
    }

    if (currentStep == 3) {
      if (eventMode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select event mode')),
        );
        return;
      }

      if (startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select start date')),
        );
        return;
      }

      if (endDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select end date')));
        return;
      }

      if (startTime.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select start time')),
        );
        return;
      }

      if (endTime.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select end time')));
        return;
      }

      ref.read(eventProvider.notifier).state = ref
          .read(eventProvider)
          .copyWith(
            eventMode: eventMode,
            startDate: startDate,
            endDate: endDate,
            startTime: startTime,
            endTime: endTime,
          );

      final event = ref.read(eventProvider);

      debugPrint('Mode: ${event.eventMode}');
      debugPrint('Start Date: ${event.startDate}');
      debugPrint('End Date: ${event.endDate}');
      debugPrint('Start Time: ${event.startTime}');
      debugPrint('End Time: ${event.endTime}');

      setState(() {
        currentStep = 4;
      });

      return;
    }
    if (currentStep == 4) {
      if (registrationType.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select registration type')),
        );
        return;
      }

      ref.read(eventProvider.notifier).state = ref
          .read(eventProvider)
          .copyWith(
            registrationType: registrationType,
            allowRegistrationAfterStart: allowRegistrationAfterStart,
            maxParticipants: hasParticipantLimit
                ? int.tryParse(maxParticipantsController.text.trim())
                : null,
          );

      setState(() {
        currentStep = 5;
      });

      return;
    }
    if (currentStep == 5) {
      if (ticketType.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select ticket type')),
        );
        return;
      }

      double price = 0;

      if (ticketType == 'Paid') {
        if (ticketPriceController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter ticket price')),
          );
          return;
        }

        price = double.tryParse(ticketPriceController.text.trim()) ?? 0;
      }

      ref.read(eventProvider.notifier).state = ref
          .read(eventProvider)
          .copyWith(
            ticketType: ticketType,
            currency: selectedCurrency,
            ticketPrice: price,
          );

      final event = ref.read(eventProvider);

      debugPrint('Registration Type: ${event.registrationType}');
      debugPrint('Ticket Type: ${event.ticketType}');
      debugPrint('Ticket Price: ${event.ticketPrice}');

      setState(() {
        currentStep = 6;
      });

      return;
    }
    if (currentStep == 6) {
      if (eventMode == 'Online' || eventMode == 'Hybrid') {
        if (meetingLinkController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter meeting link')),
          );
          return;
        }
      }

      if (eventMode == 'Offline' || eventMode == 'Hybrid') {
        if (venueController.text.trim().isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Please enter venue')));
          return;
        }

        if (addressController.text.trim().isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Please enter address')));
          return;
        }

        if (cityController.text.trim().isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Please enter city')));
          return;
        }
      }

      ref.read(eventProvider.notifier).state = ref
          .read(eventProvider)
          .copyWith(
            venue: venueController.text.trim(),
            address: addressController.text.trim(),
            city: cityController.text.trim(),
            state: selectedState,
            country: selectedCountry,
            meetingLink: meetingLinkController.text.trim(),
          );

      final event = ref.read(eventProvider);

      debugPrint('Venue: ${event.venue}');
      debugPrint('City: ${event.city}');
      debugPrint('Country: ${event.country}');
      debugPrint('Meeting Link: ${event.meetingLink}');

      setState(() {
        currentStep = 7;
      });

      return;
    }
  }

  Widget buildCurrentStep() {
    switch (currentStep) {
      case 1:
        return Step1Visibility(
          isPrivate: isPrivate,
          onChanged: (value) {
            setState(() {
              isPrivate = value;
            });
          },
        );

      case 2:
        return Step2BasicInfo(
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
        );

      case 3:
        return Step3DateTime(
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
        );
      case 4:
        return Step4Registration(
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
        );
      case 5:
        return Step5Ticket(
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
        );
      case 6:
        return Step6Location(
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
        );
      case 7:
        return Step7Preview(event: ref.read(eventProvider));

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step $currentStep of 8',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: buildCurrentStep())),
            Row(
              children: [
                if (currentStep > 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: previousStep,
                      child: const Text('Back'),
                    ),
                  ),

                if (currentStep > 1) const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: isPublishing ? null : nextStep,
                    child: isPublishing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(currentStep == 7 ? 'Publish Event' : 'Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
