import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: kIsWeb ? null : '169600291245-0ofnsflh0npo4tl3npp4a5m8nt8oac84.apps.googleusercontent.com',
  );
  final FirestoreService _firestoreService = FirestoreService();

  // Stream del usuario autenticado
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuario actual
  User? get currentUser => _auth.currentUser;

  // ========== SIGN IN WITH GOOGLE ==========
  
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Limpiar sesión anterior
      await _googleSignIn.signOut();
      
      // Iniciar flujo de Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Login cancelado por el usuario');
      }

      // Validar correo institucional UNSA
      final email = googleUser.email;
      if (!email.endsWith('@unsa.edu.pe')) {
        await _googleSignIn.signOut();
        throw Exception('Solo se permiten correos institucionales UNSA (@unsa.edu.pe)');
      }

      // Obtener credenciales de Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crear credencial para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Autenticar con Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Crear o actualizar usuario en Firestore
      await _createOrUpdateUserInFirestore(userCredential.user!, googleUser);
      
      return userCredential;
    } catch (e) {
      print('Error en signInWithGoogle: $e');
      rethrow;
    }
  }

  // ========== SIGN OUT ==========
  
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Error en signOut: $e');
      rethrow;
    }
  }

  // ========== HELPER: CREAR O ACTUALIZAR USUARIO EN FIRESTORE ==========
  
  Future<void> _createOrUpdateUserInFirestore(User firebaseUser, GoogleSignInAccount googleUser) async {
    try {
      // Verificar si el usuario ya existe
      final existingUser = await _firestoreService.getUser(firebaseUser.uid);
      
      if (existingUser == null) {
        // Usuario nuevo - crear documento
        final newUser = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? googleUser.email,
          displayName: firebaseUser.displayName ?? googleUser.displayName ?? 'Usuario',
          role: 'user', // Por defecto es usuario regular
          vehicles: [],
          stats: UserStats(), // Estadísticas iniciales en 0
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          photoURL: firebaseUser.photoURL ?? googleUser.photoUrl,
          isActive: true,
        );
        
        await _firestoreService.createUser(newUser);
        print('✅ Usuario creado en Firestore: ${newUser.displayName}');
      } else {
        // Usuario existente - actualizar última conexión
        await _firestoreService.updateUser(firebaseUser.uid, {
          'updatedAt': FieldValue.serverTimestamp(),
          'photoURL': firebaseUser.photoURL ?? googleUser.photoUrl,
        });
        print('✅ Usuario actualizado en Firestore: ${existingUser.displayName}');
      }
    } catch (e) {
      print('❌ Error al crear/actualizar usuario en Firestore: $e');
      // No lanzar error para no bloquear el login
    }
  }

  // ========== VERIFICAR SI ESTÁ AUTENTICADO ==========
  
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  // ========== OBTENER DATOS DEL USUARIO DESDE FIRESTORE ==========
  
  Future<UserModel?> getCurrentUserData() async {
    final user = currentUser;
    if (user == null) return null;
    
    try {
      return await _firestoreService.getUser(user.uid);
    } catch (e) {
      print('Error obteniendo datos del usuario: $e');
      return null;
    }
  }

  // ========== STREAM DEL USUARIO CON DATOS DE FIRESTORE ==========
  
  Stream<UserModel?> getCurrentUserDataStream() {
    final user = currentUser;
    if (user == null) return Stream.value(null);
    
    return _firestoreService.userStream(user.uid);
  }
}
