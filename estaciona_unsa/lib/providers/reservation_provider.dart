import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/reservation_model.dart';
import '../models/parking_spot_model.dart';
import '../services/firebase/firestore_service.dart';
import '../utils/logger.dart';

class ReservationProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ReservationModel> _activeReservations = [];
  List<ReservationModel> _reservationHistory = [];
  ReservationModel? _currentReservation;
  
  bool _isLoading = false;
  String? _errorMessage;
  
  // Timer para verificar expiración automática
  Timer? _expirationTimer;

  // Getters
  List<ReservationModel> get activeReservations => _activeReservations;
  List<ReservationModel> get reservationHistory => _reservationHistory;
  ReservationModel? get currentReservation => _currentReservation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Estado
  bool get hasActiveReservation => _activeReservations.isNotEmpty;
  int get activeReservationsCount => _activeReservations.length;

  // ========== CREAR NUEVA RESERVA ==========

  Future<String?> createReservation({
    required String userId,
    required String spotId,
    required String zoneId,
    required int durationMinutes,
    required double latitude,
    required double longitude,
    double? distanceToZone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🔵 [DEBUG] Iniciando createReservation');
      print('🔵 [DEBUG] userId: $userId');
      print('🔵 [DEBUG] spotId: $spotId');
      print('🔵 [DEBUG] zoneId: $zoneId');
      
      // Validar que no tenga reservas activas
      print('🔵 [DEBUG] Verificando reservas activas...');
      final activeReservations = await _firestoreService.getUserActiveReservations(userId);
      print('🔵 [DEBUG] Reservas activas encontradas: ${activeReservations.length}');
      
      if (activeReservations.isNotEmpty) {
        _isLoading = false;
        _errorMessage = 'Ya tienes una reserva activa. Cancélala primero.';
        notifyListeners();
        print('❌ [DEBUG] Usuario ya tiene reserva activa');
        return null;
      }

      // Crear la reserva
      print('🔵 [DEBUG] Creando modelo de reserva...');
      final now = DateTime.now();
      final expiresAt = now.add(Duration(minutes: durationMinutes));

      final reservation = ReservationModel(
        reservationId: '', // Se asigna en Firestore
        userId: userId,
        spotId: spotId,
        zoneId: zoneId,
        time: ReservationTime(
          startedAt: now,
          expiresAt: expiresAt,
          durationMinutes: durationMinutes,
        ),
        status: 'active',
        location: UserLocation(
          latitude: latitude,
          longitude: longitude,
          distanceToZone: distanceToZone,
        ),
        createdAt: now,
        updatedAt: now,
      );

      print('🔵 [DEBUG] Guardando reserva en Firestore...');
      final reservationId = await _firestoreService.createReservation(reservation);
      print('✅ [DEBUG] Reserva creada con ID: $reservationId');

      // Actualizar estado del espacio a "reserved"
      print('🔵 [DEBUG] Actualizando estado del spot a reserved...');
      await _firestoreService.updateSpotStatus(
        spotId,
        'reserved',
        occupancy: CurrentOccupancy(
          userId: userId,
          reservationId: reservationId,
          reservedUntil: expiresAt,
        ),
      );
      print('✅ [DEBUG] Spot actualizado correctamente');

      // Recargar reservas activas
      print('🔵 [DEBUG] Recargando reservas activas...');
      await loadActiveReservations(userId);
      print('✅ [DEBUG] Reservas recargadas');

      _isLoading = false;
      notifyListeners();
      print('✅ [DEBUG] createReservation completado exitosamente');
      return reservationId;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al crear reserva: $e';
      notifyListeners();
      logger.e('Error creating reservation: $e');
      print('❌ [DEBUG] ERROR en createReservation: $e');
      print('❌ [DEBUG] Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  // ========== CARGAR RESERVAS ACTIVAS ==========

  Future<void> loadActiveReservations(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activeReservations = await _firestoreService.getUserActiveReservations(userId);
      
      // Marcar la primera como currentReservation si existe
      if (_activeReservations.isNotEmpty) {
        _currentReservation = _activeReservations.first;
      } else {
        _currentReservation = null;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al cargar reservas activas: $e';
      notifyListeners();
      logger.e('Error loading active reservations: $e');
    }
  }

  // ========== CARGAR HISTORIAL DE RESERVAS ==========

  Future<void> loadReservationHistory(String userId, {int limit = 20}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reservationHistory = await _firestoreService.getUserReservationHistory(userId, limit: limit);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al cargar historial: $e';
      notifyListeners();
      logger.e('Error loading reservation history: $e');
    }
  }

  // ========== CANCELAR RESERVA ==========

  Future<bool> cancelReservation(String reservationId, String spotId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cancelar la reserva en Firestore
      await _firestoreService.cancelReservation(reservationId);

      // Liberar el espacio (volver a "available")
      await _firestoreService.updateSpotStatus(
        spotId,
        'available',
        occupancy: null,
      );

      // Actualizar lista local
      _activeReservations.removeWhere((r) => r.reservationId == reservationId);
      
      if (_currentReservation?.reservationId == reservationId) {
        _currentReservation = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al cancelar reserva: $e';
      notifyListeners();
      logger.e('Error cancelling reservation: $e');
      return false;
    }
  }

  // ========== MARCAR RESERVA COMO USADA ==========

  Future<bool> useReservation(String reservationId, String spotId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Actualizar estado de la reserva a "used"
      await _firestoreService.updateReservationStatus(reservationId, 'used');

      // Actualizar el espacio a "occupied"
      await _firestoreService.updateSpotStatus(
        spotId,
        'occupied',
        occupancy: CurrentOccupancy(
          reservationId: reservationId,
          occupiedSince: DateTime.now(),
        ),
      );

      // Actualizar lista local
      _activeReservations.removeWhere((r) => r.reservationId == reservationId);
      
      if (_currentReservation?.reservationId == reservationId) {
        _currentReservation = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al usar reserva: $e';
      notifyListeners();
      logger.e('Error using reservation: $e');
      return false;
    }
  }

  // ========== MARCAR RESERVA COMO EXPIRADA ==========

  Future<bool> expireReservation(String reservationId, String spotId) async {
    try {
      // Actualizar estado de la reserva a "expired"
      await _firestoreService.updateReservationStatus(reservationId, 'expired');

      // Liberar el espacio
      await _firestoreService.updateSpotStatus(
        spotId,
        'available',
        occupancy: null,
      );

      // Actualizar lista local
      _activeReservations.removeWhere((r) => r.reservationId == reservationId);
      
      if (_currentReservation?.reservationId == reservationId) {
        _currentReservation = null;
      }

      notifyListeners();
      return true;
    } catch (e) {
      logger.e('Error expiring reservation: $e');
      return false;
    }
  }

  // ========== VERIFICAR Y EXPIRAR RESERVAS VENCIDAS ==========

  Future<void> checkAndExpireReservations(String userId) async {
    final now = DateTime.now();
    
    for (var reservation in List.from(_activeReservations)) {
      if (reservation.time.expiresAt.isBefore(now)) {
        await expireReservation(reservation.reservationId, reservation.spotId);
      }
    }
  }

  // ========== STREAM DE RESERVAS ACTIVAS EN TIEMPO REAL ==========

  Stream<List<ReservationModel>> activeReservationsStream(String userId) {
    return _firestoreService.userActiveReservationsStream(userId);
  }

  // ========== OBTENER TIEMPO RESTANTE DE LA RESERVA ACTUAL ==========

  Duration? get currentReservationRemainingTime {
    return _currentReservation?.remainingTime;
  }

  // ========== VERIFICAR SI UNA RESERVA HA EXPIRADO ==========

  bool isReservationExpired(ReservationModel reservation) {
    return reservation.hasExpired;
  }

  // ========== REFRESCAR DATOS ==========

  Future<void> refresh(String userId) async {
    await Future.wait([
      loadActiveReservations(userId),
      loadReservationHistory(userId),
    ]);
  }

  // ========== LIMPIAR ERROR ==========

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ========== VALIDAR SI PUEDE CREAR RESERVA ==========

  Future<Map<String, dynamic>> validateReservation({
    required String userId,
    required String spotId,
  }) async {
    try {
      // Verificar si tiene reservas activas
      final activeReservations = await _firestoreService.getUserActiveReservations(userId);
      if (activeReservations.isNotEmpty) {
        return {
          'canReserve': false,
          'reason': 'Ya tienes una reserva activa',
        };
      }

      // Verificar si el espacio está disponible
      final spot = await _firestoreService.getSpot(spotId);
      if (spot == null) {
        return {
          'canReserve': false,
          'reason': 'El espacio no existe',
        };
      }

      if (!spot.isAvailable) {
        return {
          'canReserve': false,
          'reason': 'El espacio no está disponible',
        };
      }

      return {
        'canReserve': true,
        'reason': null,
      };
    } catch (e) {
      return {
        'canReserve': false,
        'reason': 'Error al validar: $e',
      };
    }
  }

  // ========== OBTENER RESERVA POR ID ==========

  Future<ReservationModel?> getReservation(String reservationId) async {
    try {
      return await _firestoreService.getReservation(reservationId);
    } catch (e) {
      logger.e('Error getting reservation: $e');
      return null;
    }
  }

  // ========== BUSCAR RESERVA EN LISTA LOCAL ==========

  ReservationModel? findReservationById(String reservationId) {
    try {
      return _activeReservations.firstWhere(
        (r) => r.reservationId == reservationId,
      );
    } catch (e) {
      try {
        return _reservationHistory.firstWhere(
          (r) => r.reservationId == reservationId,
        );
      } catch (e) {
        return null;
      }
    }
  }

  // ========== ESTADÍSTICAS ==========

  Map<String, int> getReservationStatistics() {
    return {
      'total': _reservationHistory.length,
      'active': _activeReservations.length,
      'completed': _reservationHistory.where((r) => r.isUsed).length,
      'cancelled': _reservationHistory.where((r) => r.isCancelled).length,
      'expired': _reservationHistory.where((r) => r.isExpired).length,
    };
  }
  
  // ========== EXPIRACIÓN AUTOMÁTICA ==========
  
  /// Inicia un timer que verifica cada 30 segundos si hay reservas expiradas
  void startExpirationChecker(String userId) {
    // Cancelar timer anterior si existe
    _expirationTimer?.cancel();
    
    print('⏰ Iniciando verificador de expiración automática');
    
    // Verificar cada 30 segundos
    _expirationTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      print('⏰ Verificando reservas expiradas...');
      await checkAndExpireReservations(userId);
    });
  }
  
  /// Detiene el timer de verificación de expiración
  void stopExpirationChecker() {
    _expirationTimer?.cancel();
    _expirationTimer = null;
    print('⏰ Verificador de expiración detenido');
  }
  
  @override
  void dispose() {
    stopExpirationChecker();
    super.dispose();
  }
}
