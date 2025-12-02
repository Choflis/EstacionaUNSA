import 'package:flutter/foundation.dart';
import '../models/parking_zone_model.dart';
import '../models/parking_spot_model.dart';
import '../services/firebase/firestore_service.dart';
import '../utils/logger.dart';

class ParkingProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ParkingZoneModel> _zones = [];
  List<ParkingSpotModel> _spots = []; // TODOS los spots de TODAS las zonas
  List<ParkingSpotModel> _currentZoneSpots = []; // Solo los spots de la zona actual
  ParkingZoneModel? _selectedZone;
  ParkingSpotModel? _selectedSpot;
  
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ParkingZoneModel> get zones => _zones;
  List<ParkingSpotModel> get spots => _currentZoneSpots; // Devuelve los de la zona actual
  List<ParkingSpotModel> get allSpots => _spots; // Nuevo getter para todos los spots
  ParkingZoneModel? get selectedZone => _selectedZone;
  ParkingSpotModel? get selectedSpot => _selectedSpot;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filtrados (usan _currentZoneSpots para la zona actual)
  List<ParkingSpotModel> get availableSpots =>
      _currentZoneSpots.where((spot) => spot.isAvailable).toList();

  List<ParkingSpotModel> get occupiedSpots =>
      _currentZoneSpots.where((spot) => spot.isOccupied).toList();

  List<ParkingSpotModel> get reservedSpots =>
      _currentZoneSpots.where((spot) => spot.isReserved).toList();

  int get totalSpots => _currentZoneSpots.length;
  int get availableSpotsCount => availableSpots.length;
  int get occupiedSpotsCount => occupiedSpots.length;
  int get reservedSpotsCount => reservedSpots.length;

  // ========== CARGAR TODAS LAS ZONAS ==========

  Future<void> loadZones() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _zones = await _firestoreService.getAllZones();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al cargar zonas: $e';
      notifyListeners();
      logger.e('Error loading zones: $e');
    }
  }

  // ========== CARGAR ESPACIOS POR ZONA ==========

  Future<void> loadSpotsByZone(String zoneId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final zoneSpots = await _firestoreService.getSpotsByZone(zoneId);
      _currentZoneSpots = zoneSpots;
      
      // Actualizar también en _spots (todos los spots)
      // Remover los spots viejos de esta zona y agregar los nuevos
      _spots.removeWhere((spot) => spot.zoneId == zoneId);
      _spots.addAll(zoneSpots);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al cargar espacios: $e';
      notifyListeners();
      logger.e('Error loading spots: $e');
    }
  }

  // ========== CARGAR TODOS LOS ESPACIOS ==========

  Future<void> loadAllSpots() async {
    try {
      _spots = await _firestoreService.getAllSpots();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar todos los espacios: $e';
      notifyListeners();
      logger.e('Error loading all spots: $e');
    }
  }

  // ========== CARGAR SOLO ESPACIOS DISPONIBLES ==========

  Future<void> loadAvailableSpotsByZone(String zoneId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentZoneSpots = await _firestoreService.getAvailableSpots(zoneId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al cargar espacios disponibles: $e';
      notifyListeners();
      logger.e('Error loading available spots: $e');
    }
  }

  // ========== SELECCIONAR ZONA ==========

  Future<void> selectZone(String zoneId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedZone = await _firestoreService.getZone(zoneId);
      await loadSpotsByZone(zoneId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al seleccionar zona: $e';
      notifyListeners();
      logger.e('Error selecting zone: $e');
    }
  }

  // ========== SELECCIONAR ESPACIO ==========

  void selectSpot(ParkingSpotModel spot) {
    _selectedSpot = spot;
    notifyListeners();
  }

  // ========== DESELECCIONAR ESPACIO ==========

  void clearSelectedSpot() {
    _selectedSpot = null;
    notifyListeners();
  }

  // ========== ACTUALIZAR ESTADO DE UN ESPACIO ==========

  Future<void> updateSpotStatus(
    String spotId,
    String status, {
    CurrentOccupancy? occupancy,
  }) async {
    try {
      await _firestoreService.updateSpotStatus(spotId, status, occupancy: occupancy);
      
      // Actualizar localmente
      final index = _spots.indexWhere((spot) => spot.spotId == spotId);
      if (index != -1) {
        _spots[index] = _spots[index].copyWith(
          status: status,
          currentOccupancy: occupancy,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar espacio: $e';
      notifyListeners();
      logger.e('Error updating spot status: $e');
      rethrow;
    }
  }

  // ========== ESCUCHAR CAMBIOS EN TIEMPO REAL (ZONA ESPECÍFICA) ==========

  Stream<List<ParkingSpotModel>> spotsStreamByZone(String zoneId) {
    return _firestoreService.spotsStreamByZone(zoneId);
  }

  // ========== ESCUCHAR CAMBIOS EN TIEMPO REAL (TODAS LAS ZONAS) ==========

  Stream<List<ParkingZoneModel>> zonesStream() {
    return _firestoreService.zonesStream();
  }

  // ========== REFRESCAR DATOS ==========

  Future<void> refresh() async {
    await loadZones();
    if (_selectedZone != null) {
      await selectZone(_selectedZone!.zoneId);
    }
  }

  // ========== LIMPIAR ERROR ==========

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ========== OBTENER ESTADÍSTICAS DE UNA ZONA ==========

  Map<String, int> getZoneStatistics(String zoneId) {
    final zoneSpots = _spots.where((spot) => spot.zoneId == zoneId).toList();
    
    return {
      'total': zoneSpots.length,
      'available': zoneSpots.where((s) => s.isAvailable).length,
      'occupied': zoneSpots.where((s) => s.isOccupied).length,
      'reserved': zoneSpots.where((s) => s.isReserved).length,
      'maintenance': zoneSpots.where((s) => s.isInMaintenance).length,
    };
  }

  // ========== FILTRAR ESPACIOS POR TIPO ==========

  List<ParkingSpotModel> getSpotsByType(String type) {
    return _spots.where((spot) => spot.type == type).toList();
  }

  // ========== BUSCAR ESPACIO POR ID ==========

  ParkingSpotModel? findSpotById(String spotId) {
    try {
      return _spots.firstWhere((spot) => spot.spotId == spotId);
    } catch (e) {
      return null;
    }
  }

  // ========== BUSCAR ZONA POR ID ==========

  ParkingZoneModel? findZoneById(String zoneId) {
    try {
      return _zones.firstWhere((zone) => zone.zoneId == zoneId);
    } catch (e) {
      return null;
    }
  }
}
