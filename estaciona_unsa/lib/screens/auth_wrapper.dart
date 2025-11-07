import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'main_nav_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Mostrar loading mientras se verifica el estado de auth
        if (authProvider.firebaseUser == null && authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Si está autenticado, mostrar la app
        if (authProvider.isAuthenticated) {
          return const MainNavScreen();
        }
        
        // Si no está autenticado, mostrar login
        return const LoginScreen();
      },
    );
  }
}
