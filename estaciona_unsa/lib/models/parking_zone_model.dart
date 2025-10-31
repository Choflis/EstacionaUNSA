import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingZoneModel {
  final String zoneId;
  final String name;
  final LocationInfo location;
  final ZoneCapacity capacity;
  final Map<String, DaySchedule> schedule;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ParkingZoneModel({
    required this.zoneId,
    required this.name,
    required this.location,
    required this.capacity,
    required this.schedule,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParkingZoneModel.fromMap(Map<String, dynamic> map, String zoneId) {
    return ParkingZoneModel(
      zoneId: zoneId,
      name: map['name'] ?? '',
      location: LocationInfo.fromMap(map['location'] as Map<String, dynamic>),
      capacity: ZoneCapacity.fromMap(map['capacity'] as Map<String, dynamic>),
      schedule: (map['schedule'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, DaySchedule.fromMap(value as Map<String, dynamic>)),
          ) ??
          {},
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory ParkingZoneModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ParkingZoneModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location.toMap(),
      'capacity': capacity.toMap(),
      'schedule': schedule.map((key, value) => MapEntry(key, value.toMap())),
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  bool get hasAvailableSpots => capacity.availableSpots > 0;
  double get occupancyRate => capacity.totalSpots > 0 
      ? (capacity.occupiedSpots / capacity.totalSpots) * 100 
      : 0;

  @override
  String toString() => 'ParkingZoneModel(id: $zoneId, name: $name)';
}

class LocationInfo {
  final double latitude;
  final double longitude;
  final String address;
  final String? building;
  final String? floor;

  LocationInfo({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.building,
    this.floor,
  });

  factory LocationInfo.fromMap(Map<String, dynamic> map) {
    return LocationInfo(
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      address: map['address'] ?? '',
      building: map['building'],
      floor: map['floor'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'building': building,
      'floor': floor,
    };
  }

  GeoPoint toGeoPoint() => GeoPoint(latitude, longitude);
}

class ZoneCapacity {
  final int totalSpots;
  final int availableSpots;
  final int occupiedSpots;
  final int reservedSpots;
  final int maintenanceSpots;

  ZoneCapacity({
    required this.totalSpots,
    required this.availableSpots,
    required this.occupiedSpots,
    required this.reservedSpots,
    this.maintenanceSpots = 0,
  });

  factory ZoneCapacity.fromMap(Map<String, dynamic> map) {
    return ZoneCapacity(
      totalSpots: map['totalSpots'] ?? 0,
      availableSpots: map['availableSpots'] ?? 0,
      occupiedSpots: map['occupiedSpots'] ?? 0,
      reservedSpots: map['reservedSpots'] ?? 0,
      maintenanceSpots: map['maintenanceSpots'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalSpots': totalSpots,
      'availableSpots': availableSpots,
      'occupiedSpots': occupiedSpots,
      'reservedSpots': reservedSpots,
      'maintenanceSpots': maintenanceSpots,
    };
  }
}

class DaySchedule {
  final bool isOpen;
  final String? openTime;
  final String? closeTime;

  DaySchedule({
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  factory DaySchedule.fromMap(Map<String, dynamic> map) {
    return DaySchedule(
      isOpen: map['isOpen'] ?? false,
      openTime: map['openTime'],
      closeTime: map['closeTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isOpen': isOpen,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}
