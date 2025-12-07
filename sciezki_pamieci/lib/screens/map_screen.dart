import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../theme/tier_colors.dart';
import '../data/monuments_data.dart';
import '../models/monument.dart';
import '../services/monuments_service.dart';

import 'discovery_card.dart';
import 'profile_screen.dart';
import 'collection_screen.dart';
import 'quests_screen.dart';
import 'ar_view_screen.dart';

/// Screen 2: Main Map Screen - Clean modern design
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  Monument? _selectedMonument;
  int _currentNavIndex = 0;

  // Bydgoszcz center coordinates
  static const LatLng _bydgoszczCenter = LatLng(53.1235, 18.0084);

  // Simulated user data
  final List<String> _discoveredIds = ['luczniczka', 'most_staromiejski'];

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
              minZoom: 12,
              maxZoom: 18,
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
                  final monuments = snapshot.data ?? MonumentsData.monuments;

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
            ],
          ),

          // Search bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildSearchBar(),
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
      floatingActionButton: _buildScanFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildMarker(Monument monument) {
    final isSelected = _selectedMonument?.id == monument.id;

    return GestureDetector(
      onTap: () => _onMarkerTapped(monument),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isSelected ? 40 : 36,
              height: isSelected ? 40 : 36,
              decoration: BoxDecoration(
                color: monument.tier.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: monument.tier.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.location_on,
                color: Colors.white,
                size: isSelected ? 22 : 18,
              ),
            ),
            // Pin tail
            Container(
              width: 3,
              height: 8,
              decoration: BoxDecoration(
                color: monument.tier.color,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.subtleShadow,
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Icon(
                Icons.search,
                color: AppTheme.textMuted,
                size: 22,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Szukaj miejsc...',
                  hintStyle: GoogleFonts.inter(
                    color: AppTheme.textMuted,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
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
          _navItem(0, Icons.map_outlined, Icons.map, 'Mapa'),
          _navItem(1, Icons.collections_bookmark_outlined,
              Icons.collections_bookmark, 'Album'),
          const SizedBox(width: 56), // Space for FAB
          _navItem(
              2, Icons.emoji_events_outlined, Icons.emoji_events, 'Wyzwania'),
          _navItem(3, Icons.person_outline, Icons.person, 'Profil'),
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

  Widget _buildScanFAB() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 56),
      child: GestureDetector(
        onTap: _openARView,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
            size: 26,
          ),
        ),
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
    if (index == _currentNavIndex && index == 0) return;

    setState(() => _currentNavIndex = index);

    Widget? screen;
    switch (index) {
      case 1:
        screen = CollectionScreen(discoveredIds: _discoveredIds);
        break;
      case 2:
        screen = QuestsScreen(discoveredIds: _discoveredIds);
        break;
      case 3:
        screen = const ProfileScreen();
        break;
    }

    if (screen != null) {
      Navigator.of(context)
          .push(
        MaterialPageRoute(builder: (_) => screen!),
      )
          .then((_) {
        setState(() => _currentNavIndex = 0);
      });
    }
  }

  void _openARView() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ARViewScreen()),
    );
  }
}
