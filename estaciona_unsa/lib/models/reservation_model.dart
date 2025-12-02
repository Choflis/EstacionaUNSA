import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String reservationId;
  final String userId;
  final String spotId;
  final String zoneId;
  final ReservationTime time;
  final String status; // "active", "used", "completed", "expired", "cancelled"
  final UserLocation location;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReservationModel({
    required this.reservationId,
    required this.userId,
    required this.spotId,
    required this.zoneId,
    required this.time,
    required this.status,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReservationModel.fromMap(Map<String, dynamic> map, String reservationId) {
    return ReservationModel(
      reservationId: reservationId,
      userId: map['userId'] ?? '',
      spotId: map['spotId'] ?? '',
      zoneId: map['zoneId'] ?? '',
      time: ReservationTime.fromMap(map['time'] as Map<String, dynamic>),
      status: map['status'] ?? 'active',
      location: UserLocation.fromMap(map['location'] as Map<String, dynamic>),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory ReservationModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReservationModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'spotId': spotId,
      'zoneId': zoneId,
      'time': time.toMap(),
      'status': status,
      'location': location.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  bool get isActive => status == 'active';
  bool get isExpired => status == 'expired';
  bool get isUsed => status == 'used';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';

  Duration? get remainingTime {
    if (!isActive) return null;
    final now = DateTime.now();
    if (now.isAfter(time.expiresAt)) return Duration.zero;
    return time.expiresAt.difference(now);
  }

  bool get hasExpired => time.expiresAt.isBefore(DateTime.now());

  ReservationModel copyWith({
    String? status,
    ReservationTime? time,
  }) {
    return ReservationModel(
      reservationId: reservationId,
      userId: userId,
      spotId: spotId,
      zoneId: zoneId,
      time: time ?? this.time,
      status: status ?? this.status,
      location: location,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() => 'Reservation(id: $reservationId, spot: $spotId, status: $status)';
}

class ReservationTime {
  final DateTime startedAt;
  final DateTime expiresAt;
  final int durationMinutes;

  ReservationTime({
    required this.startedAt,
    required this.expiresAt,
    required this.durationMinutes,
  });

  factory ReservationTime.fromMap(Map<String, dynamic> map) {
    return ReservationTime(
      startedAt: (map['startedAt'] as Timestamp).toDate(),
      expiresAt: (map['expiresAt'] as Timestamp).toDate(),
      durationMinutes: map['durationMinutes'] ?? 15,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startedAt': Timestamp.fromDate(startedAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'durationMinutes': durationMinutes,
    };
  }
}

class UserLocation {
  final double latitude;
  final double longitude;
  final double? distanceToZone;

  UserLocation({
    required this.latitude,
    required this.longitude,
    this.distanceToZone,
  });

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      distanceToZone: map['distanceToZone']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'distanceToZone': distanceToZone,
    };
  }

  GeoPoint toGeoPoint() => GeoPoint(latitude, longitude);
}
