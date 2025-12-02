import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/reservation_provider.dart';
import '../providers/parking_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/helpers.dart';

class MyReservationScreen extends StatefulWidget {
  const MyReservationScreen({super.key});

  @override
  State<MyReservationScreen> createState() => _MyReservationScreenState();
}

class _MyReservationScreenState extends State<MyReservationScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {}); // Update UI every second
      }
    });
  }

  Future<void> _cancelReservation() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withValues(alpha: 0.1),
                      Colors.red.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        '¿Cancelar reserva?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '¿Estás seguro de que quieres cancelar tu reserva? Esta acción no se puede deshacer.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          side: BorderSide(
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('No, volver'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Sí, cancelar'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      final reservationProvider = context.read<ReservationProvider>();
      final reservation = reservationProvider.currentReservation;
      
      if (reservation != null) {
        final success = await reservationProvider.cancelReservation(
          reservation.reservationId,
          reservation.spotId,
        );
        
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reserva cancelada'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    }
  }

  Future<void> _confirmArrival() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF10B981).withValues(alpha: 0.1),
                      const Color(0xFF10B981).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color(0xFF10B981),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        '¿Ya te estacionaste?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '¿Confirmas que ya estás estacionado en tu espacio reservado?',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          side: BorderSide(
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('No todavía'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Sí, confirmar'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      final reservationProvider = context.read<ReservationProvider>();
      final parkingProvider = context.read<ParkingProvider>();
      final authProvider = context.read<AuthProvider>();
      final reservation = reservationProvider.currentReservation;
      
      if (reservation != null) {
        final success = await reservationProvider.useReservation(
          reservation.reservationId,
          reservation.spotId,
          authProvider.firebaseUser!.uid,
        );
        
        if (success && mounted) {
          // Recargar los datos para actualizar los contadores
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
                  Text('¡Estacionamiento confirmado! Disfruta tu estadía.'),
                ],
              ),
              backgroundColor: Color(0xFF10B981),
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Reserva'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Consumer<ReservationProvider>(
        builder: (context, reservationProvider, child) {
          if (!reservationProvider.hasActiveReservation) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes reservas activas',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar espacios'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final reservation = reservationProvider.currentReservation!;
          final remainingTime = reservation.time.expiresAt.difference(DateTime.now());
          final isExpiringSoon = Helpers.isReservationExpiringSoon(reservation.time.expiresAt);
          final isExpired = Helpers.isReservationExpired(reservation.time.expiresAt);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Timer Card
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isExpired
                          ? [Colors.red.shade400, Colors.red.shade700]
                          : isExpiringSoon
                              ? [Colors.orange.shade400, Colors.orange.shade700]
                              : [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (isExpired ? Colors.red : isExpiringSoon ? Colors.orange : const Color(0xFF1565C0))
                            .withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Tiempo restante',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isExpired ? 'EXPIRADO' : Helpers.formatTimeRemaining(reservation.time.expiresAt),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!isExpired) ...[
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: remainingTime.inSeconds / (reservation.time.durationMinutes * 60),
                          backgroundColor: Colors.white30,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ],
                    ],
                  ),
                ),

                // Spot Info
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
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
                              color: const Color(0xFF1565C0).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.local_parking,
                              color: Color(0xFF1565C0),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Espacio Reservado',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Espacio ${reservation.spotId}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _buildInfoRow(
                        Icons.access_time,
                        'Reservado',
                        Helpers.formatDateTime(reservation.createdAt),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.timer,
                        'Duración',
                        '${reservation.time.durationMinutes} minutos',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.event,
                        'Expira',
                        Helpers.formatDateTime(reservation.time.expiresAt),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Warning or Info
                if (isExpiringSoon && !isExpired)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '¡Tu reserva está por expirar! Dirígete al estacionamiento pronto.',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (isExpired)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tu reserva ha expirado. El espacio ya no está reservado para ti.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (!isExpired) ...[
                        // Botón principal: Ya me estacioné
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _confirmArrival,
                            icon: const Icon(Icons.check_circle, size: 22),
                            label: const Text(
                              'Ya me estacioné',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Botón secundario: Cómo llegar
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Navigate to map/directions
                            },
                            icon: const Icon(Icons.directions_outlined, size: 20),
                            label: const Text('Cómo llegar'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF1565C0),
                              side: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      // Botón de cancelar
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _cancelReservation,
                          icon: const Icon(Icons.cancel_outlined, size: 20),
                          label: Text(isExpired ? 'Cerrar' : 'Cancelar Reserva'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
