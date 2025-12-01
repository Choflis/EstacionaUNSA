import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../models/parking_zone_model.dart';
import '../../models/parking_spot_model.dart';
import '../../models/reservation_model.dart';
import '../../models/entry_exit_log_model.dart';
import '../../models/incident_model.dart';
import '../../utils/logger.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== USERS ==========
  
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromDocument(doc);
    } catch (e) {
      logger.e('Error getting user: $e');
      rethrow;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      logger.e('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      logger.e('Error updating user: $e');
      rethrow;
    }
  }

  Stream<UserModel?> userStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromDocument(doc) : null);
  }

  // ========== PARKING ZONES ==========

  Future<List<ParkingZoneModel>> getAllZones() async {
    try {
      final snapshot = await _firestore
          .collection('parking_zones')
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs.map((doc) => ParkingZoneModel.fromDocument(doc)).toList();
    } catch (e) {
      logger.e('Error getting zones: $e');
      rethrow;
    }
  }

  Future<ParkingZoneModel?> getZone(String zoneId) async {
    try {
      final doc = await _firestore.collection('parking_zones').doc(zoneId).get();
      if (!doc.exists) return null;
      return ParkingZoneModel.fromDocument(doc);
    } catch (e) {
      logger.e('Error getting zone: $e');
      rethrow;
    }
  }

  Stream<List<ParkingZoneModel>> zonesStream() {
    return _firestore
        .collection('parking_zones')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => ParkingZoneModel.fromDocument(doc)).toList());
  }

  Future<void> updateZoneCapacity(String zoneId, ZoneCapacity capacity) async {
    try {
      await _firestore.collection('parking_zones').doc(zoneId).update({
        'capacity': capacity.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      logger.e('Error updating zone capacity: $e');
      rethrow;
    }
  }

  // ========== PARKING SPOTS ==========

  Future<List<ParkingSpotModel>> getAvailableSpots(String zoneId) async {
    try {
      final snapshot = await _firestore
          .collection('parking_spots')
          .where('zoneId', isEqualTo: zoneId)
          .where('status', isEqualTo: 'available')
          .get();
      return snapshot.docs.map((doc) => ParkingSpotModel.fromDocument(doc)).toList();
    } catch (e) {
      logger.e('Error getting available spots: $e');
      rethrow;
    }
  }

  Future<List<ParkingSpotModel>> getSpotsByZone(String zoneId) async {
    try {
      final snapshot = await _firestore
          .collection('parking_spots')
          .where('zoneId', isEqualTo: zoneId)
          .get();
      return snapshot.docs.map((doc) => ParkingSpotModel.fromDocument(doc)).toList();
    } catch (e) {
      logger.e('Error getting spots by zone: $e');
      rethrow;
    }
  }

  Future<ParkingSpotModel?> getSpot(String spotId) async {
    try {
      final doc = await _firestore.collection('parking_spots').doc(spotId).get();
      if (!doc.exists) return null;
      return ParkingSpotModel.fromDocument(doc);
    } catch (e) {
      logger.e('Error getting spot: $e');
      rethrow;
    }
  }

  Stream<List<ParkingSpotModel>> spotsStreamByZone(String zoneId) {
    return _firestore
        .collection('parking_spots')
        .where('zoneId', isEqualTo: zoneId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ParkingSpotModel.fromDocument(doc)).toList());
  }

  Future<void> updateSpotStatus(String spotId, String status, {CurrentOccupancy? occupancy}) async {
    try {
      await _firestore.collection('parking_spots').doc(spotId).update({
        'status': status,
        if (occupancy != null) 'currentOccupancy': occupancy.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      logger.e('Error updating spot status: $e');
      rethrow;
    }
  }

  // ========== RESERVATIONS ==========

  Future<String> createReservation(ReservationModel reservation) async {
    try {
      final docRef = await _firestore.collection('reservations').add(reservation.toMap());
      return docRef.id;
    } catch (e) {
      logger.e('Error creating reservation: $e');
      rethrow;
    }
  }

  Future<ReservationModel?> getReservation(String reservationId) async {
    try {
      final doc = await _firestore.collection('reservations').doc(reservationId).get();
      if (!doc.exists) return null;
      return ReservationModel.fromDocument(doc);
    } catch (e) {
      logger.e('Error getting reservation: $e');
      rethrow;
    }
  }

  Future<List<ReservationModel>> getUserActiveReservations(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .get();
      return snapshot.docs.map((doc) => ReservationModel.fromDocument(doc)).toList();
    } catch (e) {
      logger.e('Error getting active reservations: $e');
      rethrow;
    }
  }

  Future<List<ReservationModel>> getUserReservationHistory(String userId, {int limit = 20}) async {
    try {
      final snapshot = await _firestore
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs.map((doc) => ReservationModel.fromDocument(doc)).toList();
    } catch (e) {
      logger.e('Error getting reservation history: $e');
      rethrow;
    }
  }

  Stream<List<ReservationModel>> userActiveReservationsStream(String userId) {
    return _firestore
        .collection('reservations')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ReservationModel.fromDocument(doc)).toList());
  }

  Future<void> updateReservationStatus(String reservationId, String status) async {
    try {
      await _firestore.collection('reservations').doc(reservationId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      logger.e('Error updating reservation status: $e');
      rethrow;
    }
  }

  Future<void> cancelReservation(String reservationId) async {
    try {
      await updateReservationStatus(reservationId, 'cancelled');
    } catch (e) {
      logger.e('Error cancelling reservation: $e');
      rethrow;
    }
  }

  // ========== ENTRY/EXIT LOGS ==========

  Future<String> createEntryLog(EntryExitLogModel log) async {
    try {
      final docRef = await _firestore.collection('entry_exit_logs').add(log.toMap());
      return docRef.id;
    } catch (e) {
      logger.e('Error creating entry log: $e');
      rethrow;
    }
  }

  Future<List<EntryExitLogModel>> getLogsByUser(String userId, {int limit = 20}) async {
    try {
      final snapshot = await _firestore
          .collection('entry_exit_logs')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs.map((doc) => EntryExitLogModel.fromDocument(doc)).toList();
    } catch (e) {
      logger.e('Error getting logs by user: $e');
      rethrow;
    }
  }

  Future<List<EntryExitLogModel>> getLogsBySpot(String spotId, {int limit = 20}) async {
    try {
      final snapshot = await _firestore
          .collection('entry_exit_logs')
          .where('spotId', isEqualTo: spotId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs.map((doc) => EntryExitLogModel.fromDocument(doc)).toList();
    } catch (e) {
      logger.e('Error getting logs by spot: $e');
      rethrow;
    }
  }

  // ========== INCIDENTS ==========

  Future<String> createIncident(IncidentModel incident) async {
    try {
      final docRef = await _firestore.collection('incidents').add(incident.toMap());
      return docRef.id;
    } catch (e) {
      logger.e('Error creating incident: $e');
      rethrow;
    }
  }

  Future<List<IncidentModel>> getPendingIncidents() async {
    try {
      final snapshot = await _firestore
          .collection('incidents')
          .where('status', isEqualTo: 'pending')
          .orderBy('reportedAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => IncidentModel.fromDocument(doc)).toList();
    } catch (e) {
      logger.e('Error getting pending incidents: $e');
      rethrow;
    }
  }

  Future<List<IncidentModel>> getUserIncidents(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('incidents')
          .where('userId', isEqualTo: userId)
          .orderBy('reportedAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => IncidentModel.fromDocument(doc)).toList();
    } catch (e) {
      logger.e('Error getting user incidents: $e');
      rethrow;
    }
  }

  Future<void> updateIncident(String incidentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('incidents').doc(incidentId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      logger.e('Error updating incident: $e');
      rethrow;
    }
  }

  Stream<List<IncidentModel>> pendingIncidentsStream() {
    return _firestore
        .collection('incidents')
        .where('status', isEqualTo: 'pending')
        .orderBy('reportedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => IncidentModel.fromDocument(doc)).toList());
  }

  // ========== HELPER METHODS ==========

  Future<bool> hasActiveReservation(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      logger.e('Error checking active reservation: $e');
      return false;
    }
  }

  Future<int> getAvailableSpotsCount(String zoneId) async {
    try {
      final snapshot = await _firestore
          .collection('parking_spots')
          .where('zoneId', isEqualTo: zoneId)
          .where('status', isEqualTo: 'available')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      logger.e('Error getting available spots count: $e');
      return 0;
    }
  }

  // Transaction: Reserve spot (atomic operation)
  Future<void> reserveSpotTransaction(String spotId, String userId, String reservationId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final spotRef = _firestore.collection('parking_spots').doc(spotId);
        final spotDoc = await transaction.get(spotRef);

        if (!spotDoc.exists) {
          throw Exception('Spot not found');
        }

        final spot = ParkingSpotModel.fromDocument(spotDoc);
        if (spot.status != 'available') {
          throw Exception('Spot is not available');
        }

        transaction.update(spotRef, {
          'status': 'reserved',
          'currentOccupancy': {
            'userId': userId,
            'reservationId': reservationId,
            'reservedUntil': Timestamp.fromDate(DateTime.now().add(Duration(minutes: 15))),
          },
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      logger.e('Error in reserve transaction: $e');
      rethrow;
    }
  }

  // Transaction: Release spot
  Future<void> releaseSpotTransaction(String spotId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final spotRef = _firestore.collection('parking_spots').doc(spotId);
        transaction.update(spotRef, {
          'status': 'available',
          'currentOccupancy': null,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      logger.e('Error in release transaction: $e');
      rethrow;
    }
  }
}
