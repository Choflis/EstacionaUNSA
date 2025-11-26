# 🎯 Guía de Integración de Providers y Services

Esta guía muestra cómo integrar y usar los providers y services en la aplicación.

## 📋 Tabla de Contenidos

1. [Configuración en main.dart](#configuración-en-maindart)
2. [Uso de AuthProvider](#uso-de-authprovider)
3. [Uso de ParkingProvider](#uso-de-parkingprovider)
4. [Uso de ReservationProvider](#uso-de-reservationprovider)
5. [Uso de NotificationProvider](#uso-de-notificationprovider)
6. [Integración completa](#integración-completa)

---

## Configuración en main.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'providers/parking_provider.dart';
import 'providers/reservation_provider.dart';
import 'providers/notification_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/main_nav_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Opcional: Inicializar MessagingService
  // await MessagingService().initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider - debe ser el primero
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // Parking Provider
        ChangeNotifierProvider(create: (_) => ParkingProvider()),
        
        // Reservation Provider
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        
        // Notification Provider
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'EstacionaUNSA',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    if (authProvider.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (authProvider.isAuthenticated) {
      return MainNavScreen();
    } else {
      return LoginScreen();
    }
  }
}
```

---

## Uso de AuthProvider

### En LoginScreen

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.signInWithGoogle();
    
    if (!success && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return Scaffold(
      body: Center(
        child: authProvider.isLoading
            ? CircularProgressIndicator()
            : ElevatedButton.icon(
                icon: Icon(Icons.login),
                label: Text('Iniciar sesión con Google'),
                onPressed: () => _handleGoogleSignIn(context),
              ),
      ),
    );
  }
}
```

### En ProfileScreen

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUserData;
    
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Column(
        children: [
          Text('Nombre: ${user?.name ?? ""}'),
          Text('Email: ${user?.email ?? ""}'),
          Text('Rol: ${user?.role ?? ""}'),
          
          ElevatedButton(
            onPressed: () => authProvider.signOut(),
            child: Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
```

---

## Uso de ParkingProvider

### Listar zonas y espacios

```dart
class ParkingListScreen extends StatefulWidget {
  @override
  _ParkingListScreenState createState() => _ParkingListScreenState();
}

class _ParkingListScreenState extends State<ParkingListScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar zonas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParkingProvider>().loadZones();
    });
  }

  @override
  Widget build(BuildContext context) {
    final parkingProvider = context.watch<ParkingProvider>();
    
    return Scaffold(
      appBar: AppBar(title: Text('Zonas de Estacionamiento')),
      body: parkingProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: parkingProvider.zones.length,
              itemBuilder: (context, index) {
                final zone = parkingProvider.zones[index];
                return ListTile(
                  title: Text(zone.zoneName),
                  subtitle: Text('${zone.capacity.available} disponibles'),
                  onTap: () => _selectZone(context, zone.zoneId),
                );
              },
            ),
    );
  }

  void _selectZone(BuildContext context, String zoneId) {
    context.read<ParkingProvider>().selectZone(zoneId);
    Navigator.pushNamed(context, '/parking-spots');
  }
}
```

### Mostrar espacios con StreamBuilder

```dart
class ParkingSpotsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final parkingProvider = context.watch<ParkingProvider>();
    final selectedZone = parkingProvider.selectedZone;
    
    if (selectedZone == null) {
      return Scaffold(body: Center(child: Text('Selecciona una zona')));
    }
    
    return Scaffold(
      appBar: AppBar(title: Text(selectedZone.zoneName)),
      body: StreamBuilder(
        stream: parkingProvider.spotsStreamByZone(selectedZone.zoneId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          
          final spots = snapshot.data!;
          final availableSpots = spots.where((s) => s.isAvailable).toList();
          
          return ListView.builder(
            itemCount: availableSpots.length,
            itemBuilder: (context, index) {
              final spot = availableSpots[index];
              return ParkingSpotCard(spot: spot);
            },
          );
        },
      ),
    );
  }
}
```

---

## Uso de ReservationProvider

### Crear una reserva

```dart
class ReservationFormScreen extends StatefulWidget {
  final String spotId;
  final String zoneId;
  
  ReservationFormScreen({required this.spotId, required this.zoneId});
  
  @override
  _ReservationFormScreenState createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  int _durationMinutes = 15;
  
  Future<void> _createReservation() async {
    final authProvider = context.read<AuthProvider>();
    final reservationProvider = context.read<ReservationProvider>();
    final notificationProvider = context.read<NotificationProvider>();
    
    final userId = authProvider.currentUserData?.uid;
    if (userId == null) return;
    
    // Validar primero
    final validation = await reservationProvider.validateReservation(
      userId: userId,
      spotId: widget.spotId,
    );
    
    if (!validation['canReserve']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validation['reason'])),
      );
      return;
    }
    
    // Crear reserva
    final reservationId = await reservationProvider.createReservation(
      userId: userId,
      spotId: widget.spotId,
      zoneId: widget.zoneId,
      durationMinutes: _durationMinutes,
      latitude: 0.0, // Obtener ubicación real
      longitude: 0.0,
    );
    
    if (reservationId != null) {
      // Notificar éxito
      notificationProvider.notifyReservationConfirmed(
        spotId: widget.spotId,
        zoneName: 'Zona A',
        expiresAt: DateTime.now().add(Duration(minutes: _durationMinutes)),
      );
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Reserva creada exitosamente!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(reservationProvider.errorMessage ?? 'Error')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final reservationProvider = context.watch<ReservationProvider>();
    
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Reserva')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Duración: $_durationMinutes minutos'),
            Slider(
              value: _durationMinutes.toDouble(),
              min: 15,
              max: 60,
              divisions: 3,
              label: '$_durationMinutes min',
              onChanged: (value) {
                setState(() => _durationMinutes = value.toInt());
              },
            ),
            
            SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: reservationProvider.isLoading 
                  ? null 
                  : _createReservation,
              child: reservationProvider.isLoading
                  ? CircularProgressIndicator()
                  : Text('Confirmar Reserva'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Ver reservas activas

```dart
class MyReservationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final reservationProvider = context.watch<ReservationProvider>();
    
    final userId = authProvider.currentUserData?.uid;
    
    if (userId == null) {
      return Scaffold(body: Center(child: Text('Inicia sesión')));
    }
    
    return Scaffold(
      appBar: AppBar(title: Text('Mis Reservas')),
      body: StreamBuilder(
        stream: reservationProvider.activeReservationsStream(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          
          final reservations = snapshot.data!;
          
          if (reservations.isEmpty) {
            return Center(child: Text('No tienes reservas activas'));
          }
          
          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return ReservationCard(
                reservation: reservation,
                onCancel: () => _cancelReservation(context, reservation),
              );
            },
          );
        },
      ),
    );
  }
  
  Future<void> _cancelReservation(
    BuildContext context,
    ReservationModel reservation,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancelar Reserva'),
        content: Text('¿Seguro que deseas cancelar esta reserva?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Sí, cancelar'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final success = await context.read<ReservationProvider>().cancelReservation(
        reservation.reservationId,
        reservation.spotId,
      );
      
      if (success) {
        context.read<NotificationProvider>().notifyReservationCancelled(
          spotId: reservation.spotId,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reserva cancelada')),
        );
      }
    }
  }
}
```

---

## Uso de NotificationProvider

### Mostrar notificaciones

```dart
class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
        actions: [
          if (notificationProvider.hasUnread)
            TextButton(
              onPressed: () => notificationProvider.markAllAsRead(),
              child: Text('Marcar todas como leídas'),
            ),
        ],
      ),
      body: notificationProvider.notifications.isEmpty
          ? Center(child: Text('No hay notificaciones'))
          : ListView.builder(
              itemCount: notificationProvider.notifications.length,
              itemBuilder: (context, index) {
                final notification = notificationProvider.notifications[index];
                return ListTile(
                  leading: Text(
                    notification.icon,
                    style: TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead 
                          ? FontWeight.normal 
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.message),
                      Text(
                        notification.timeAgo,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    notificationProvider.markAsRead(notification.id);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      notificationProvider.deleteNotification(notification.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
```

### Badge de notificaciones

```dart
class NotificationBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();
    final count = notificationProvider.unreadCount;
    
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            Navigator.pushNamed(context, '/notifications');
          },
        ),
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                count > 9 ? '9+' : '$count',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
```

---

## Integración Completa

### MainNavScreen con todos los providers

```dart
class MainNavScreen extends StatefulWidget {
  @override
  _MainNavScreenState createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }
  
  Future<void> _loadInitialData() async {
    final authProvider = context.read<AuthProvider>();
    final parkingProvider = context.read<ParkingProvider>();
    final reservationProvider = context.read<ReservationProvider>();
    
    final userId = authProvider.currentUserData?.uid;
    if (userId == null) return;
    
    // Cargar datos iniciales en paralelo
    await Future.wait([
      parkingProvider.loadZones(),
      reservationProvider.loadActiveReservations(userId),
    ]);
    
    // Verificar reservas expiradas
    await reservationProvider.checkAndExpireReservations(userId);
  }
  
  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardPage(),
      ParkingListPage(),
      MyReservationsPage(),
      ProfilePage(),
    ];
    
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: 'Espacios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
```

---

## 🎯 Resumen

### Providers creados:
1. ✅ **AuthProvider** - Autenticación y usuario actual
2. ✅ **ParkingProvider** - Zonas y espacios de estacionamiento
3. ✅ **ReservationProvider** - Reservas del usuario
4. ✅ **NotificationProvider** - Notificaciones in-app

### Services creados:
1. ✅ **AuthService** - Firebase Authentication
2. ✅ **FirestoreService** - Firestore Database
3. ✅ **MessagingService** - Firebase Cloud Messaging (opcional)

### Flujo completo:
1. Usuario inicia sesión → **AuthProvider**
2. Se cargan zonas y espacios → **ParkingProvider**
3. Usuario crea reserva → **ReservationProvider**
4. Se actualiza estado del espacio → **ParkingProvider**
5. Se muestra notificación → **NotificationProvider**
6. Reserva expira automáticamente → **ReservationProvider**

---

**¡Todos los providers y services están listos para usar! 🚀**
