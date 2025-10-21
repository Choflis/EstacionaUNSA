# 📁 Estructura del Proyecto EstacionaUNSA

## 🎯 Arquitectura: Clean Architecture + Provider

Este proyecto sigue una arquitectura limpia y escalable, separando las responsabilidades en capas bien definidas.

## 📂 Estructura de Carpetas

```
lib/
├── main.dart                          # Punto de entrada de la aplicación
│
├── config/                            # 🔧 Configuraciones globales
│   ├── theme.dart                     # Temas, colores, estilos
│   ├── routes.dart                    # Rutas de navegación
│   └── constants.dart                 # Constantes de la app
│
├── models/                            # 📊 Modelos de datos
│   ├── user_model.dart                # Usuario
│   ├── parking_spot_model.dart        # Espacio de estacionamiento
│   ├── parking_zone_model.dart        # Zona de estacionamiento
│   ├── reservation_model.dart         # Reserva
│   └── notification_model.dart        # Notificación
│
├── providers/                         # 🔄 Gestión de estado (Provider)
│   ├── auth_provider.dart             # Estado de autenticación
│   ├── parking_provider.dart          # Estado de estacionamientos
│   ├── reservation_provider.dart      # Estado de reservas
│   └── notification_provider.dart     # Estado de notificaciones
│
├── services/                          # ⚙️ Lógica de negocio
│   └── firebase/                      # Servicios de Firebase
│       ├── auth_service.dart          # Autenticación
│       ├── firestore_service.dart     # Base de datos
│       ├── messaging_service.dart     # Notificaciones push
│       └── storage_service.dart       # Almacenamiento
│
├── screens/                           # 📱 Pantallas de la app
│   ├── auth/                          # Autenticación
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── home/                          # Dashboard
│   │   └── home_screen.dart
│   ├── parking/                       # Estacionamiento
│   │   ├── parking_list_screen.dart
│   │   ├── parking_detail_screen.dart
│   │   └── parking_map_screen.dart
│   └── profile/                       # Perfil
│       ├── profile_screen.dart
│       ├── edit_profile_screen.dart
│       └── reservations_history_screen.dart
│
├── widgets/                           # 🧩 Widgets reutilizables
│   ├── common/                        # Widgets comunes
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── loading_indicator.dart
│   │   └── error_message.dart
│   ├── parking/                       # Widgets de estacionamiento
│   │   ├── parking_card.dart
│   │   ├── spot_indicator.dart
│   │   └── zone_selector.dart
│   └── profile/                       # Widgets de perfil
│       ├── profile_avatar.dart
│       └── reservation_item.dart
│
└── utils/                             # 🛠️ Utilidades
    ├── validators.dart                # Validaciones
    ├── date_formatter.dart            # Formato de fechas
    ├── app_colors.dart                # Paleta de colores
    └── helpers.dart                   # Funciones auxiliares
```

## 🔄 Flujo de Datos

```
┌─────────────────────────────────────────────────────────────┐
│                    USUARIO INTERACTÚA                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    SCREENS (Pantallas)                       │
│  Renderiza UI y captura eventos del usuario                 │
│  • login_screen.dart                                        │
│  • home_screen.dart                                         │
│  • parking_list_screen.dart                                 │
└────────────────────────┬────────────────────────────────────┘
                         │ consume estado
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              PROVIDERS (Gestión de Estado)                   │
│  Maneja el estado global de la aplicación                   │
│  • AuthProvider                                             │
│  • ParkingProvider                                          │
│  • ReservationProvider                                      │
│  Usa ChangeNotifier + notifyListeners()                     │
└────────────────────────┬────────────────────────────────────┘
                         │ llama a servicios
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              SERVICES (Lógica de Negocio)                    │
│  Encapsula la comunicación con backend                      │
│  • AuthService: login(), register()                         │
│  • FirestoreService: CRUD operations                        │
│  • MessagingService: notificaciones                         │
└────────────────────────┬────────────────────────────────────┘
                         │ se comunica con
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                  FIREBASE (Backend)                          │
│  • Firebase Auth: Autenticación                             │
│  • Cloud Firestore: Base de datos                           │
│  • Firebase Messaging: Push notifications                   │
└─────────────────────────────────────────────────────────────┘
```

## 📝 Convenciones y Buenas Prácticas

### Nomenclatura
- **Archivos**: `snake_case.dart` (ejemplo: `parking_list_screen.dart`)
- **Clases**: `PascalCase` (ejemplo: `ParkingListScreen`)
- **Variables**: `camelCase` (ejemplo: `currentUser`)
- **Constantes**: `UPPER_CASE` (ejemplo: `MAX_RESERVATIONS`)
- **Privados**: Prefijo `_` (ejemplo: `_loadData()`)

### Estructura de Archivos
```dart
// Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Modelos y servicios propios
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

// Clase principal
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Estado privado
class _LoginScreenState extends State<LoginScreen> {
  // Variables de estado
  
  // Métodos del ciclo de vida
  
  // Métodos auxiliares
  
  // Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI
    );
  }
}
```

### Providers
- Un provider por funcionalidad principal
- Extienden `ChangeNotifier`
- Métodos asíncronos con manejo de loading y errores
- Llamar `notifyListeners()` después de cambios

### Services
- Funciones puras sin estado
- Retornan `Future<T>` o `Stream<T>`
- Manejar y propagar errores
- Un servicio por backend/API

### Widgets
- Widgets pequeños y reutilizables
- Usar `const` cuando sea posible
- Extraer widgets repetidos
- Separar lógica de UI

## 🚀 Siguientes Pasos

1. **Configurar Firebase** (Fase 1)
   - Crear proyecto en Firebase Console
   - Ejecutar `flutterfire configure`
   - Configurar dependencias

2. **Implementar Autenticación** (Fase 2)
   - Crear `UserModel`
   - Implementar `AuthService`
   - Crear `AuthProvider`
   - Diseñar pantallas de login/register

3. **Base de Datos** (Fase 3)
   - Diseñar estructura Firestore
   - Crear modelos de datos
   - Implementar `FirestoreService`

4. **UI Principal** (Fase 4)
   - HomeScreen con navegación
   - Lista de espacios
   - Detalle de espacios

5. **Funcionalidades Core** (Fase 5)
   - Sistema de reservas
   - Disponibilidad en tiempo real
   - Historial
