import 'package:intl/intl.dart';
import 'dart:math';
import '../config/constants.dart';

class Helpers {
  // ========== DATE & TIME FORMATTING ==========
  
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat(AppConstants.timeFormat).format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat(AppConstants.dateTimeFormat).format(dateTime);
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'hace $years ${years == 1 ? "año" : "años"}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'hace $months ${months == 1 ? "mes" : "meses"}';
    } else if (difference.inDays > 0) {
      return 'hace ${difference.inDays} ${difference.inDays == 1 ? "día" : "días"}';
    } else if (difference.inHours > 0) {
      return 'hace ${difference.inHours} ${difference.inHours == 1 ? "hora" : "horas"}';
    } else if (difference.inMinutes > 0) {
      return 'hace ${difference.inMinutes} ${difference.inMinutes == 1 ? "minuto" : "minutos"}';
    } else {
      return 'hace un momento';
    }
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '$hours h $minutes min';
    } else {
      return '$minutes min';
    }
  }

  static String formatTimeRemaining(DateTime expiresAt) {
    final now = DateTime.now();
    final difference = expiresAt.difference(now);

    if (difference.isNegative) {
      return 'Expirado';
    }

    final minutes = difference.inMinutes;
    final seconds = difference.inSeconds.remainder(60);

    if (minutes > 0) {
      return '$minutes:${seconds.toString().padLeft(2, '0')} min';
    } else {
      return '$seconds seg';
    }
  }

  // ========== DISTANCE CALCULATIONS ==========

  static double calculateDistance(
    double lat1, double lon1, 
    double lat2, double lon2
  ) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
              cos(_degreesToRadians(lat1)) * 
              cos(_degreesToRadians(lat2)) *
              sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distanceKm = earthRadiusKm * c;

    return distanceKm * 1000; // Convertir a metros
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  // ========== STRING UTILITIES ==========

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // ========== STATUS HELPERS ==========

  static String getStatusText(String status) {
    switch (status) {
      case AppConstants.statusAvailable:
        return 'Disponible';
      case AppConstants.statusOccupied:
        return 'Ocupado';
      case AppConstants.statusReserved:
        return 'Reservado';
      case AppConstants.statusMaintenance:
        return 'Mantenimiento';
      case AppConstants.reservationActive:
        return 'Activa';
      case AppConstants.reservationUsed:
        return 'Usada';
      case AppConstants.reservationExpired:
        return 'Expirada';
      case AppConstants.reservationCancelled:
        return 'Cancelada';
      default:
        return capitalize(status);
    }
  }

  static String getVehicleTypeText(String type) {
    switch (type) {
      case 'car':
        return 'Auto';
      case 'motorcycle':
        return 'Moto';
      case 'bicycle':
        return 'Bicicleta';
      default:
        return capitalize(type);
    }
  }

  static String getRoleText(String role) {
    switch (role) {
      case AppConstants.roleUser:
        return 'Usuario';
      case AppConstants.roleAdmin:
        return 'Administrador';
      case AppConstants.roleSecurity:
        return 'Seguridad';
      default:
        return capitalize(role);
    }
  }

  // ========== VALIDATION HELPERS ==========

  static bool isWithinRange(double distance, double maxDistance) {
    return distance <= maxDistance;
  }

  static bool isReservationExpired(DateTime expiresAt) {
    return DateTime.now().isAfter(expiresAt);
  }

  static bool isReservationExpiringSoon(DateTime expiresAt, {int minutesThreshold = 5}) {
    final now = DateTime.now();
    final difference = expiresAt.difference(now);
    return difference.inMinutes <= minutesThreshold && difference.inMinutes > 0;
  }

  // ========== COLOR HELPERS ==========

  static int hexToInt(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  // ========== NUMBER FORMATTING ==========

  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(0)}%';
  }

  static String pluralize(int count, String singular, String plural) {
    return count == 1 ? singular : plural;
  }
}
