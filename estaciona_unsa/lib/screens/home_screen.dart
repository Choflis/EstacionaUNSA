import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile/profile_screen.dart';
import '../providers/parking_provider.dart';
import '../providers/reservation_provider.dart';
import '../providers/auth_provider.dart';
import '../models/parking_zone_model.dart';
import '../utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar zonas, spots y reservas activas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parkingProvider = context.read<ParkingProvider>();
      final reservationProvider = context.read<ReservationProvider>();
      final authProvider = context.read<AuthProvider>();
      
      parkingProvider.loadZones();
      parkingProvider.loadAllSpots();
      
      // Cargar reservas activas si está autenticado
      if (authProvider.isAuthenticated) {
        reservationProvider.loadActiveReservations(authProvider.firebaseUser!.uid);
      }
    });
  }

  void _navigateToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  Future<void> _useReservation() async {
    final reservationProvider = context.read<ReservationProvider>();
    final parkingProvider = context.read<ParkingProvider>();
    final authProvider = context.read<AuthProvider>();
    final reservation = reservationProvider.currentReservation;

    if (reservation == null) return;

    final success = await reservationProvider.useReservation(
      reservation.reservationId,
      reservation.spotId,
      authProvider.firebaseUser!.uid,
    );

    if (success && mounted) {
      await Future.wait([
        parkingProvider.loadSpotsByZone(reservation.zoneId),
        parkingProvider.loadAllSpots(),
      ]);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('¡Estacionamiento confirmado!'),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  Future<void> _completeReservation() async {
    final reservationProvider = context.read<ReservationProvider>();
    final parkingProvider = context.read<ParkingProvider>();
    final authProvider = context.read<AuthProvider>();
    final reservation = reservationProvider.currentReservation;

    if (reservation == null) return;

    final success = await reservationProvider.completeReservation(
      reservation.reservationId,
      reservation.spotId,
      authProvider.firebaseUser!.uid,
    );

    if (success && mounted) {
      await Future.wait([
        parkingProvider.loadSpotsByZone(reservation.zoneId),
        parkingProvider.loadAllSpots(),
      ]);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('¡Gracias por usar EstacionaUNSA!'),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  // Calcular ocupación de una zona
  Map<String, dynamic> _getZoneOccupancy(ParkingZoneModel zone, ParkingProvider provider) {
    // Obtener estadísticas reales de los spots en memoria
    final stats = provider.getZoneStatistics(zone.zoneId);
    final total = (stats['total'] as int?) ?? zone.capacity.totalSpots;
    final available = (stats['available'] as int?) ?? zone.capacity.availableSpots;
    final percentage = total > 0 ? (available / total * 100).toDouble() : 0.0;

    Color statusColor;
    IconData icon;
    String status;

    if (percentage >= 50) {
      statusColor = const Color(0xFF28A745);
      icon = Icons.check_circle;
      status = 'Mayormente Disponible';
    } else if (percentage >= 20) {
      statusColor = const Color(0xFFFFC107);
      icon = Icons.error;
      status = 'Plazas Limitadas';
    } else {
      statusColor = const Color(0xFFDC3545);
      icon = Icons.cancel;
      status = 'Completo';
    }

    return {
      'available': available,
      'total': total,
      'percentage': percentage,
      'color': statusColor,
      'icon': icon,
      'status': status,
    };
  }

  Widget _buildZoneCardDynamic(ParkingZoneModel zone, ParkingProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final occupancy = _getZoneOccupancy(zone, provider);
    
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/parking-zone-detail',
          arguments: {
            'zoneId': zone.zoneId,
            'zoneName': zone.name,
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C2A38) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: occupancy['color'], width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  occupancy['status'],
                  style: TextStyle(
                    fontSize: 13,
                    color: occupancy['color'],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(occupancy['icon'], size: 16, color: occupancy['color']),
                const SizedBox(width: 4),
                Text(
                  '${occupancy['available']}/${occupancy['total']} Libres',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParkingCardDynamic(ParkingZoneModel zone, ParkingProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final occupancy = _getZoneOccupancy(zone, provider);
    final available = occupancy['available'] as int;
    final total = occupancy['total'] as int;
    final percentage = occupancy['percentage'] as double;
    final statusColor = occupancy['color'] as Color;
    final statusText = occupancy['status'] as String;
    final icon = occupancy['icon'] as IconData;
    
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/parking-zone-detail',
          arguments: {
            'zoneId': zone.zoneId,
            'zoneName': zone.name,
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C2A38) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: statusColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zone.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        zone.location.address,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        '$available/$total',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              statusText,
              style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w500),
            ),
            
            const SizedBox(height: 8),
            
            // Barra de progreso
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF101922).withValues(alpha: 0.8) : const Color(0xFFF6F7F8).withValues(alpha: 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.directions_car, color: Color(0xFF8A0000), size: 30),
                    const SizedBox(width: 8),
                    const Text(
                      'UNSA Parking',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.account_circle),
                      onPressed: _navigateToProfile,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reserva Activa (si existe)
                  Consumer<ReservationProvider>(
                    builder: (context, reservationProvider, child) {
                      if (reservationProvider.hasActiveReservation) {
                        return _buildActiveReservationCard(reservationProvider, isDark);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  
                  // Resumen General
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen General',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Estado rápido de todas las áreas',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Scroll horizontal de zonas
                  Consumer<ParkingProvider>(
                    builder: (context, parkingProvider, child) {
                      if (parkingProvider.isLoading && parkingProvider.zones.isEmpty) {
                        return const SizedBox(
                          height: 140,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (parkingProvider.zones.isEmpty) {
                        return const SizedBox(
                          height: 140,
                          child: Center(
                            child: Text('No hay zonas disponibles'),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 140,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: parkingProvider.zones.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final zone = parkingProvider.zones[index];
                            return _buildZoneCardDynamic(zone, parkingProvider);
                          },
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Área de Ingenierías
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Área de Ingenierías',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Disponibilidad en tiempo real',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Lista de estacionamientos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Consumer<ParkingProvider>(
                      builder: (context, parkingProvider, child) {
                        final engineeringZones = parkingProvider.zones
                            .where((z) => z.zoneId.startsWith('ing_'))
                            .toList();

                        if (engineeringZones.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text('No hay zonas de ingenierías disponibles'),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            ...engineeringZones.map((zone) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildParkingCardDynamic(zone, parkingProvider),
                              );
                            }).toList(),
                            const SizedBox(height: 80),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // La barra inferior la maneja `MainNavScreen`. No se incluye aquí para evitar duplicados.
    );
  }

  Widget _buildZoneCard(String title, String status, int available, int total, Color statusColor, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C2A38) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: statusColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(fontSize: 13, color: statusColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            children: [
              Icon(icon, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(
                '$available/$total Libres',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParkingCard(String name, int total, int available, Color statusColor, String statusText, IconData icon, {String? zoneId}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = (available / total * 100).clamp(0, 100);
    
    return InkWell(
      onTap: zoneId != null ? () {
        Navigator.pushNamed(
          context,
          '/parking-zone-detail',
          arguments: {
            'zoneId': zoneId,
            'zoneName': name,
          },
        );
      } : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C2A38) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                children: [
                  Icon(icon, size: 16, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    statusText,
                    style: TextStyle(fontSize: 13, color: statusColor, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Total: $total plazas',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Disponibles', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text(
                '$available / $total',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 10,
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildActiveReservationCard(ReservationProvider reservationProvider, bool isDark) {
    final reservation = reservationProvider.currentReservation!;
    final isUsed = reservation.status == 'used';
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUsed
              ? [const Color(0xFF10B981), const Color(0xFF059669)]
              : [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isUsed ? const Color(0xFF10B981) : const Color(0xFF3B82F6))
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isUsed ? Icons.local_parking : Icons.timer,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isUsed ? 'Estacionado' : 'Reserva Activa',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Espacio ${reservation.spotId.split('_').last}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isUsed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        Helpers.formatTimeRemaining(reservation.time.expiresAt),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  reservation.zoneId.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Botón de acción según el estado
          if (!isUsed)
            ElevatedButton.icon(
              onPressed: _useReservation,
              icon: const Icon(Icons.check_circle, size: 20),
              label: const Text('Ya me estacioné'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          if (isUsed)
            ElevatedButton.icon(
              onPressed: _completeReservation,
              icon: const Icon(Icons.exit_to_app, size: 20),
              label: const Text('Ya me salí'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF10B981),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  // Nota: no hay método _buildNavItem porque la navegación inferior es responsabilidad de MainNavScreen.
}
