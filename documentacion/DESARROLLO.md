# 💻 Guía de Desarrollo - EstacionaUNSA

Guía completa para desarrollar funcionalidades en el proyecto EstacionaUNSA.

---

## 📋 Arquitectura del Proyecto

### Clean Architecture + Provider Pattern

```
┌─────────────────────────────────────────────────────────┐
│                         UI LAYER                         │
│  Screens (Pantallas) y Widgets (Componentes visuales)  │
└──────────────────────┬──────────────────────────────────┘
                       │ consume
                       ▼
┌─────────────────────────────────────────────────────────┐
│                    PROVIDER LAYER                        │
│   Gestión de estado con ChangeNotifier + Provider       │
│   • AuthProvider                                        │
│   • ParkingProvider                                     │
│   • ReservationProvider                                 │
└──────────────────────┬──────────────────────────────────┘
                       │ llama
                       ▼
┌─────────────────────────────────────────────────────────┐
│                    SERVICE LAYER                         │
│   Lógica de negocio y comunicación con Firebase        │
│   • AuthService                                         │
│   • FirestoreService                                    │
│   • MessagingService                                    │
└──────────────────────┬──────────────────────────────────┘
                       │ se comunica con
                       ▼
┌─────────────────────────────────────────────────────────┐
│                    FIREBASE BACKEND                      │
│   • Firebase Auth                                       │
│   • Cloud Firestore                                     │
│   • Cloud Messaging                                     │
└─────────────────────────────────────────────────────────┘
```

---

## 🎨 Convenciones de Código

### Nomenclatura

```dart
// ✅ CORRECTO

// Archivos: snake_case
parking_list_screen.dart
user_model.dart
firestore_service.dart

// Clases: PascalCase
class ParkingListScreen extends StatefulWidget { }
class UserModel { }
class FirestoreService { }

// Variables y funciones: camelCase
String userName = "Luis";
void fetchUserData() { }

// Constantes: UPPER_SNAKE_CASE
const int MAX_RESERVATIONS = 1;
const String API_KEY = "xyz123";

// Privados: prefijo _
class _ParkingListScreenState { }
void _loadData() { }
```

### Estructura de Archivos

```dart
// 1. Imports de Flutter
import 'package:flutter/material.dart';

// 2. Imports de paquetes externos
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 3. Imports locales
import '../models/user_model.dart';
import '../services/firebase/auth_service.dart';

// 4. Clase principal
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// 5. Estado privado
class _LoginScreenState extends State<LoginScreen> {
  // Variables de estado
  final _emailController = TextEditingController();
  bool _isLoading = false;

  // Métodos del ciclo de vida
  @override
  void initState() {
    super.initState();
    // Inicialización
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Métodos auxiliares
  void _handleLogin() {
    // Lógica
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI
    );
  }
}
```

---

## 🔧 Implementación de Servicios

### AuthService (Firebase Authentication)

```dart
// lib/services/firebase/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream de cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuario actual
  User? get currentUser => _auth.currentUser;

  // Registro con email/password
  Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // 1. Crear usuario en Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Actualizar perfil
      await credential.user?.updateDisplayName(displayName);

      // 3. Crear documento en Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'displayName': displayName,
        'role': 'user',
        'vehicles': [],
        'stats': {
          'totalReservations': 0,
          'activeReservations': 0,
          'completedReservations': 0,
          'noShowCount': 0,
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } catch (e) {
      print('Error en registro: $e');
      rethrow;
    }
  }

  // Login con email/password
  Future<UserCredential?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error en login: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Resetear contraseña
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
```

### FirestoreService (Base de datos)

