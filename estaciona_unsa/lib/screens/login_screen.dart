import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: '169600291245-0ofnsflh0npo4tl3npp4a5m8nt8oac84.apps.googleusercontent.com',
  );
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);

    try {
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final email = googleUser.email;

      if (!email.endsWith('@unsa.edu.pe')) {
        await _googleSignIn.signOut();
        if (!mounted) return;
        
        setState(() => _isLoading = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solo se permiten correos institucionales UNSA (@unsa.edu.pe)'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (!mounted) return;
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );

    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      String errorMessage = 'Error al iniciar sesión con Google';
      
      if (e.code == 'sign_in_failed') {
        errorMessage = 'Error al iniciar sesión. Verifica tu conexión e intenta nuevamente';
      } else if (e.code == 'sign_in_canceled') {
        errorMessage = 'Inicio de sesión cancelado';
      } else if (e.code == 'network_error') {
        errorMessage = 'Error de red. Verifica tu conexión';
      } else {
        errorMessage = 'Error: ${e.message ?? e.code}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      String errorMessage = 'Error al iniciar sesión';
      
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'Ya existe una cuenta con este correo';
          break;
        case 'invalid-credential':
          errorMessage = 'Credenciales inválidas. Intenta nuevamente';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Operación no permitida. Contacta al administrador';
          break;
        case 'user-disabled':
          errorMessage = 'Esta cuenta ha sido deshabilitada';
          break;
        case 'user-not-found':
          errorMessage = 'Usuario no encontrado';
          break;
        case 'wrong-password':
          errorMessage = 'Contraseña incorrecta';
          break;
        case 'network-request-failed':
          errorMessage = 'Error de conexión. Verifica tu internet';
          break;
        default:
          errorMessage = 'Error: ${e.message ?? e.code}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F3),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_parking, size: 100, color: Colors.brown),
            const SizedBox(height: 20),
            const Text(
              'UNSA Parking',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Encuentra y reserva tu estacionamiento en el campus de forma fácil y rápida.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _signInWithGoogle,
              icon: _isLoading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                      ),
                    )
                  : const Icon(Icons.login),
              label: Text(_isLoading ? 'Iniciando sesión...' : 'Continuar con Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[600],
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Al continuar, aceptas nuestros Términos de Servicio.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
