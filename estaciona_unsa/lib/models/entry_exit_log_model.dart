import 'package:cloud_firestore/cloud_firestore.dart';

class EntryExitLogModel {
  final String logId;
  final String type; // "entry" or "exit"
  final String userId;
  final String guardId;
  final String spotId;
  final String zoneId;
  final VehicleData vehicle;
  final DateTime? entryTime;
  final DateTime? exitTime;
  final String? reservationId;
  final String? notes;
  final DateTime createdAt;

  EntryExitLogModel({
    required this.logId,
    required this.type,
    required this.userId,
    required this.guardId,
    required this.spotId,
    required this.zoneId,
    required this.vehicle,
    this.entryTime,
    this.exitTime,
    this.reservationId,
    this.notes,
    required this.createdAt,
  });

  factory EntryExitLogModel.fromMap(Map<String, dynamic> map, String logId) {
    return EntryExitLogModel(
      logId: logId,
      type: map['type'] ?? 'entry',
      userId: map['userId'] ?? '',
      guardId: map['guardId'] ?? '',
      spotId: map['spotId'] ?? '',
      zoneId: map['zoneId'] ?? '',
      vehicle: VehicleData.fromMap(map['vehicle'] as Map<String, dynamic>),
      entryTime: map['entryTime'] != null
          ? (map['entryTime'] as Timestamp).toDate()
          : null,
      exitTime: map['exitTime'] != null
          ? (map['exitTime'] as Timestamp).toDate()
          : null,
      reservationId: map['reservationId'],
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  factory EntryExitLogModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EntryExitLogModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'userId': userId,
      'guardId': guardId,
      'spotId': spotId,
      'zoneId': zoneId,
      'vehicle': vehicle.toMap(),
      'entryTime': entryTime != null ? Timestamp.fromDate(entryTime!) : null,
      'exitTime': exitTime != null ? Timestamp.fromDate(exitTime!) : null,
      'reservationId': reservationId,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  bool get isEntry => type == 'entry';
  bool get isExit => type == 'exit';

  Duration? get parkingDuration {
    if (entryTime == null || exitTime == null) return null;
    return exitTime!.difference(entryTime!);
  }

  @override
  String toString() => 'EntryExitLog(id: $logId, type: $type, spot: $spotId)';
}

class VehicleData {
  final String licensePlate;
  final String? brand;
  final String? model;
  final String? color;

  VehicleData({
    required this.licensePlate,
    this.brand,
    this.model,
    this.color,
  });

  factory VehicleData.fromMap(Map<String, dynamic> map) {
    return VehicleData(
      licensePlate: map['licensePlate'] ?? '',
      brand: map['brand'],
      model: map['model'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'licensePlate': licensePlate,
      'brand': brand,
      'model': model,
      'color': color,
    };
  }
}
