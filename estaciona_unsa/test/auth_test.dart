import 'package:flutter_test/flutter_test.dart';
import 'package:estaciona_unsa/providers/auth_provider.dart';
import 'package:estaciona_unsa/services/firebase/auth_service.dart';

void main() {
  group('AuthProvider Tests', () {
    test('AuthProvider se inicializa correctamente', () {
      final authProvider = AuthProvider();
      
      expect(authProvider, isNotNull);
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.currentUserData, isNull);
      expect(authProvider.firebaseUser, isNull);
      expect(authProvider.isLoading, isFalse);
      expect(authProvider.errorMessage, isNull);
    });

    test('AuthProvider tiene roles definidos', () {
      final authProvider = AuthProvider();
      
      expect(authProvider.userRole, 'user');
      expect(authProvider.isAdmin, isFalse);
      expect(authProvider.isSecurity, isFalse);
      expect(authProvider.isUser, isTrue);
    });
  });

  group('AuthService Tests', () {
    test('AuthService se inicializa correctamente', () {
      final authService = AuthService();
      
      expect(authService, isNotNull);
      expect(authService.currentUser, isNull); // Sin login inicial
    });

    test('AuthService tiene método isAuthenticated', () {
      final authService = AuthService();
      
      expect(authService.isAuthenticated(), isFalse); // Sin login
    });
  });
}
