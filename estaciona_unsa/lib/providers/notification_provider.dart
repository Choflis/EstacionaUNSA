import 'package:flutter/foundation.dart';

/// Provider para gestionar el estado de las notificaciones
/// Este provider maneja notificaciones in-app y se puede extender
/// con Firebase Cloud Messaging para notificaciones push
class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  List<AppNotification> _unreadNotifications = [];
  
  bool _isLoading = false;
  String? _errorMessage;

  // Configuración de notificaciones
  bool _pushNotificationsEnabled = true;
  bool _reservationRemindersEnabled = true;
  bool _expirationAlertsEnabled = true;
  bool _availabilityAlertsEnabled = false;

  // Getters
  List<AppNotification> get notifications => _notifications;
  List<AppNotification> get unreadNotifications => _unreadNotifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Configuración
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get reservationRemindersEnabled => _reservationRemindersEnabled;
  bool get expirationAlertsEnabled => _expirationAlertsEnabled;
  bool get availabilityAlertsEnabled => _availabilityAlertsEnabled;

  // Contadores
  int get unreadCount => _unreadNotifications.length;
  int get totalCount => _notifications.length;
  bool get hasUnread => _unreadNotifications.isNotEmpty;

  // ========== AGREGAR NOTIFICACIÓN ==========

  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
      data: data,
    );

    _notifications.insert(0, notification);
    _unreadNotifications.insert(0, notification);
    notifyListeners();
  }

  // ========== MARCAR COMO LEÍDA ==========

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _unreadNotifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
    }
  }

  // ========== MARCAR TODAS COMO LEÍDAS ==========

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _unreadNotifications.clear();
    notifyListeners();
  }

  // ========== ELIMINAR NOTIFICACIÓN ==========

  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _unreadNotifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  // ========== LIMPIAR TODAS LAS NOTIFICACIONES ==========

  void clearAll() {
    _notifications.clear();
    _unreadNotifications.clear();
    notifyListeners();
  }

  // ========== LIMPIAR NOTIFICACIONES LEÍDAS ==========

  void clearReadNotifications() {
    _notifications.removeWhere((n) => n.isRead);
    notifyListeners();
  }

  // ========== NOTIFICACIONES ESPECÍFICAS ==========

  // Notificación de reserva confirmada
  void notifyReservationConfirmed({
    required String spotId,
    required String zoneName,
    required DateTime expiresAt,
  }) {
    if (!_reservationRemindersEnabled) return;

    addNotification(
      title: '✅ Reserva confirmada',
      message: 'Espacio $spotId en $zoneName reservado hasta ${_formatTime(expiresAt)}',
      type: NotificationType.reservationConfirmed,
      data: {
        'spotId': spotId,
        'zoneName': zoneName,
        'expiresAt': expiresAt.toIso8601String(),
      },
    );
  }

  // Notificación de reserva por expirar
  void notifyReservationExpiring({
    required String spotId,
    required int minutesLeft,
  }) {
    if (!_expirationAlertsEnabled) return;

    addNotification(
      title: '⏰ Tu reserva está por expirar',
      message: 'El espacio $spotId expira en $minutesLeft minutos',
      type: NotificationType.reservationExpiring,
      data: {
        'spotId': spotId,
        'minutesLeft': minutesLeft,
      },
    );
  }

  // Notificación de reserva expirada
  void notifyReservationExpired({
    required String spotId,
  }) {
    if (!_expirationAlertsEnabled) return;

    addNotification(
      title: '❌ Reserva expirada',
      message: 'Tu reserva del espacio $spotId ha expirado',
      type: NotificationType.reservationExpired,
      data: {'spotId': spotId},
    );
  }

  // Notificación de reserva cancelada
  void notifyReservationCancelled({
    required String spotId,
  }) {
    addNotification(
      title: '🚫 Reserva cancelada',
      message: 'Tu reserva del espacio $spotId ha sido cancelada',
      type: NotificationType.reservationCancelled,
      data: {'spotId': spotId},
    );
  }

  // Notificación de espacio disponible
  void notifySpotAvailable({
    required String spotId,
    required String zoneName,
  }) {
    if (!_availabilityAlertsEnabled) return;

    addNotification(
      title: '🚗 Espacio disponible',
      message: 'El espacio $spotId en $zoneName está disponible',
      type: NotificationType.spotAvailable,
      data: {
        'spotId': spotId,
        'zoneName': zoneName,
      },
    );
  }

  // Notificación general del sistema
  void notifySystemMessage({
    required String title,
    required String message,
  }) {
    addNotification(
      title: title,
      message: message,
      type: NotificationType.system,
    );
  }

  // ========== CONFIGURACIÓN ==========

  void togglePushNotifications(bool enabled) {
    _pushNotificationsEnabled = enabled;
    notifyListeners();
  }

  void toggleReservationReminders(bool enabled) {
    _reservationRemindersEnabled = enabled;
    notifyListeners();
  }

  void toggleExpirationAlerts(bool enabled) {
    _expirationAlertsEnabled = enabled;
    notifyListeners();
  }

  void toggleAvailabilityAlerts(bool enabled) {
    _availabilityAlertsEnabled = enabled;
    notifyListeners();
  }

  // ========== FILTROS ==========

  List<AppNotification> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  List<AppNotification> getRecentNotifications({int limit = 10}) {
    return _notifications.take(limit).toList();
  }

  // ========== UTILIDADES ==========

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ========== MÉTODOS PARA FUTURAS EXTENSIONES CON FCM ==========

  /// Inicializar Firebase Cloud Messaging
  /// TODO: Implementar cuando se agregue FCM
  Future<void> initializeFCM() async {
    // Implementar configuración de FCM
    // - Solicitar permisos
    // - Obtener token
    // - Configurar listeners
  }

  /// Suscribirse a topics
  /// TODO: Implementar cuando se agregue FCM
  Future<void> subscribeToTopic(String topic) async {
    // Implementar suscripción a topics de FCM
  }

  /// Cancelar suscripción a topics
  /// TODO: Implementar cuando se agregue FCM
  Future<void> unsubscribeFromTopic(String topic) async {
    // Implementar cancelación de suscripción
  }
}

// ========== MODELOS ==========

enum NotificationType {
  reservationConfirmed,
  reservationExpiring,
  reservationExpired,
  reservationCancelled,
  spotAvailable,
  system,
  info,
  warning,
  error,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  AppNotification copyWith({
    String? title,
    String? message,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return AppNotification(
      id: id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  String get icon {
    switch (type) {
      case NotificationType.reservationConfirmed:
        return '✅';
      case NotificationType.reservationExpiring:
        return '⏰';
      case NotificationType.reservationExpired:
        return '❌';
      case NotificationType.reservationCancelled:
        return '🚫';
      case NotificationType.spotAvailable:
        return '🚗';
      case NotificationType.warning:
        return '⚠️';
      case NotificationType.error:
        return '🔴';
      case NotificationType.info:
        return 'ℹ️';
      default:
        return '📢';
    }
  }
}