```dart
// lib/services/firebase/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_spot_model.dart';
import '../models/reservation_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== PARKING ZONES ==========

  // Obtener todas las zonas
  Future<List<ParkingZoneModel>> getAllZones() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('parking_zones')
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => ParkingZoneModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      print('Error obteniendo zonas: $e');
      return [];
    }
  }

  // Stream de zonas (tiempo real)
  Stream<List<ParkingZoneModel>> zonesStream() {
    return _firestore
        .collection('parking_zones')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ParkingZoneModel.fromMap(
                  doc.data(),
                  doc.id,
                ))
            .toList());
  }

  // ========== PARKING SPOTS ==========

  // Obtener espacios por zona
  Stream<List<ParkingSpotModel>> spotsStreamByZone(String zoneId) {
    return _firestore
        .collection('parking_spots')
        .where('zoneId', isEqualTo: zoneId)
        .orderBy('spotNumber')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ParkingSpotModel.fromMap(
                  doc.data(),
                  doc.id,
                ))
            .toList());
  }

  // Obtener espacios disponibles
  Future<List<ParkingSpotModel>> getAvailableSpots(String zoneId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('parking_spots')
          .where('zoneId', isEqualTo: zoneId)
          .where('status', isEqualTo: 'available')
          .orderBy('spotNumber')
          .get();

      return snapshot.docs
          .map((doc) => ParkingSpotModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      print('Error obteniendo espacios: $e');
      return [];
    }
  }

  // ========== RESERVATIONS ==========

  // Crear reserva con transacción
  Future<String> createReservation(ReservationModel reservation) async {
    try {
      // Usar transacción para garantizar atomicidad
      return await _firestore.runTransaction<String>((transaction) async {
        // 1. Verificar que el espacio está disponible
        DocumentSnapshot spotDoc = await transaction.get(
          _firestore.collection('parking_spots').doc(reservation.spotId),
        );

        if (!spotDoc.exists) {
          throw Exception('Espacio no existe');
        }

        Map<String, dynamic> spotData = spotDoc.data() as Map<String, dynamic>;
        if (spotData['status'] != 'available') {
          throw Exception('Espacio no disponible');
        }

        // 2. Verificar que el usuario no tiene reserva activa
        QuerySnapshot activeReservations = await _firestore
            .collection('reservations')
            .where('userId', isEqualTo: reservation.userId)
            .where('status', isEqualTo: 'active')
            .get();

        if (activeReservations.docs.isNotEmpty) {
          throw Exception('Ya tienes una reserva activa');
        }

        // 3. Crear reserva
        DocumentReference reservationRef = _firestore
            .collection('reservations')
            .doc();
        
        transaction.set(reservationRef, reservation.toMap());

        // 4. Actualizar espacio
        transaction.update(
          _firestore.collection('parking_spots').doc(reservation.spotId),
          {
            'status': 'reserved',
            'currentReservation': {
              'reservationId': reservationRef.id,
              'userId': reservation.userId,
              'expiresAt': reservation.time.expiresAt,
            },
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );

        // 5. Actualizar contador de zona
        transaction.update(
          _firestore.collection('parking_zones').doc(reservation.zoneId),
          {
            'capacity.availableSpots': FieldValue.increment(-1),
            'capacity.reservedSpots': FieldValue.increment(1),
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );

        return reservationRef.id;
      });
    } catch (e) {
      print('Error creando reserva: $e');
      rethrow;
    }
  }

  // Obtener reservas del usuario
  Stream<List<ReservationModel>> getUserReservations(String userId) {
    return _firestore
        .collection('reservations')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReservationModel.fromMap(
                  doc.data(),
                  doc.id,
                ))
            .toList());
  }

  // Cancelar reserva
  Future<void> cancelReservation(String reservationId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // Obtener reserva
        DocumentSnapshot reservationDoc = await transaction.get(
          _firestore.collection('reservations').doc(reservationId),
        );

        if (!reservationDoc.exists) {
          throw Exception('Reserva no existe');
        }

        Map<String, dynamic> data = reservationDoc.data() as Map<String, dynamic>;

        // Actualizar reserva
        transaction.update(
          _firestore.collection('reservations').doc(reservationId),
          {
            'status': 'cancelled',
            'cancelledAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );

        // Liberar espacio
        transaction.update(
          _firestore.collection('parking_spots').doc(data['spotId']),
          {
            'status': 'available',
            'currentReservation': FieldValue.delete(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );

        // Actualizar contador de zona
        transaction.update(
          _firestore.collection('parking_zones').doc(data['zoneId']),
          {
            'capacity.availableSpots': FieldValue.increment(1),
            'capacity.reservedSpots': FieldValue.increment(-1),
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );
      });
    } catch (e) {
      print('Error cancelando reserva: $e');
      rethrow;
    }
  }
}
```

---

## 🔄 Implementación de Providers

### AuthProvider

```dart
// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // Constructor
  AuthProvider() {
    // Escuchar cambios de autenticación
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  // Cargar datos del usuario desde Firestore
  Future<void> _loadUserData(String uid) async {
    // TODO: Implementar carga de UserModel desde Firestore
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.loginWithEmail(
        email: email,
        password: password,
      );

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

  // Registro
  Future<bool> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.registerWithEmail(
        email: email,
        password: password,
        displayName: name,
      );

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

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _userModel = null;
    notifyListeners();
  }

  // Convertir errores a mensajes amigables
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No existe una cuenta con este correo';
        case 'wrong-password':
          return 'Contraseña incorrecta';
        case 'email-already-in-use':
          return 'Este correo ya está registrado';
        case 'weak-password':
          return 'La contraseña es muy débil';
        case 'invalid-email':
          return 'Correo electrónico inválido';
        default:
          return 'Error: ${error.message}';
      }
    }
    return 'Error desconocido';
  }
}
```

---

## 🎨 Implementación de UI

### Ejemplo: LoginScreen

```dart
// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        // Navegar a home
        Navigator.pushReplacementNamed(context, '/home');
      } else if (mounted) {
        // Mostrar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Error al iniciar sesión'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'EstacionaUNSA',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 48),
                
                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo @unsa.edu.pe',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    if (!value.endsWith('@unsa.edu.pe')) {
                      return 'Debe ser correo institucional @unsa.edu.pe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    if (value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Botón Login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _handleLogin,
                    child: authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Iniciar Sesión'),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Link a registro
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 🧪 Testing

### Unit Tests

```dart
// test/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:estaciona_unsa/services/firebase/auth_service.dart';

void main() {
  group('AuthService', () {
    test('validateEmail retorna true para email @unsa.edu.pe', () {
      final service = AuthService();
      expect(service.validateEmail('test@unsa.edu.pe'), true);
    });

    test('validateEmail retorna false para email no institucional', () {
      final service = AuthService();
      expect(service.validateEmail('test@gmail.com'), false);
    });
  });
}
```

---

## 📚 Recursos Útiles

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Pattern](https://pub.dev/packages/provider)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Material Design 3](https://m3.material.io/)

---

**Guía actualizada:** Noviembre 2024
