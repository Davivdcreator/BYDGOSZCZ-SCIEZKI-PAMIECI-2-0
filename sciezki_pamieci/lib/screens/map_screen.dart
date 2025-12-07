import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../theme/tier_colors.dart';
import '../data/monuments_data.dart';
import '../models/monument.dart';
import '../services/monuments_service.dart';

import 'discovery_card.dart';
import 'profile_screen.dart';
import 'games_screen.dart';
import '../widgets/stats_island.dart';

/// Screen 2: Main Map Screen - Clean modern design
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  Monument? _selectedMonument;
  int _currentNavIndex = 1; // Start at 1 (Mapa is center)
  LatLng? _userLocation;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _showStatsIsland = false; // Controls stats island visibility

  // Bydgoszcz center coordinates
  static const LatLng _bydgoszczCenter = LatLng(53.1235, 18.0084);

  // Simulated user data
  final List<String> _discoveredIds = ['luczniczka', 'most_staromiejski'];

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
    // Auto-update unique monuments with new photos
    MonumentsService().autoUpdateUniqueMonuments();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get initial position
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
        });
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }

    // Listen to location updates
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        if (mounted) {
          setState(() {
            _userLocation = LatLng(position.latitude, position.longitude);
          });
        }
      },
      onError: (error) {
        debugPrint('Location stream error: $error');
        // Don't crash on location errors, just log them
      },
    );
  }

  void _centerOnUserLocation() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _bydgoszczCenter,
              initialZoom: 15.0,
              minZoom: 13.0,
              maxZoom: 18.0,
              // Better interaction physics
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
                // Smooth scrolling with momentum
                scrollWheelVelocity: 0.005,
                // Enable rotation and pinch zoom
                enableMultiFingerGestureRace: true,
                // Smoother zoom curve
                pinchZoomThreshold: 0.5,
                // Add momentum to panning
                enableScrollWheel: true,
              ),
              // Bounds to keep focus on Bydgoszcz
              maxBounds: LatLngBounds(
                const LatLng(53.05, 17.85), // Southwest
                const LatLng(53.20, 18.15), // Northeast
              ),
              onTap: (_, __) {
                setState(() => _selectedMonument = null);
              },
            ),
            children: [
              // OpenStreetMap tiles
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'pl.bydgoszcz.sciezki_pamieci',
              ),

              // Firestore Monument markers
              StreamBuilder<List<Monument>>(
                stream: MonumentsService().getMonuments(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print('StreamBuilder Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    print(
                        'StreamBuilder has data: ${snapshot.data?.length} items');
                  }

                  // Combine Firestore data with static data (deduplicating by ID)
                  final firestoreMonuments = snapshot.data ?? [];
                  final staticMonuments = MonumentsData.monuments;

                  // Use a map to deduplicate, preferring Firestore version
                  final monumentMap = {
                    for (var m in staticMonuments) m.id: m,
                    for (var m in firestoreMonuments) m.id: m,
                  };

                  final monuments = monumentMap.values.toList();

                  return MarkerLayer(
                    markers: monuments.map((monument) {
                      return Marker(
                        point: monument.location,
                        width: 44,
                        height: 54,
                        child: _buildMarker(monument),
                      );
                    }).toList(),
                  );
                },
              ),

              // User location marker
              if (_userLocation != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _userLocation!,
                      color: AppTheme.primaryBlue.withOpacity(0.3),
                      borderStrokeWidth: 3,
                      borderColor: Colors.white,
                      radius: 10,
                    ),
                    CircleMarker(
                      point: _userLocation!,
                      color: AppTheme.primaryBlue,
                      borderStrokeWidth: 2,
                      borderColor: Colors.white,
                      radius: 6,
                    ),
                  ],
                ),
            ],
          ),

          // Stats Island (replaces search bar)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: StatsIsland(
              isVisible: _showStatsIsland,
              activeGameTitle: null, // TODO: Connect to active game state
              activeGameTime: null,
            ),
          ),

          // Re-center location button
          Positioned(
            top: 80,
            right: 16,
            child: _buildLocationButton(),
          ),

          // Bottom navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationButton() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.background,
        shape: BoxShape.circle,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _centerOnUserLocation,
          borderRadius: BorderRadius.circular(24),
          child: Icon(
            Icons.my_location,
            color: _userLocation != null
                ? AppTheme.primaryBlue
                : AppTheme.textMuted,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildMarker(Monument monument) {
    final isSelected = _selectedMonument?.id == monument.id;

    return GestureDetector(
      onTap: () => _onMarkerTapped(monument),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Outer pulsing ring (only when selected)
          if (isSelected)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: monument.tier.color.withOpacity(0.2),
              ),
            ),

          // Middle ring for depth
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: monument.tier.color.withOpacity(0.3),
            ),
          ),

          // Main marker circle
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: monument.tier.color,
              border: Border.all(
                color: Colors.white,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: monument.tier.color.withOpacity(0.4),
                  blurRadius: isSelected ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          // Inner white dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
        left: 24,
        right: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, Icons.games_outlined, Icons.games, 'Gry'),
          _navItem(1, Icons.map, Icons.map, 'Mapa'),
          _navItem(2, Icons.person_outline, Icons.person, 'Profil'),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () => _navigateToScreen(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? AppTheme.primaryBlue : AppTheme.textMuted,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: isActive ? AppTheme.primaryBlue : AppTheme.textMuted,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _onMarkerTapped(Monument monument) {
    setState(() => _selectedMonument = monument);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DiscoveryCard(
        monument: monument,
        isDiscovered: _discoveredIds.contains(monument.id),
        onDiscover: () {
          setState(() {
            if (!_discoveredIds.contains(monument.id)) {
              _discoveredIds.add(monument.id);
            }
          });
        },
      ),
    );
  }

  void _navigateToScreen(int index) {
    if (index == _currentNavIndex && index == 1) return; // Already on map

    setState(() => _currentNavIndex = index);

    Widget? screen;
    switch (index) {
      case 0: // Gry
        screen = const GamesScreen();
        break;
      case 2: // Profil
        screen = const ProfileScreen();
        break;
      // case 1 is Map (current screen), no navigation needed
    }

    if (screen != null) {
      Navigator.of(context)
          .push(
        MaterialPageRoute(builder: (_) => screen!),
      )
          .then((_) {
        setState(() => _currentNavIndex = 1); // Return to map
      });
    }
  }
}
