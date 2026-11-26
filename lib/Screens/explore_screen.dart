import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:next_meet/Screens/event_details_screen.dart';
import 'package:next_meet/core/theme.dart';
import 'package:next_meet/models/event_model.dart';
import 'package:next_meet/providers/home_events_provider.dart';
import 'package:next_meet/providers/published_events_provider.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  static const _radii = <int?>[2, 5, 10, 15, 20, null];
  static const _worldCenter = LatLng(20, 0);
  static const _worldZoom = 2.0;
  final _map = MapController();

  String _query = '';
  int? _radius;
  LatLng? _origin;
  bool _locating = false;
  bool _mapReady = false;
  int _areaRevision = 0;

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  Future<void> _useLocation() async {
    if (_locating) return;
    final requestRevision = _areaRevision;
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _message('Enable device location or long-press the map to choose an area.');
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _message('Location access is off. Long-press the map to choose an area.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (!mounted || requestRevision != _areaRevision) return;
      _chooseOrigin(LatLng(position.latitude, position.longitude));
    } catch (_) {
      _message('Could not get your location. Long-press the map to choose an area.');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _chooseOrigin(LatLng point) {
    _areaRevision++;
    setState(() {
      _origin = point;
      _radius ??= 5;
    });
    _focusRadius();
  }

  void _selectRadius(int? radius) {
    setState(() => _radius = radius);
    if (radius == null) {
      _areaRevision++;
      if (_mapReady) _map.move(_worldCenter, _worldZoom);
      return;
    }
    if (_origin == null) {
      _useLocation();
    } else {
      _focusRadius();
    }
  }

  void _focusRadius() {
    final origin = _origin;
    if (!_mapReady || origin == null) return;
    final zoom = switch (_radius) {
      2 => 13.0,
      5 => 12.0,
      10 => 11.0,
      15 => 10.5,
      _ => 10.0,
    };
    _map.move(origin, zoom);
  }

  LatLng? _coordinates(EventModel event) {
    final lat = event.latitude;
    final lon = event.longitude;
    if (lat == null || lon == null || !lat.isFinite || !lon.isFinite ||
        lat.abs() > 85.0511 || lon.abs() > 180) return null;
    return LatLng(lat, lon);
  }

  bool _matches(EventModel event, LatLng? point) {
    if (event.isPrivate) return false;
    final searchable = [
      event.title, event.category, event.venue, event.address, event.city,
      event.state, event.country,
    ].whereType<String>().join(' ').toLowerCase();
    if (!searchable.contains(_query)) return false;

    final radius = _radius;
    if (radius == null) return true;
    final origin = _origin;
    if (point == null || origin == null) return false;
    return Geolocator.distanceBetween(
      origin.latitude, origin.longitude, point.latitude, point.longitude,
    ) <= radius * 1000;
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(publishedEventsProvider);
    final live = ref.watch(activeEventsProvider);
    final past = ref.watch(pastEventsProvider);
    final matches = <(EventModel, LatLng?)>[];
    for (final event in feed.value ?? <EventModel>[]) {
      final point = _coordinates(event);
      if (_matches(event, point)) matches.add((event, point));
    }

    void open(EventModel event) {
      final status = live.contains(event)
          ? EventDetailStatus.live
          : past.contains(event) ? EventDetailStatus.past : EventDetailStatus.upcoming;
      EventDetailsScreen.open(context, event, status);
    }

    final origin = _origin;
    final radius = _radius;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover', style: TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            tooltip: 'Use my location',
            onPressed: _locating ? null : _useLocation,
            icon: _locating
                ? const SizedBox.square(
                    dimension: 18, child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location, color: AppColors.gold),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            TextField(
              onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Search events, venues or cities',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final distance in _radii)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(
                          distance == null ? 'World' : '$distance km',
                          style: TextStyle(
                            fontSize: 12,
                            color: radius == distance ? Colors.black : Colors.white,
                          ),
                        ),
                        selected: radius == distance,
                        selectedColor: AppColors.gold,
                        showCheckmark: false,
                        onSelected: (_) => _selectRadius(distance),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 330,
                child: FlutterMap(
                  mapController: _map,
                  options: MapOptions(
                    initialCenter: _worldCenter,
                    initialZoom: _worldZoom,
                    minZoom: 2,
                    maxZoom: 19,
                    onMapReady: () {
                      _mapReady = true;
                      if (_radius != null && _origin != null) _focusRadius();
                    },
                    onLongPress: (_, point) => _chooseOrigin(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'Eventora.mobile',
                      maxNativeZoom: 19,
                    ),
                    if (origin != null && radius != null)
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: origin,
                            radius: radius * 1000.0,
                            useRadiusInMeter: true,
                            color: AppColors.gold.withValues(alpha: 0.16),
                            borderColor: AppColors.gold,
                            borderStrokeWidth: 2,
                          ),
                          CircleMarker(point: origin, radius: 5, color: Colors.blue),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        for (final (event, point) in matches)
                          if (point != null)
                            Marker(
                              point: point,
                              width: 44,
                              height: 44,
                              child: IconButton(
                                tooltip: event.title,
                                onPressed: () => open(event),
                                icon: const Icon(Icons.location_on, color: Color(0xFFAC3424)),
                              ),
                            ),
                      ],
                    ),
                    const SimpleAttributionWidget(
                      source: Text('OpenStreetMap contributors'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Long-press the map to choose a search center.',
              style: TextStyle(fontSize: 11, color: AppColors.textGrey),
            ),
            const SizedBox(height: 12),
            if (feed.isLoading && matches.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (feed.hasError)
              TextButton(
                onPressed: () => ref.invalidate(publishedEventsProvider),
                child: const Text('Could not load events. Try again'),
              )
            else if (radius != null && origin == null)
              const Text('Use your location or long-press the map to search nearby.')
            else if (matches.isEmpty)
              const Text('No events match your search.')
            else
              for (final (event, point) in matches)
                Card(
                  color: AppColors.cardBackground,
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      point == null ? Icons.event_outlined : Icons.place_outlined,
                      color: AppColors.gold,
                    ),
                    title: Text(event.title, style: const TextStyle(fontSize: 13)),
                    subtitle: Text(
                      [event.category, event.city, if (point == null) 'No map location']
                          .whereType<String>().where((part) => part.trim().isNotEmpty)
                          .join(' · '),
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => open(event),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
