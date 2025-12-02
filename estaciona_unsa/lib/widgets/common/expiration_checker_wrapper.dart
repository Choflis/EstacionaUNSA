import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/reservation_provider.dart';

/// Widget que inicia el verificador de expiración cuando el usuario se autentique
class ExpirationCheckerWrapper extends StatefulWidget {
  final Widget child;
  
  const ExpirationCheckerWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ExpirationCheckerWrapper> createState() => _ExpirationCheckerWrapperState();
}

class _ExpirationCheckerWrapperState extends State<ExpirationCheckerWrapper> {
  @override
  void initState() {
    super.initState();
    
    // Escuchar cambios en autenticación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final reservationProvider = context.read<ReservationProvider>();
      
      // Iniciar checker si ya está autenticado
      if (authProvider.isAuthenticated && authProvider.firebaseUser != null) {
        reservationProvider.startExpirationChecker(authProvider.firebaseUser!.uid);
      }
      
      // Escuchar cambios futuros
      authProvider.addListener(() {
        if (authProvider.isAuthenticated && authProvider.firebaseUser != null) {
          reservationProvider.startExpirationChecker(authProvider.firebaseUser!.uid);
        } else {
          reservationProvider.stopExpirationChecker();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
