import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSpotModel {
  final String spotId;
  final String zoneId;
  final String status; // "available", "occupied", "reserved", "maintenance"
  final String type; // "regular", "motorcycle"
  final CurrentOccupancy? currentOccupancy;
  final DateTime updatedAt;

  ParkingSpotModel({
    required this.spotId,
    required this.zoneId,
    required this.status,
    this.type = 'regular',
    this.currentOccupancy,
    required this.updatedAt,
  });

  factory ParkingSpotModel.fromMap(Map<String, dynamic> map, String spotId) {
    return ParkingSpotModel(
      spotId: spotId,
      zoneId: map['zoneId'] ?? '',
      status: map['status'] ?? 'available',
      type: map['type'] ?? 'regular',
      currentOccupancy: map['currentOccupancy'] != null
          ? CurrentOccupancy.fromMap(map['currentOccupancy'] as Map<String, dynamic>)
          : null,
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory ParkingSpotModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ParkingSpotModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'zoneId': zoneId,
      'status': status,
      'type': type,
      'currentOccupancy': currentOccupancy?.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  bool get isAvailable => status == 'available';
  bool get isOccupied => status == 'occupied';
  bool get isReserved => status == 'reserved';
  bool get isInMaintenance => status == 'maintenance';

  ParkingSpotModel copyWith({
    String? status,
    CurrentOccupancy? currentOccupancy,
  }) {
    return ParkingSpotModel(
      spotId: spotId,
      zoneId: zoneId,
      status: status ?? this.status,
      type: type,
      currentOccupancy: currentOccupancy ?? this.currentOccupancy,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() => 'ParkingSpot(id: $spotId, status: $status)';
}

class CurrentOccupancy {
  final String? userId;
  final String? reservationId;
  final String? entryLogId;
  final DateTime? occupiedSince;
  final DateTime? reservedUntil;

  CurrentOccupancy({
    this.userId,
    this.reservationId,
    this.entryLogId,
    this.occupiedSince,
    this.reservedUntil,
  });

  factory CurrentOccupancy.fromMap(Map<String, dynamic> map) {
    return CurrentOccupancy(
      userId: map['userId'],
      reservationId: map['reservationId'],
      entryLogId: map['entryLogId'],
      occupiedSince: map['occupiedSince'] != null
          ? (map['occupiedSince'] as Timestamp).toDate()
          : null,
      reservedUntil: map['reservedUntil'] != null
          ? (map['reservedUntil'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'reservationId': reservationId,
      'entryLogId': entryLogId,
      'occupiedSince': occupiedSince != null
          ? Timestamp.fromDate(occupiedSince!)
          : null,
      'reservedUntil': reservedUntil != null
          ? Timestamp.fromDate(reservedUntil!)
          : null,
    };
  }
}
