import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../theme/tier_colors.dart';
import '../data/monuments_data.dart';
import '../models/monument.dart';
import '../widgets/frosted_glass_panel.dart';
import '../widgets/map_marker.dart';
import 'discovery_card.dart';
import 'profile_screen.dart';
import 'collection_screen.dart';
import 'quests_screen.dart';
import 'ar_view_screen.dart';

/// Screen 2: Main Map Screen - "The Canvas" HUB
/// Interactive canvas of the city
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
  int _userXP = 350;
  int _userLevel = 2;
  List<String> _discoveredIds = ['luczniczka', 'most_staromiejski'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background texture
          Container(
            decoration: BoxDecoration(
              color: AppTheme.porcelainWhite,
              image: const DecorationImage(
                image: AssetImage('assets/textures/wooden-floor-background.jpg'),
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
          ),
          
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
              // OpenStreetMap tiles (light style)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'pl.bydgoszcz.sciezki_pamieci',
                tileBuilder: (context, child, tile) {
                  // Apply slight color filter for "paper" effect
                  return ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      AppTheme.porcelainWhite.withOpacity(0.1),
                      BlendMode.srcOver,
                    ),
                    child: child,
                  );
                },
              ),
              
              // River overlay (simulated watercolor effect)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      LatLng(53.1180, 18.0040),
                      LatLng(53.1220, 18.0060),
                      LatLng(53.1240, 18.0080),
                      LatLng(53.1260, 18.0110),
                      LatLng(53.1280, 18.0140),
                    ],
                    color: AppTheme.riverBlue.withOpacity(0.4),
                    strokeWidth: 30,
                  ),
                ],
              ),
              
              // Monument markers
              MarkerLayer(
                markers: MonumentsData.monuments.map((monument) {
                  return Marker(
                    point: monument.location,
                    width: 50,
                    height: 65,
                    child: TierMapMarker(
                      tier: monument.tier,
                      isSelected: _selectedMonument?.id == monument.id,
                      onTap: () => _onMarkerTapped(monument),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          
          // Top bar (Frosted glass with profile and XP)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(),
          ),
          
          // Bottom radar panel
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: _buildRadarPanel(),
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
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  
  Widget _buildTopBar() {
    return SafeArea(
      child: FrostedGlassPanel(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            // Profile avatar
            GestureDetector(
              onTap: () => _navigateToScreen(3),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.copperGradient,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Level and XP
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Poziom $_userLevel',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_userXP % 500) / 500,
                      backgroundColor: AppTheme.textMuted.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation(AppTheme.oxidizedCopper),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // XP count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.oxidizedCopper.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    color: AppTheme.oxidizedCopper,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$_userXP XP',
                    style: const TextStyle(
                      color: AppTheme.oxidizedCopper,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRadarPanel() {
    // Find nearby monuments
    final nearby = MonumentsData.getNearby(_bydgoszczCenter, 500);
    final undiscovered = nearby.where((m) => !_discoveredIds.contains(m.id)).length;
    
    return FrostedGlassPanel(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.oxidizedCopper.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.radar,
              color: AppTheme.oxidizedCopper,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'W pobliżu',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${nearby.length} obiektów do odkrycia',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          if (undiscovered > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.oldGold,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$undiscovered nowych',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildBottomNav() {
    return FrostedGlassPanel(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      padding: const EdgeInsets.only(top: 8, bottom: 24, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, Icons.map_outlined, Icons.map, 'Mapa'),
          _navItem(1, Icons.collections_bookmark_outlined, Icons.collections_bookmark, 'Album'),
          const SizedBox(width: 60), // Space for FAB
          _navItem(2, Icons.emoji_events_outlined, Icons.emoji_events, 'Wyzwania'),
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
            color: isActive ? AppTheme.oxidizedCopper : AppTheme.textMuted,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppTheme.oxidizedCopper : AppTheme.textMuted,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFAB() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppTheme.copperGradient,
          boxShadow: [
            BoxShadow(
              color: AppTheme.oxidizedCopper.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _openARView,
            customBorder: const CircleBorder(),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, color: Colors.white, size: 26),
                Text(
                  'SKANUJ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _onMarkerTapped(Monument monument) {
    setState(() => _selectedMonument = monument);
    
    // Show Discovery Card bottom sheet
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
              _userXP += 100;
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
        screen = ProfileScreen(
          discoveredCount: _discoveredIds.length,
          xp: _userXP,
          level: _userLevel,
        );
        break;
    }
    
    if (screen != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => screen!),
      ).then((_) {
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
