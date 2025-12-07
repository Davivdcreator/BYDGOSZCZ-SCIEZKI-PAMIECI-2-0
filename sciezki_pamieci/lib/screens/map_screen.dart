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
import '../models/game.dart';
import '../services/monuments_service.dart';
import '../services/game_state_service.dart';

import 'discovery_card.dart';
import 'profile_screen.dart';
import 'games_screen.dart';
import '../widgets/stats_island.dart';

/// Screen 2: Main Map Screen - Clean modern design
class MapScreen extends StatefulWidget {
  final Game? activeGame;

  const MapScreen({super.key, this.activeGame});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  Monument? _selectedMonument;
  int _currentNavIndex = 1; // Start at 1 (Mapa is center)
  LatLng? _userLocation;
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<Game?>? _gameStateSubscription;
  final bool _showStatsIsland = false; // Controls stats island visibility

  Game? _activeGame;
  List<Monument> _cachedMonuments = [];

  // Bydgoszcz center coordinates
  static const LatLng _bydgoszczCenter = LatLng(53.1235, 18.0084);

  // Simulated user data
  final List<String> _discoveredIds = ['luczniczka', 'most_staromiejski'];

  @override
  void initState() {
    super.initState();
    _activeGame = widget.activeGame;

    // If game passed via constructor, start it
    if (widget.activeGame != null) {
      GameStateService().startGame(widget.activeGame!);
    }

    // Listen to game state changes
    _gameStateSubscription = GameStateService().gameStream.listen((game) {
      if (mounted) {
        setState(() => _activeGame = game);
      }
    });

    _initLocationTracking();
    // Auto-update unique monuments with new photos
    MonumentsService().autoUpdateUniqueMonuments();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _gameStateSubscription?.cancel();
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

  void _endGame() {
    GameStateService().endGame();
    setState(() => _activeGame = null);
  }

  // Get filtered monuments based on active game
  List<Monument> _filterMonuments(List<Monument> allMonuments) {
    if (_activeGame == null) {
      return allMonuments;
    }
    // Filter to only show monuments in the active game
    return allMonuments
        .where((m) => _activeGame!.monumentIds.contains(m.id))
        .toList();
  }

  // Build route polyline from user location through monuments
  List<LatLng> _buildRoute(List<Monument> monuments) {
    if (_activeGame == null || monuments.isEmpty) return [];

    // Order monuments according to monumentIds order
    final orderedMonuments = <Monument>[];
    for (final id in _activeGame!.monumentIds) {
      final monument = monuments.where((m) => m.id == id).firstOrNull;
      if (monument != null) {
        orderedMonuments.add(monument);
      }
    }

    // Build route: user location → monuments → end point
    final routePoints = <LatLng>[];

    // Start from user's current location if available
    if (_userLocation != null) {
      routePoints.add(_userLocation!);
    }

    // Add all monument locations in order
    routePoints.addAll(orderedMonuments.map((m) => m.location));

    return routePoints;
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

                  // Combine Firestore data with static data (deduplicating by ID)
                  final firestoreMonuments = snapshot.data ?? [];
                  const staticMonuments = MonumentsData.monuments;

                  // Use a map to deduplicate, preferring Firestore version
                  final monumentMap = {
                    for (var m in staticMonuments) m.id: m,
                    for (var m in firestoreMonuments) m.id: m,
                  };

                  final allMonuments = monumentMap.values.toList();

                  // Filter monuments if game is active
                  final monuments = _filterMonuments(allMonuments);
                  _cachedMonuments = monuments;

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

              // Route polyline (only when game is active)
              if (_activeGame != null && _cachedMonuments.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _buildRoute(_cachedMonuments),
                      strokeWidth: 5.0,
                      color: AppTheme.primaryBlue.withOpacity(0.8),
                      borderStrokeWidth: 3.0,
                      borderColor: Colors.white.withOpacity(0.9),
                      isDotted: false,
                    ),
                  ],
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

          // Active game banner
          if (_activeGame != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              child: _buildActiveGameBanner(),
            ),

          // Stats Island (when no game active)
          if (_activeGame == null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: StatsIsland(
                isVisible: _showStatsIsland,
                activeGameTitle: null,
                activeGameTime: null,
              ),
            ),

          // Re-center location button (bottom right, above nav)
          Positioned(
            bottom: 100,
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

  Widget _buildActiveGameBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.gamepad,
              color: AppTheme.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _activeGame!.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_activeGame!.monumentIds.length} punktów',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _endGame,
            child: Text(
              'Zakończ',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
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
        userLocation: _userLocation,
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
