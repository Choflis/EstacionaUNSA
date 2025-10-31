import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String role; // "user", "guard", "admin"
  final List<VehicleInfo> vehicles;
  final UserStats stats;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? phoneNumber;
  final String? photoURL;
  final bool isActive;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.vehicles = const [],
    required this.stats,
    required this.createdAt,
    required this.updatedAt,
    this.phoneNumber,
    this.photoURL,
    this.isActive = true,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      role: map['role'] ?? 'user',
      vehicles: (map['vehicles'] as List?)
              ?.map((v) => VehicleInfo.fromMap(v as Map<String, dynamic>))
              .toList() ??
          [],
      stats: UserStats.fromMap(map['stats'] as Map<String, dynamic>? ?? {}),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      phoneNumber: map['phoneNumber'],
      photoURL: map['photoURL'],
      isActive: map['isActive'] ?? true,
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role,
      'vehicles': vehicles.map((v) => v.toMap()).toList(),
      'stats': stats.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'isActive': isActive,
    };
  }

  UserModel copyWith({
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    List<VehicleInfo>? vehicles,
    UserStats? stats,
    bool? isActive,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      role: role,
      vehicles: vehicles ?? this.vehicles,
      stats: stats ?? this.stats,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get hasVehicle => vehicles.isNotEmpty;
  VehicleInfo? get primaryVehicle =>
      vehicles.isEmpty ? null : vehicles.firstWhere((v) => v.isPrimary, orElse: () => vehicles.first);

  @override
  String toString() => 'UserModel(uid: $uid, name: $displayName, role: $role)';
}

class VehicleInfo {
  final String licensePlate;
  final String? brand;
  final String? model;
  final String? color;
  final bool isPrimary;

  VehicleInfo({
    required this.licensePlate,
    this.brand,
    this.model,
    this.color,
    this.isPrimary = false,
  });

  factory VehicleInfo.fromMap(Map<String, dynamic> map) {
    return VehicleInfo(
      licensePlate: map['licensePlate'] ?? '',
      brand: map['brand'],
      model: map['model'],
      color: map['color'],
      isPrimary: map['isPrimary'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'licensePlate': licensePlate,
      'brand': brand,
      'model': model,
      'color': color,
      'isPrimary': isPrimary,
    };
  }
}

class UserStats {
  final int totalReservations;
  final int completedReservations;
  final int cancelledReservations;
  final int noShowCount;
  final DateTime? lastReservation;
  final DateTime? suspensionUntil;
  final bool isBanned;

  UserStats({
    this.totalReservations = 0,
    this.completedReservations = 0,
    this.cancelledReservations = 0,
    this.noShowCount = 0,
    this.lastReservation,
    this.suspensionUntil,
    this.isBanned = false,
  });

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      totalReservations: map['totalReservations'] ?? 0,
      completedReservations: map['completedReservations'] ?? 0,
      cancelledReservations: map['cancelledReservations'] ?? 0,
      noShowCount: map['noShowCount'] ?? 0,
      lastReservation: map['lastReservation'] != null
          ? (map['lastReservation'] as Timestamp).toDate()
          : null,
      suspensionUntil: map['suspensionUntil'] != null
          ? (map['suspensionUntil'] as Timestamp).toDate()
          : null,
      isBanned: map['isBanned'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalReservations': totalReservations,
      'completedReservations': completedReservations,
      'cancelledReservations': cancelledReservations,
      'noShowCount': noShowCount,
      'lastReservation': lastReservation != null
          ? Timestamp.fromDate(lastReservation!)
          : null,
      'suspensionUntil': suspensionUntil != null
          ? Timestamp.fromDate(suspensionUntil!)
          : null,
      'isBanned': isBanned,
    };
  }

  bool get isSuspended => suspensionUntil != null && suspensionUntil!.isAfter(DateTime.now());
  bool get canReserve => !isBanned && !isSuspended;
}
