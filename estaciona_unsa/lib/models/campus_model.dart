import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo para representar un campus/sede universitaria
class CampusModel {
  final String campusId;
  final String name;
  final String shortName;
  final String description;
  final LocationInfo location;
  final CampusStats stats;
  final ContactInfo contact;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CampusModel({
    required this.campusId,
    required this.name,
    required this.shortName,
    required this.description,
    required this.location,
    required this.stats,
    required this.contact,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CampusModel.fromMap(Map<String, dynamic> map, String campusId) {
    return CampusModel(
      campusId: campusId,
      name: map['name'] ?? '',
      shortName: map['shortName'] ?? '',
      description: map['description'] ?? '',
      location: LocationInfo.fromMap(map['location'] as Map<String, dynamic>),
      stats: CampusStats.fromMap(map['stats'] as Map<String, dynamic>? ?? {}),
      contact: ContactInfo.fromMap(map['contact'] as Map<String, dynamic>? ?? {}),
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory CampusModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CampusModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'shortName': shortName,
      'description': description,
      'location': location.toMap(),
      'stats': stats.toMap(),
      'contact': contact.toMap(),
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  CampusModel copyWith({
    String? name,
    String? description,
    bool? isActive,
    CampusStats? stats,
  }) {
    return CampusModel(
      campusId: campusId,
      name: name ?? this.name,
      shortName: shortName,
      description: description ?? this.description,
      location: location,
      stats: stats ?? this.stats,
      contact: contact,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() => 'CampusModel(id: $campusId, name: $name)';
}

class LocationInfo {
  final double latitude;
  final double longitude;
  final String address;
  final String? district;
  final String? city;

  LocationInfo({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.district,
    this.city,
  });

  factory LocationInfo.fromMap(Map<String, dynamic> map) {
    return LocationInfo(
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      address: map['address'] ?? '',
      district: map['district'],
      city: map['city'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'district': district,
      'city': city,
    };
  }

  GeoPoint toGeoPoint() => GeoPoint(latitude, longitude);
}

class CampusStats {
  final int totalZones;
  final int totalSpots;
  final int availableSpots;
  final int occupiedSpots;
  final int reservedSpots;
  final DateTime? lastUpdated;

  CampusStats({
    this.totalZones = 0,
    this.totalSpots = 0,
    this.availableSpots = 0,
    this.occupiedSpots = 0,
    this.reservedSpots = 0,
    this.lastUpdated,
  });

  factory CampusStats.fromMap(Map<String, dynamic> map) {
    return CampusStats(
      totalZones: map['totalZones'] ?? 0,
      totalSpots: map['totalSpots'] ?? 0,
      availableSpots: map['availableSpots'] ?? 0,
      occupiedSpots: map['occupiedSpots'] ?? 0,
      reservedSpots: map['reservedSpots'] ?? 0,
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalZones': totalZones,
      'totalSpots': totalSpots,
      'availableSpots': availableSpots,
      'occupiedSpots': occupiedSpots,
      'reservedSpots': reservedSpots,
      'lastUpdated': lastUpdated != null
          ? Timestamp.fromDate(lastUpdated!)
          : FieldValue.serverTimestamp(),
    };
  }

  double get occupancyRate => totalSpots > 0
      ? (occupiedSpots / totalSpots) * 100
      : 0;

  bool get hasAvailableSpots => availableSpots > 0;
}

class ContactInfo {
  final String? phone;
  final String? email;
  final String? securityOffice;

  ContactInfo({
    this.phone,
    this.email,
    this.securityOffice,
  });

  factory ContactInfo.fromMap(Map<String, dynamic> map) {
    return ContactInfo(
      phone: map['phone'],
      email: map['email'],
      securityOffice: map['securityOffice'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email,
      'securityOffice': securityOffice,
    };
  }
}
