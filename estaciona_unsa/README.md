# EstacionaUNSA - Sistema de Gestión de Estacionamiento

Aplicación móvil para la gestión inteligente de espacios de estacionamiento en la Universidad Nacional de San Agustín (UNSA).

---

## 🚀 Inicio Rápido

### Requisitos Previos
- Flutter SDK (>=3.0.0)
- Firebase CLI
- Dart SDK
- Android Studio / VS Code
- Git

### Instalación

```bash
# Clonar el repositorio
git clone [url-del-repositorio]
cd estaciona_unsa

# Instalar dependencias
flutter pub get

# Configurar Firebase
flutterfire configure

# Ejecutar la aplicación
flutter run
```

---

## 📁 Arquitectura del Proyecto

### Estructura de Carpetas

```
lib/
├── main.dart                          # Punto de entrada
├── config/                            # Configuraciones globales
│   ├── theme.dart                     # Temas y estilos
│   ├── routes.dart                    # Rutas de navegación
│   └── constants.dart                 # Constantes
├── models/                            # Modelos de datos
│   ├── user_model.dart
│   ├── parking_spot_model.dart
│   ├── parking_zone_model.dart
│   └── reservation_model.dart
├── providers/                         # Gestión de estado (Provider)
│   ├── auth_provider.dart
│   ├── parking_provider.dart
│   └── reservation_provider.dart
├── services/                          # Lógica de negocio
│   └── firebase/
│       ├── auth_service.dart
│       ├── firestore_service.dart
│       └── messaging_service.dart
├── screens/                           # Pantallas de la app
│   ├── auth/
│   ├── home/
│   ├── parking/
│   └── profile/
├── widgets/                           # Widgets reutilizables
│   ├── common/
│   ├── parking/
│   └── profile/
└── utils/                             # Utilidades
    ├── validators.dart
    ├── firestore_seed.dart
    └── helpers.dart
```

### Flujo de Arquitectura

**Clean Architecture + Provider Pattern:**

```
UI (Screens) → Providers (Estado) → Services (Lógica) → Firebase (Backend)
```

---

## 🔥 Configuración de Firebase

### Plataformas Soportadas

- ✅ **Web**: Firebase completamente funcional
- ✅ **Android**: Firebase completamente funcional  
- ✅ **iOS**: Firebase completamente funcional
- ⚠️ **Desktop** (Linux/Windows/macOS): App funciona, Firebase NO inicializa

### Servicios Firebase Utilizados

1. **Authentication**: Autenticación de usuarios (@unsa.edu.pe)
2. **Cloud Firestore**: Base de datos en tiempo real
3. **Cloud Messaging**: Notificaciones push
4. **Storage**: Almacenamiento de archivos (opcional)

### Inicialización Condicional

El proyecto está configurado para inicializar Firebase solo en plataformas compatibles:

```dart
// lib/main.dart
if (kIsWeb || 
    defaultTargetPlatform == TargetPlatform.android || 
    defaultTargetPlatform == TargetPlatform.iOS) {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
```

---

## 🗄️ Base de Datos (Firestore)

### Estructura de Colecciones

```
firestore/
├── users/                  # Usuarios del sistema
├── parking_zones/          # Zonas de estacionamiento
├── parking_spots/          # Espacios individuales
├── reservations/           # Reservas activas
├── entry_exit_logs/        # Logs de entrada/salida
├── incidents/              # Incidencias reportadas
└── app_settings/           # Configuración global
```

### Configuración Inicial

**1. Habilitar Firestore en Firebase Console:**

```bash
1. https://console.firebase.google.com
2. Seleccionar proyecto "EstacionaUNSA"
3. Firestore Database → Crear base de datos
4. Modo de prueba (30 días)
5. Ubicación: southamerica-east1 (São Paulo)
```

**2. Desplegar Reglas de Seguridad:**

```bash
firebase login
firebase deploy --only firestore:rules
```

**3. Inicializar con Datos de Prueba:**

Edita `lib/main.dart` temporalmente:

```dart
import 'utils/firestore_seed.dart';

void main() async {
  // ... inicialización Firebase
  
  // Ejecutar solo UNA VEZ
  await runFirestoreSeed();
  
  runApp(const MyApp());
}
```

Esto crea:
- **3 Zonas** de estacionamiento (A, B, C)
- **120 Espacios** distribuidos en las zonas
- **Configuración** inicial del sistema

> **⚠️ IMPORTANTE:** Después de ejecutar, comenta la línea para evitar duplicar datos.

### Reglas de Seguridad

