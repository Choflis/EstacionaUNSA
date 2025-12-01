import '../config/constants.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo es requerido';
    }
    
    final emailRegex = RegExp(AppConstants.emailRegex);
    if (!emailRegex.hasMatch(value.trim())) {
      return AppConstants.errorInvalidEmail;
    }
    
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  static String? validatePlate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La placa es requerida';
    }
    
    final plate = value.trim().toUpperCase();
    
    // Formato peruano: ABC-123 o ABC123 (3 letras, 3 números)
    final plateRegex = RegExp(r'^[A-Z]{3}-?\d{3}$');
    if (!plateRegex.hasMatch(plate)) {
      return 'Formato de placa inválido (Ej: ABC-123)';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El teléfono es requerido';
    }
    
    // Formato peruano: 9 dígitos
    final phoneRegex = RegExp(r'^9\d{8}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Formato de teléfono inválido (9 dígitos)';
    }
    
    return null;
  }

  static String? validateReservationDuration(int? minutes) {
    if (minutes == null) {
      return 'La duración es requerida';
    }
    
    if (minutes < AppConstants.minReservationMinutes) {
      return 'Duración mínima: ${AppConstants.minReservationMinutes} minutos';
    }
    
    if (minutes > AppConstants.maxReservationMinutes) {
      return 'Duración máxima: ${AppConstants.maxReservationMinutes} minutos';
    }
    
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es requerido';
    }
    
    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }

  static bool isValidUnsaEmail(String email) {
    return email.trim().toLowerCase().endsWith(AppConstants.unsaDomain);
  }

  static String normalizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  static String normalizePlate(String plate) {
    String normalized = plate.trim().toUpperCase();
    // Asegurar formato con guión: ABC123 -> ABC-123
    if (normalized.length == 6 && !normalized.contains('-')) {
      normalized = '${normalized.substring(0, 3)}-${normalized.substring(3)}';
    }
    return normalized;
  }
}
