import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/parking_spot_model.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/parking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/constants.dart';
import '../../utils/helpers.dart';

class SpotReservationModal extends StatefulWidget {
  final ParkingSpotModel spot;
  final String zoneName;

  const SpotReservationModal({
    super.key,
    required this.spot,
    required this.zoneName,
  });

  @override
  State<SpotReservationModal> createState() => _SpotReservationModalState();
}

class _SpotReservationModalState extends State<SpotReservationModal> {
  int _selectedDuration = AppConstants.defaultReservationMinutes;
  bool _isLoading = false;

  final List<int> _durationOptions = [
    15, 30, 45, 60, 90, 120
  ];

  Future<void> _createReservation() async {
    print('🔵 [MODAL] Botón presionado - Iniciando _createReservation');
    
    final authProvider = context.read<AuthProvider>();
    final reservationProvider = context.read<ReservationProvider>();

    print('🔵 [MODAL] Auth: ${authProvider.isAuthenticated}, User: ${authProvider.currentUserData?.email}');

    if (!authProvider.isAuthenticated || authProvider.currentUserData == null) {
      print('❌ [MODAL] Usuario no autenticado');
      _showError('Debes iniciar sesión para reservar');
      return;
    }

    // Check if already has active reservation
    print('🔵 [MODAL] Verificando reservas activas: ${reservationProvider.hasActiveReservation}');
    if (reservationProvider.hasActiveReservation) {
      print('⚠️ [MODAL] Ya tiene reserva activa');
      _showActiveReservationDialog(reservationProvider);
      return;
    }

    print('🔵 [MODAL] Cambiando estado a loading');
    setState(() => _isLoading = true);

    try {
      print('🔵 [MODAL] Llamando a createReservation...');
      final reservationId = await reservationProvider.createReservation(
        userId: authProvider.firebaseUser!.uid,
        spotId: widget.spot.spotId,
        zoneId: widget.spot.zoneId,
        durationMinutes: _selectedDuration,
        latitude: 0.0,
        longitude: 0.0,
        distanceToZone: 0.0,
      );

      print('🔵 [MODAL] Resultado: $reservationId');

      if (mounted && reservationId != null) {
        print('✅ [MODAL] Reserva creada exitosamente');
        
        // Recargar los spots de la zona actual y todos los spots para actualizar contadores
        final parkingProvider = context.read<ParkingProvider>();
        await Future.wait([
          parkingProvider.loadSpotsByZone(widget.spot.zoneId),
          parkingProvider.loadAllSpots(),
        ]);
        
        Navigator.of(context).pop();
        _showSuccess('¡Reserva creada exitosamente!');
      } else if (mounted) {
        print('❌ [MODAL] No se pudo crear la reserva');
        _showError('No se pudo crear la reserva');
      }
    } catch (e, stackTrace) {
      print('❌ [MODAL] ERROR en createReservation: $e');
      print('❌ [MODAL] Stack trace: $stackTrace');
      if (mounted) {
        _showError('Error: $e');
      }
    } finally {
      if (mounted) {
        print('🔵 [MODAL] Finalizando - cambiando loading a false');
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _showActiveReservationDialog(ReservationProvider reservationProvider) async {
    final currentReservation = reservationProvider.currentReservation;
    if (currentReservation == null) return;
    
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final action = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header con gradiente
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1565C0).withValues(alpha: 0.1),
                      const Color(0xFF1565C0).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF1565C0),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reserva activa',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ya tienes un espacio reservado',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Card de la reserva actual
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1565C0).withValues(alpha: 0.1),
                            const Color(0xFF0D47A1).withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF1565C0).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1565C0).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.local_parking_rounded,
                                  color: Color(0xFF1565C0),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Espacio ${currentReservation.spotId.split('_').last}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Zona: ${currentReservation.zoneId}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark 
                                  ? const Color(0xFF0D47A1).withValues(alpha: 0.2)
                                  : const Color(0xFF1565C0).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 18,
                                  color: Color(0xFF1565C0),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Expira en: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  Helpers.formatTimeRemaining(currentReservation.time.expiresAt),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1565C0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Info message
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Cancela tu reserva actual para poder hacer una nueva',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.orange.shade200 : Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Actions
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context, 'view'),
                            icon: const Icon(Icons.visibility_outlined, size: 18),
                            label: const Text('Ver detalles'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF1565C0),
                              side: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context, 'cancel'),
                            icon: const Icon(Icons.cancel_outlined, size: 18),
                            label: const Text('Cancelar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
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
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'dismiss'),
                      child: Text(
                        'Cerrar',
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
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

    if (!mounted) return;

    if (action == 'view') {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/my-reservation');
    } else if (action == 'cancel') {
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
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
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
                      Expanded(
                        child: Text(
                          '¿Cancelar reserva?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    '¿Estás seguro de que quieres cancelar tu reserva actual? Esta acción no se puede deshacer.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                // Actions
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
        setState(() => _isLoading = true);
        final success = await reservationProvider.cancelReservation(
          currentReservation.reservationId,
          currentReservation.spotId,
        );
        
        if (mounted) {
          setState(() => _isLoading = false);
          if (success) {
            // Recargar los datos para actualizar los contadores
            final parkingProvider = context.read<ParkingProvider>();
            await Future.wait([
              parkingProvider.loadSpotsByZone(currentReservation.zoneId),
              parkingProvider.loadAllSpots(),
            ]);
            
            _showSuccess('Reserva cancelada. Ahora puedes hacer una nueva.');
          } else {
            _showError('No se pudo cancelar la reserva');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 12,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                'Reservar Espacio',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Spot Info Card - Más compacto
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF10B981).withValues(alpha: 0.1),
                      const Color(0xFF10B981).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.spot.type == 'regular'
                            ? Icons.directions_car
                            : Icons.motorcycle,
                        size: 32,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.zoneName,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Espacio ${widget.spot.spotId.replaceAll('${widget.spot.zoneId}_spot_', '')}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.category,
                                size: 14,
                                color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                Helpers.getVehicleTypeText(widget.spot.type),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Duration selector - Más compacto
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Duración de la reserva',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _durationOptions.map((minutes) {
                      final isSelected = minutes == _selectedDuration;
                      return InkWell(
                        onTap: () => setState(() => _selectedDuration = minutes),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                                  )
                                : null,
                            color: isSelected
                                ? null
                                : isDark
                                    ? const Color(0xFF374151)
                                    : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF10B981)
                                  : isDark
                                      ? const Color(0xFF4B5563)
                                      : const Color(0xFFE5E7EB),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            '$minutes min',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : isDark
                                      ? Colors.white70
                                      : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Info - Más compacto
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tienes $_selectedDuration minutos para llegar al espacio',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Buttons - Más modernos
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading 
                          ? null 
                          : () {
                              print('🔵 [MODAL] Botón "Confirmar" presionado');
                              _createReservation();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Confirmar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
