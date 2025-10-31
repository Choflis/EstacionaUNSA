import 'package:cloud_firestore/cloud_firestore.dart';

class IncidentModel {
  final String incidentId;
  final String type; // "no_show", "late_arrival", "unauthorized_parking", "damage", "other"
  final String severity; // "low", "medium", "high"
  final String userId;
  final String reportedBy; // userId (guard/admin/system)
  final String? spotId;
  final String? zoneId;
  final String? reservationId;
  final String description;
  final String status; // "pending", "reviewed", "resolved", "dismissed"
  final List<String>? evidenceUrls;
  final DateTime reportedAt;
  final DateTime? resolvedAt;
  final String? resolution;
  final String? resolvedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  IncidentModel({
    required this.incidentId,
    required this.type,
    required this.severity,
    required this.userId,
    required this.reportedBy,
    this.spotId,
    this.zoneId,
    this.reservationId,
    required this.description,
    this.status = 'pending',
    this.evidenceUrls,
    required this.reportedAt,
    this.resolvedAt,
    this.resolution,
    this.resolvedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IncidentModel.fromMap(Map<String, dynamic> map, String incidentId) {
    return IncidentModel(
      incidentId: incidentId,
      type: map['type'] ?? 'other',
      severity: map['severity'] ?? 'medium',
      userId: map['userId'] ?? '',
      reportedBy: map['reportedBy'] ?? '',
      spotId: map['spotId'],
      zoneId: map['zoneId'],
      reservationId: map['reservationId'],
      description: map['description'] ?? '',
      status: map['status'] ?? 'pending',
      evidenceUrls: map['evidenceUrls'] != null
          ? List<String>.from(map['evidenceUrls'])
          : null,
      reportedAt: (map['reportedAt'] as Timestamp).toDate(),
      resolvedAt: map['resolvedAt'] != null
          ? (map['resolvedAt'] as Timestamp).toDate()
          : null,
      resolution: map['resolution'],
      resolvedBy: map['resolvedBy'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory IncidentModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IncidentModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'severity': severity,
      'userId': userId,
      'reportedBy': reportedBy,
      'spotId': spotId,
      'zoneId': zoneId,
      'reservationId': reservationId,
      'description': description,
      'status': status,
      'evidenceUrls': evidenceUrls,
      'reportedAt': Timestamp.fromDate(reportedAt),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'resolution': resolution,
      'resolvedBy': resolvedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isResolved => status == 'resolved';
  bool get isReviewed => status == 'reviewed';
  bool get isDismissed => status == 'dismissed';

  bool get isHighPriority => severity == 'high';
  bool get hasEvidence => evidenceUrls != null && evidenceUrls!.isNotEmpty;

  IncidentModel copyWith({
    String? status,
    String? resolution,
    String? resolvedBy,
    DateTime? resolvedAt,
  }) {
    return IncidentModel(
      incidentId: incidentId,
      type: type,
      severity: severity,
      userId: userId,
      reportedBy: reportedBy,
      spotId: spotId,
      zoneId: zoneId,
      reservationId: reservationId,
      description: description,
      status: status ?? this.status,
      evidenceUrls: evidenceUrls,
      reportedAt: reportedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolution: resolution ?? this.resolution,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() => 'Incident(id: $incidentId, type: $type, status: $status)';
}
