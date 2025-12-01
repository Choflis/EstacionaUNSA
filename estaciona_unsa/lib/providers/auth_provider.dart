import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firebase/auth_service.dart';
import '../utils/logger.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUserData;
  User? _firebaseUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUserData => _currentUserData;
  User? get firebaseUser => _firebaseUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;

  AuthProvider() {
    _initAuthListener();
  }

  // ========== INICIALIZAR LISTENER DE AUTH STATE ==========
  
  void _initAuthListener() {
    _authService.authStateChanges.listen((User? user) async {
      _firebaseUser = user;
      
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _currentUserData = null;
      }
      
      notifyListeners();
    });
  }

  // ========== CARGAR DATOS DEL USUARIO DESDE FIRESTORE ==========
  
  Future<void> _loadUserData(String uid) async {
    try {
      _currentUserData = await _authService.getCurrentUserData();
    } catch (e) {
      logger.d('Error cargando datos del usuario: $e');
      _currentUserData = null;
    }
  }

  // ========== SIGN IN WITH GOOGLE ==========
  
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  // ========== SIGN OUT ==========
  
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _currentUserData = null;
      _firebaseUser = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cerrar sesión';
      notifyListeners();
      rethrow;
    }
  }

  // ========== REFRESH USER DATA ==========
  
  Future<void> refreshUserData() async {
    if (_firebaseUser == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    await _loadUserData(_firebaseUser!.uid);
    
    _isLoading = false;
    notifyListeners();
  }

  // ========== CLEAR ERROR ==========
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ========== HELPER: MAPEAR ERRORES ==========
  
  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    
    if (errorStr.contains('unsa.edu.pe')) {
      return 'Solo se permiten correos institucionales UNSA (@unsa.edu.pe)';
    } else if (errorStr.contains('cancelado')) {
      return 'Inicio de sesión cancelado';
    } else if (errorStr.contains('network')) {
      return 'Error de conexión. Verifica tu internet';
    } else if (errorStr.contains('account-exists')) {
      return 'Ya existe una cuenta con este correo';
    } else if (errorStr.contains('invalid-credential')) {
      return 'Credenciales inválidas. Intenta nuevamente';
    } else if (errorStr.contains('user-disabled')) {
      return 'Esta cuenta ha sido deshabilitada';
    } else if (errorStr.contains('sign_in_failed')) {
      return 'Error al iniciar sesión. Verifica tu conexión e intenta nuevamente';
    } else {
      return 'Error al iniciar sesión. Intenta nuevamente';
    }
  }

  // ========== OBTENER ROLE DEL USUARIO ==========
  
  String get userRole => _currentUserData?.role ?? 'user';
  
  bool get isAdmin => userRole == 'admin';
  bool get isSecurity => userRole == 'security';
  bool get isUser => userRole == 'user';
}
