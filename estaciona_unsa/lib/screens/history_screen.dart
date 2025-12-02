import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_provider.dart';
import '../providers/parking_provider.dart';
import '../providers/auth_provider.dart';
import '../models/reservation_model.dart';
import '../utils/helpers.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'all'; // all, active, used, completed, cancelled, expired

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final authProvider = context.read<AuthProvider>();
    final reservationProvider = context.read<ReservationProvider>();
    
    if (authProvider.isAuthenticated) {
      await Future.wait([
        reservationProvider.loadActiveReservations(authProvider.firebaseUser!.uid),
        reservationProvider.loadReservationHistory(authProvider.firebaseUser!.uid, limit: 50),
      ]);
    }
  }

  List<ReservationModel> _getAllReservations(ReservationProvider provider) {
    final all = <ReservationModel>[];
    all.addAll(provider.activeReservations);
    all.addAll(provider.reservationHistory);
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return all;
  }

  List<ReservationModel> _getFilteredReservations(List<ReservationModel> reservations) {
    if (_selectedFilter == 'all') return reservations;
    
    return reservations.where((r) {
      switch (_selectedFilter) {
        case 'active':
          return r.isActive;
        case 'used':
          return r.isUsed;
        case 'completed':
          return r.isCompleted;
        case 'cancelled':
          return r.isCancelled;
        case 'expired':
          return r.isExpired;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      appBar: AppBar(
        title: const Text('Historial de Reservas'),
        backgroundColor: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
      ),
      body: Consumer<ReservationProvider>(
        builder: (context, reservationProvider, child) {
          if (reservationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final allReservations = _getAllReservations(reservationProvider);
          final filteredReservations = _getFilteredReservations(allReservations);

          return RefreshIndicator(
            onRefresh: _loadHistory,
            child: Column(
              children: [
                // Filtros
                Container(
                  padding: const EdgeInsets.all(16),
                  color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Todos', 'all', allReservations.length, isDark),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Activas',
                          'active',
                          allReservations.where((r) => r.isActive).length,
                          isDark,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Estacionado',
                          'used',
                          allReservations.where((r) => r.isUsed).length,
                          isDark,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Completadas',
                          'completed',
                          allReservations.where((r) => r.isCompleted).length,
                          isDark,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Canceladas',
                          'cancelled',
                          allReservations.where((r) => r.isCancelled).length,
                          isDark,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Expiradas',
                          'expired',
                          allReservations.where((r) => r.isExpired).length,
                          isDark,
                        ),
                      ],
                    ),
                  ),
                ),

                // Lista de reservas
                Expanded(
                  child: filteredReservations.isEmpty
                      ? _buildEmptyState(isDark)
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredReservations.length,
                          itemBuilder: (context, index) {
                            final reservation = filteredReservations[index];
                            return _buildReservationCard(
                              reservation,
                              isDark,
                              reservationProvider,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, int count, bool isDark) {
    final isSelected = _selectedFilter == value;
    
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.3)
                    : const Color(0xFF1565C0).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF1565C0),
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFilter = value);
        }
      },
      selectedColor: const Color(0xFF1565C0),
      backgroundColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : isDark
                ? Colors.white70
                : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? const Color(0xFF1565C0)
              : isDark
                  ? const Color(0xFF4B5563)
                  : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }

  Widget _buildReservationCard(
    ReservationModel reservation,
    bool isDark,
    ReservationProvider reservationProvider,
  ) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    // Verificar el estado en tiempo real desde el provider
    final currentReservation = reservationProvider.activeReservations
        .where((r) => r.reservationId == reservation.reservationId)
        .firstOrNull;
    
    final isActive = currentReservation?.isActive ?? reservation.isActive;
    final isUsed = currentReservation?.isUsed ?? reservation.isUsed;

    // Usar el estado más actualizado
    final actualReservation = currentReservation ?? reservation;

    if (actualReservation.isCompleted) {
      statusColor = const Color(0xFF10B981);
      statusIcon = Icons.check_circle;
      statusText = 'Completada';
    } else if (actualReservation.isUsed) {
      statusColor = const Color(0xFF0D47A1);
      statusIcon = Icons.directions_car;
      statusText = 'Estacionado';
    } else if (actualReservation.isCancelled) {
      statusColor = Colors.orange;
      statusIcon = Icons.cancel;
      statusText = 'Cancelada';
    } else if (actualReservation.isExpired) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
      statusText = 'Expirada';
    } else {
      statusColor = const Color(0xFF1565C0);
      statusIcon = Icons.local_parking;
      statusText = 'Activa';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con estado
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.local_parking_rounded,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Espacio ${actualReservation.spotId.split('_').last}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Zona: ${actualReservation.zoneId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
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

            const SizedBox(height: 16),

            // Información de la reserva
            if (isActive && !isUsed) ...[
              // Reserva activa pero aún no llegó - mostrar timer y "Ya me estacioné"
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1565C0).withValues(alpha: 0.1),
                      const Color(0xFF0D47A1).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 20, color: Color(0xFF1565C0)),
                    const SizedBox(width: 8),
                    Text(
                      'Expira en: ',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      Helpers.formatTimeRemaining(reservation.time.expiresAt),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _confirmArrival(reservation, reservationProvider),
                      icon: const Icon(Icons.check_circle, size: 18),
                      label: const Text('Ya me estacioné'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _cancelReservation(reservation, reservationProvider),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Cancelar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (isUsed) ...[
              // Ya está estacionado - mostrar "Ya me salí"
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0D47A1).withValues(alpha: 0.1),
                      const Color(0xFF1565C0).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.directions_car, size: 20, color: Color(0xFF0D47A1)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Estás estacionado en este espacio',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _completeReservation(reservation, reservationProvider),
                  icon: const Icon(Icons.exit_to_app, size: 18),
                  label: const Text('Ya me salí'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      Icons.access_time_outlined,
                      'Reservado',
                      Helpers.formatDateTime(reservation.createdAt),
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      Icons.timer_outlined,
                      'Duración',
                      '${reservation.time.durationMinutes} min',
                      isDark,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoRow(
                      Icons.event_outlined,
                      'Expiró',
                      Helpers.formatTime(reservation.time.expiresAt),
                      isDark,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmArrival(ReservationModel reservation, ReservationProvider provider) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.read<AuthProvider>();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      final success = await provider.useReservation(
        reservation.reservationId,
        reservation.spotId,
        authProvider.firebaseUser!.uid,
      );
      
      if (success && mounted) {
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
        // Recargar después de un breve delay para asegurar que Firebase se actualizó
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          await _loadHistory();
        }
      }
    }
  }

  Future<void> _completeReservation(ReservationModel reservation, ReservationProvider provider) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.read<AuthProvider>();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
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
                        Icons.exit_to_app_rounded,
                        color: Color(0xFF10B981),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        '¿Ya te saliste?',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '¿Confirmas que ya saliste del estacionamiento? El espacio quedará disponible para otros.',
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Sí, ya salí'),
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
      final success = await provider.completeReservation(
        reservation.reservationId,
        reservation.spotId,
        authProvider.firebaseUser!.uid,
      );
      
      if (success && mounted) {
        // Recargar los datos para actualizar los contadores
        final parkingProvider = context.read<ParkingProvider>();
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
        // Recargar después de un breve delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          await _loadHistory();
        }
      }
    }
  }

  Future<void> _cancelReservation(ReservationModel reservation, ReservationProvider provider) async {
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
                      child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        '¿Cancelar reserva?',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      final success = await provider.cancelReservation(
        reservation.reservationId,
        reservation.spotId,
      );
      
      if (success && mounted) {
        // Recargar los datos para actualizar los contadores
        final parkingProvider = context.read<ParkingProvider>();
        await Future.wait([
          parkingProvider.loadSpotsByZone(reservation.zoneId),
          parkingProvider.loadAllSpots(),
        ]);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reserva cancelada'),
            backgroundColor: Colors.green,
          ),
        );
        _loadHistory();
      }
    }
  }

  Widget _buildEmptyState(bool isDark) {
    String message;
    IconData icon;
    
    switch (_selectedFilter) {
      case 'active':
        message = 'No tienes reservas activas';
        icon = Icons.local_parking_outlined;
        break;
      case 'used':
        message = 'No estás estacionado actualmente';
        icon = Icons.directions_car_outlined;
        break;
      case 'completed':
        message = 'No tienes reservas completadas';
        icon = Icons.check_circle_outline;
        break;
      case 'cancelled':
        message = 'No tienes reservas canceladas';
        icon = Icons.cancel_outlined;
        break;
      case 'expired':
        message = 'No tienes reservas expiradas';
        icon = Icons.error_outline;
        break;
      default:
        message = 'Aún no tienes historial de reservas';
        icon = Icons.history;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}