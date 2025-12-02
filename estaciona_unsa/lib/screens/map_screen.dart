import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/parking_provider.dart';
import '../models/parking_zone_model.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController? _mapController;
  Position? _currentPosition;
  bool _isLoadingLocation = true;
  final List<Marker> _markers = [];
  
  // Coordenadas de la UNSA (Arequipa)
  static const LatLng _unsaLocation = LatLng(-16.403736, -71.526178);
  
  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadZones();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentPosition = position;
          _isLoadingLocation = false;
        });
      } else {
        setState(() => _isLoadingLocation = false);
      }
    } catch (e) {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _loadZones() async {
    final parkingProvider = context.read<ParkingProvider>();
    await parkingProvider.loadZones();
    _createMarkers();
  }

  void _createMarkers() {
    final parkingProvider = context.read<ParkingProvider>();
    final zones = parkingProvider.zones;

    setState(() {
      _markers.clear();
      
      for (final zone in zones) {
        final availableSpots = zone.capacity.availableSpots;
        final totalSpots = zone.capacity.totalSpots;
        final percentage = (availableSpots / totalSpots * 100).round();
        
        // Determinar color del marcador según disponibilidad
        Color markerColor;
        if (availableSpots == 0) {
          markerColor = Colors.red;
        } else if (percentage > 50) {
          markerColor = Colors.green;
        } else if (percentage > 20) {
          markerColor = Colors.orange;
        } else {
          markerColor = Colors.yellow;
        }

        _markers.add(
          Marker(
            point: LatLng(
              zone.location.latitude,
              zone.location.longitude,
            ),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _showZoneDetails(zone),
              child: Column(
                children: [
                  Icon(
                    Icons.location_on,
                    color: markerColor,
                    size: 40,
                    shadows: [
                      Shadow(
                        blurRadius: 3,
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  void _showZoneDetails(ParkingZoneModel zone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildZoneDetailsSheet(zone),
    );
  }

  Widget _buildZoneDetailsSheet(ParkingZoneModel zone) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final availableSpots = zone.capacity.availableSpots;
    final totalSpots = zone.capacity.totalSpots;
    final percentage = (availableSpots / totalSpots * 100).round();
    
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    if (availableSpots == 0) {
      statusColor = const Color(0xFFEF4444);
      statusText = 'Completo';
      statusIcon = Icons.cancel;
    } else if (percentage > 50) {
      statusColor = const Color(0xFF10B981);
      statusText = 'Disponible';
      statusIcon = Icons.check_circle;
    } else {
      statusColor = const Color(0xFFF59E0B);
      statusText = 'Plazas limitadas';
      statusIcon = Icons.warning;
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Zona info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_parking,
                  size: 32,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zone.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Estadísticas
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Disponibles',
                  '$availableSpots',
                  const Color(0xFF10B981),
                  Icons.check_circle,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
                _buildStatItem(
                  'Total',
                  '$totalSpots',
                  const Color(0xFF6B7280),
                  Icons.local_parking,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
                _buildStatItem(
                  'Ocupados',
                  '${totalSpots - availableSpots}',
                  const Color(0xFFEF4444),
                  Icons.cancel,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Ubicación
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 18,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  zone.location.address,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Botones
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToZone(zone);
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Cómo llegar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: availableSpots > 0
                      ? () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/parking-zone-detail',
                            arguments: {
                              'zoneId': zone.zoneId,
                              'zoneName': zone.name,
                            },
                          );
                        }
                      : null,
                  icon: const Icon(Icons.local_parking, size: 20),
                  label: const Text('Ver espacios'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _navigateToZone(ParkingZoneModel zone) {
    final destination = LatLng(zone.location.latitude, zone.location.longitude);
    _mapController?.move(destination, 18);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          // Mapa
          FlutterMap(
            mapController: _mapController ??= MapController(),
            options: MapOptions(
              initialCenter: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : _unsaLocation,
              initialZoom: 16,
              minZoom: 5,
              maxZoom: 19,
            ),
            children: [
              TileLayer(
                urlTemplate: isDark
                    ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: isDark ? [] : ['a', 'b', 'c'],
                userAgentPackageName: 'com.unsa.estaciona_unsa',
              ),
              MarkerLayer(markers: _markers),
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          
          // Header
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.map, color: Color(0xFF8A0000), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Estacionamientos UNSA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          '${_markers.length} zonas disponibles',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _loadZones,
                    icon: const Icon(Icons.refresh),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Botón Mi ubicación
          Positioned(
            right: 16,
            bottom: 200,
            child: FloatingActionButton(
              onPressed: () {
                if (_currentPosition != null) {
                  _mapController?.move(
                    LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    17,
                  );
                }
              },
              backgroundColor: isDark ? const Color(0xFF1A1F2E) : Colors.white,
              child: Icon(
                Icons.my_location,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}