| Colección | Lectura | Escritura | Eliminación |
|-----------|---------|-----------|-------------|
| `users` | Usuario mismo | Usuario mismo | ❌ |
| `parking_zones` | ✅ Todos | Admin | Admin |
| `parking_spots` | ✅ Todos | Guards/Admin | Admin |
| `reservations` | Usuario mismo | Usuario mismo | ❌ |
| `entry_exit_logs` | Usuario/Guards | Guards/Admin | ❌ |

**Restricciones importantes:**
- Email debe ser @unsa.edu.pe
- Solo 1 reserva activa por usuario
- Guards solo pueden crear logs donde ellos son el guard
- No se pueden eliminar reservas (solo cancelar)

---

## 💻 Uso del Sistema

### Ejemplo: Listar Zonas Disponibles

```dart
import '../services/firebase/firestore_service.dart';

final firestoreService = FirestoreService();

// Obtener todas las zonas
final zones = await firestoreService.getAllZones();

// Escuchar cambios en tiempo real
StreamBuilder<List<ParkingZoneModel>>(
  stream: firestoreService.zonesStream(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final zones = snapshot.data!;
      return ListView.builder(
        itemCount: zones.length,
        itemBuilder: (context, index) {
          final zone = zones[index];
          return ListTile(
            title: Text(zone.name),
            subtitle: Text('${zone.capacity.availableSpots} disponibles'),
          );
        },
      );
    }
    return CircularProgressIndicator();
  },
);
```

### Ejemplo: Crear Reserva

```dart
final firestoreService = FirestoreService();

// 1. Verificar si ya tiene reserva activa
final hasReservation = await firestoreService.hasActiveReservation(userId);
if (hasReservation) return;

// 2. Crear reserva
final reservation = ReservationModel(
  reservationId: '',
  userId: userId,
  spotId: spotId,
  zoneId: zoneId,
  time: ReservationTime(
    startedAt: DateTime.now(),
    expiresAt: DateTime.now().add(Duration(minutes: 15)),
    durationMinutes: 15,
  ),
  status: 'active',
  location: UserLocation(
    latitude: userLat,
    longitude: userLng,
    distanceToZone: distanceMeters,
  ),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// 3. Guardar con transacción atómica
try {
  final reservationId = await firestoreService.createReservation(reservation);
  await firestoreService.reserveSpotTransaction(spotId, userId, reservationId);
  print('Reserva creada: $reservationId');
} catch (e) {
  print('Error: $e');
}
```

---

## 📱 Plataformas

### Ejecutar por Plataforma

```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# Linux Desktop (sin Firebase)
flutter run -d linux

# Windows Desktop (sin Firebase)
flutter run -d windows
```

---

## 🎨 Convenciones de Código

### Nomenclatura
- **Archivos**: `snake_case.dart`
- **Clases**: `PascalCase`
- **Variables**: `camelCase`
- **Constantes**: `UPPER_CASE`
- **Privados**: Prefijo `_`

### Estructura de Archivo

```dart
// 1. Imports de Flutter
import 'package:flutter/material.dart';

// 2. Imports de paquetes externos
import 'package:provider/provider.dart';

// 3. Imports locales
import '../models/user_model.dart';

// 4. Clase principal
class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

// 5. Estado privado
class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
```

---

## 🔧 Solución de Problemas

### Firebase no inicializa
```bash
flutter clean
flutter pub get
flutterfire configure
```

### Error PERMISSION_DENIED en Firestore
```bash
firebase deploy --only firestore:rules
```

### Web no carga
- Verifica scripts de Firebase en `web/index.html`
- Abre consola del navegador (F12) para ver errores
- Revisa `firebase_options.dart`

---

## 📚 Recursos

- [Documentación Flutter](https://docs.flutter.dev/)
- [Firebase para Flutter](https://firebase.flutter.dev/)
- [Provider Pattern](https://pub.dev/packages/provider)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)

---

## 🚀 Roadmap

- [x] Configuración de Firebase
- [x] Estructura de base de datos
- [x] Modelos de datos
- [x] Servicios de Firestore
- [ ] Implementar Providers
- [ ] Diseño de UI/UX
- [ ] Sistema de autenticación
- [ ] Sistema de reservas
- [ ] Notificaciones push
- [ ] Tests unitarios
- [ ] Tests de integración

---

## 👥 Equipo de Desarrollo

Proyecto desarrollado como parte del curso de Construcción de Software - UNSA

---

## 📄 Licencia

Este proyecto es parte de un trabajo académico de la Universidad Nacional de San Agustín.
