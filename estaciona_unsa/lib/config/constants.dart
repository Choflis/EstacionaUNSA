class AppConstants {
  // App Info
  static const String appName = 'EstacionaUNSA';
  static const String appVersion = '1.0.0';
  
  // Email Validation
  static const String unsaDomain = '@unsa.edu.pe';
  static const String emailRegex = r'^[\w-\.]+@unsa\.edu\.pe$';
  
  // Reservation Configuration
  static const int minReservationMinutes = 15;
  static const int maxReservationMinutes = 120; // 2 horas
  static const int defaultReservationMinutes = 60;
  static const int reservationExpirationMinutes = 15;
  static const int maxActiveReservationsPerUser = 1;
  
  // Parking Configuration
  static const double maxDistanceToReserveMeters = 500.0;
  static const int refreshIntervalSeconds = 30;
  
  // UI Messages
  static const String errorGeneric = 'Ocurrió un error. Intenta nuevamente.';
  static const String errorNoInternet = 'Sin conexión a Internet';
  static const String errorInvalidEmail = 'Debes usar tu correo @unsa.edu.pe';
  static const String errorMaxReservations = 'Ya tienes una reserva activa';
  static const String errorSpotNotAvailable = 'Este espacio ya no está disponible';
  static const String errorTooFarFromZone = 'Estás muy lejos de la zona';
  
  static const String successReservation = 'Reserva creada exitosamente';
  static const String successCancellation = 'Reserva cancelada';
  
  // Firestore Collections
  static const String usersCollection = 'users';
  static const String campusCollection = 'campus';
  static const String zonesCollection = 'parking_zones';
  static const String spotsCollection = 'parking_spots';
  static const String reservationsCollection = 'reservations';
  static const String incidentsCollection = 'incidents';
  static const String logsCollection = 'entry_exit_logs';
  static const String settingsCollection = 'app_settings';
  
  // Parking Status
  static const String statusAvailable = 'available';
  static const String statusOccupied = 'occupied';
  static const String statusReserved = 'reserved';
  static const String statusMaintenance = 'maintenance';
  
  // Reservation Status
  static const String reservationActive = 'active';
  static const String reservationUsed = 'used';
  static const String reservationExpired = 'expired';
  static const String reservationCancelled = 'cancelled';
  
  // User Roles
  static const String roleUser = 'user';
  static const String roleAdmin = 'admin';
  static const String roleSecurity = 'security';
  
  // Vehicle Types
  static const List<String> vehicleTypes = ['car', 'motorcycle', 'bicycle'];
  
  // Notification Topics
  static const String topicAll = 'all_users';
  static const String topicAdmins = 'admins';
  static const String topicSecurity = 'security';
  
  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
