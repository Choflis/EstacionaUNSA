# 🗺️ ROADMAP DE DESARROLLO - ESTACIONA UNSA

> **📅 Última actualización:** Noviembre 7, 2024  
> **🎯 Progreso actual:** 5 de 8 fases completadas (62.5%)  
> **✅ Estado:** Fase 6 en progreso - Sistema de reservas

---

## 📅 CRONOGRAMA SUGERIDO (3-4 Semanas)

```
SEMANA 1: Fundamentos y Configuración
├─ Día 1-2: Estudiar Flutter y Firebase
├─ Día 3-4: Configurar Firebase + Estructura de carpetas
└─ Día 5-7: Implementar Autenticación completa

SEMANA 2: Base de Datos y UI Básica
├─ Día 8-10: Diseñar e implementar Firestore
├─ Día 11-12: Crear modelos de datos
└─ Día 13-14: Pantallas principales (Home, List)

SEMANA 3: Funcionalidades Core
├─ Día 15-17: Sistema de reservas
├─ Día 18-19: Disponibilidad en tiempo real
└─ Día 20-21: Historial y perfil

SEMANA 4: Pulido y Testing
├─ Día 22-24: Notificaciones push
├─ Día 25-26: Testing y manejo de errores
└─ Día 27-28: Documentación y deployment
```

---

## 🎯 CHECKLIST COMPLETO

### FASE 0: PREPARACIÓN (Ya completado ✅)

- [x] Instalar Flutter
- [x] Conectar dispositivo físico
- [x] Crear proyecto Flutter
- [x] Ejecutar app demo en celular
- [x] Entender Hot Reload
- [x] Leer guías de desarrollo

---

### FASE 1: CONFIGURACIÓN DE FIREBASE (2-3 días) ✅ COMPLETADO

#### Día 1: Crear Proyecto Firebase
- [x] Ir a https://console.firebase.google.com
- [x] Crear proyecto "EstacionaUNSA"
- [x] Habilitar Google Analytics
- [x] Agregar app Android y Web
- [x] Descargar google-services.json

#### Día 2: Configurar en Flutter
- [x] Instalar Firebase CLI: `dart pub global activate flutterfire_cli`
- [x] Ejecutar: `flutterfire configure`
- [x] Verificar que se creó `lib/firebase_options.dart`
- [x] Modificar `main.dart` para inicializar Firebase
- [x] Ejecutar test de conexión
- [x] Configurar soporte web adicional
- [x] Cloud Functions configurado

#### Verificación:
```bash
cd estaciona_unsa
flutter run
# La app debe iniciar sin errores de Firebase
```

**Código de verificación:**
```dart
// Agregar en main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase inicializado correctamente');
  runApp(MyApp());
}
```

---

### FASE 2: ESTRUCTURA DEL PROYECTO (1 día) ✅ COMPLETADO

#### Crear estructura de carpetas
```bash
cd lib
mkdir -p config models providers services/firebase screens/auth screens/home screens/parking screens/profile widgets/common widgets/parking utils
```

**Checklist de carpetas:**
- [x] lib/config/
- [x] lib/models/
- [x] lib/providers/
- [x] lib/services/firebase/
- [x] lib/screens/auth/
- [x] lib/screens/home/
- [x] lib/screens/parking/
- [x] lib/screens/profile/
- [x] lib/widgets/common/
- [x] lib/widgets/parking/
- [x] lib/utils/

**Archivos adicionales creados:**
- [x] firestore.rules (reglas de seguridad)
- [x] functions/ (Cloud Functions)
- [x] Documentación completa de arquitectura

---

### FASE 3: AUTENTICACIÓN (3-4 días) ✅ COMPLETADO

#### Día 3: Modelos y Servicios

**1. Crear UserModel**
- [x] Crear `lib/models/user_model.dart`
- [x] Implementar `fromMap()` y `toMap()`
- [x] Agregar validaciones básicas
- [x] Soporte para múltiples roles

**2. Crear AuthService**
- [x] Crear `lib/services/firebase/auth_service.dart`
- [x] Implementar `register()`
- [x] Implementar `login()`
- [x] Implementar `logout()`
- [x] Implementar `authStateChanges` stream
- [x] **Implementar Google Sign-In**
- [x] **Soporte multi-plataforma (Android + Web)**

**Archivo:** `lib/models/user_model.dart`
```dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? carPlate;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.carPlate,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      carPlate: map['carPlate'],
      role: map['role'] ?? 'student',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'carPlate': carPlate,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
```

#### Día 4: Provider

**Crear AuthProvider**
- [x] Crear `lib/providers/auth_provider.dart`
- [x] Implementar ChangeNotifier
- [x] Agregar métodos login/logout/register
- [x] Implementar estados de loading y error
- [x] **Refactorización con arquitectura Services + Providers**
- [x] Manejo robusto de errores

**Mejoras implementadas:**
- [x] Separación clara de responsabilidades
- [x] Estado global de autenticación
- [x] Sincronización automática con Firebase
- [x] Cloud Function para creación automática de usuarios en Firestore

**Archivo:** `lib/providers/auth_provider.dart`
```dart
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

  // Constructor: Escucha cambios de autenticación
  AuthProvider() {
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

  // Métodos (implementar según GUIA_DESARROLLO_FLUTTER.md)
  Future<bool> login(String email, String password) async { /* ... */ }
  Future<bool> register(String email, String password, String name) async { /* ... */ }
  Future<void> logout() async { /* ... */ }
}
```

#### Día 5-6: Pantallas de UI

**1. Login Screen**
- [x] Crear `lib/screens/login_screen.dart`
- [x] Diseñar formulario (email + password)
- [x] Agregar validaciones
- [x] Conectar con AuthProvider
- [x] Mostrar errores/loading
- [x] **Diseño mejorado con UI moderna**
- [x] **Botón de Google Sign-In integrado**

**2. Register Screen**
- [x] Formulario básico implementado
- [x] Validaciones
- [x] Conexión con AuthProvider

**3. Configurar Provider en main.dart**
- [x] Envolver app con MultiProvider
- [x] Agregar AuthProvider
- [x] **AuthWrapper para manejo automático de sesiones**

#### Día 7: Testing de Autenticación
- [x] Probar registro de usuario nuevo
- [x] Probar login con usuario existente
- [x] Probar Google Sign-In (Android + Web)
- [x] Probar logout
- [x] Verificar persistencia (cerrar y abrir app)
- [x] Verificar datos en Firebase Console
- [x] **Probar permisos y SHA en Android**
- [x] **Verificar Cloud Functions**

**Archivo:** `lib/main.dart`
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
    
    if (authProvider.isAuthenticated) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
```

---

### FASE 4: FIRESTORE - ESTRUCTURA DE DATOS (2-3 días) ✅ COMPLETADO

#### Día 8: Configurar Firestore

**1. En Firebase Console:**
- [x] Firestore Database → Crear base de datos
- [x] Modo: "Comenzar en modo de prueba" (luego actualizado con reglas)
- [x] Ubicación: us-central1
- [x] **Reglas de seguridad personalizadas implementadas**

**2. Crear Colecciones Base:**
- [x] users (creación automática con Cloud Functions)
- [x] campuses (multi-campus implementado)
- [x] parking_zones
- [x] parking_spots
- [x] reservations
- [x] incidents
- [x] entry_exit_logs
- [x] **Script de seed para datos de prueba**

#### Día 9: Modelos de Datos

**Crear modelos:**
- [x] `lib/models/parking_zone_model.dart`
- [x] `lib/models/parking_spot_model.dart`
- [x] `lib/models/reservation_model.dart`
- [x] `lib/models/user_model.dart`
- [x] **`lib/models/campus_model.dart` (multi-campus)**
- [x] **`lib/models/incident_model.dart`**
- [x] **`lib/models/entry_exit_log_model.dart`**

**Características implementadas:**
- [x] Métodos `fromMap()` y `toMap()` completos
- [x] Validaciones de datos
- [x] Soporte para timestamps
- [x] GeoPoint para ubicaciones
- [x] Relaciones entre modelos
- [x] **Arquitectura escalable multi-campus**

**Estructura de ParkingSpotModel:**
```dart
class ParkingSpot {
  final String id;
  final String spotNumber;
  final String zoneId;
  final String zoneName;
  final bool isOccupied;
  final bool isReserved;
  final String? currentUserId;
  final String status; // 'available', 'occupied', 'reserved'
  final int floor;
  final GeoPoint location;
  final DateTime updatedAt;

  ParkingSpot({
    required this.id,
    required this.spotNumber,
    required this.zoneId,
    required this.zoneName,
    this.isOccupied = false,
    this.isReserved = false,
    this.currentUserId,
    required this.status,
    required this.floor,
    required this.location,
    required this.updatedAt,
  });

  factory ParkingSpot.fromMap(Map<String, dynamic> map, String id) {
    return ParkingSpot(
      id: id,
      spotNumber: map['spotNumber'] ?? '',
      zoneId: map['zoneId'] ?? '',
      zoneName: map['zoneName'] ?? '',
      isOccupied: map['isOccupied'] ?? false,
      isReserved: map['isReserved'] ?? false,
      currentUserId: map['currentUserId'],
      status: map['status'] ?? 'available',
      floor: map['floor'] ?? 1,
      location: map['location'] ?? GeoPoint(0, 0),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'spotNumber': spotNumber,
      'zoneId': zoneId,
      'zoneName': zoneName,
      'isOccupied': isOccupied,
      'isReserved': isReserved,
      'currentUserId': currentUserId,
      'status': status,
      'floor': floor,
      'location': location,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
```

#### Día 10: FirestoreService

**Crear servicio:**
- [x] `lib/services/firebase/firestore_service.dart`
- [x] Implementar CRUD para parking_spots
- [x] Implementar CRUD para reservations
- [x] Agregar listeners en tiempo real
- [x] **Implementar operaciones para campuses**
- [x] **Implementar operaciones para zones**
- [x] **Seed script completo con datos de prueba**

**Métodos implementados:**
- [x] Obtener espacios disponibles (Stream en tiempo real)
- [x] Obtener espacios por zona
- [x] Crear/actualizar reservas
- [x] Cancelar reservas
- [x] Obtener reservas del usuario
- [x] Operaciones CRUD completas
- [x] **Queries optimizadas con índices**
- [x] **Manejo de transacciones**

---

### FASE 5: UI PRINCIPAL (4-5 días) ✅ COMPLETADO

#### Día 11-12: HomeScreen

**Crear pantalla principal:**
- [x] `lib/screens/home_screen.dart`
- [x] Diseñar AppBar con logo
- [x] Agregar BottomNavigationBar
- [x] Mostrar estadísticas básicas
- [x] Botón para ver espacios disponibles
- [x] **Integración con MainNavScreen**
- [x] **Diseño responsive y moderno**

**Estructura implementada:**
- [x] MainNavScreen con navegación inferior
- [x] DashboardPage (vista general)
- [x] ParkingListPage (lista de espacios)
- [x] MyReservationsPage (mis reservas)
- [x] ProfilePage (perfil)
- [x] **HistoryScreen**
- [x] **MyVehicleScreen**
- [x] **MapScreen**

#### Día 13-14: ParkingListScreen

**Crear lista de espacios:**
- [x] `lib/widgets/parking/parking_list_screen.dart`
- [x] Mostrar espacios en tiempo real (StreamBuilder)
- [x] Filtros por zona
- [x] Indicadores de disponibilidad
- [x] Navegación a detalle
- [x] **Diseño con cards responsive**

**Widget Card reutilizable:**
- [x] `lib/widgets/parking/parking_card.dart`
- [x] Mostrar número, zona, estado
- [x] Botón "Reservar"
- [x] **Indicadores visuales de estado**
- [x] **Animaciones y transiciones**

**Widgets comunes implementados:**
- [x] `lib/widgets/common/custom_button.dart`
- [x] `lib/widgets/common/custom_text_field.dart`
- [x] `lib/widgets/common/loading_indicator.dart`

#### Día 15: ParkingDetailScreen

**Crear detalle del espacio:**
- [x] Mostrar información completa
- [x] Formulario de reserva (fecha/hora)
- [x] Botón de confirmación
- 🔄 Mapa de ubicación (en progreso)
- 🔄 Integración completa con reservas

---

### FASE 6: SISTEMA DE RESERVAS (3-4 días) 🔄 EN PROGRESO

#### Día 16-17: Lógica de Reservas

**Provider:**
- [x] Modelo de reserva completo
- 🔄 `lib/providers/reservation_provider.dart` (en desarrollo)
- ⬜ Crear reserva
- ⬜ Listar reservas activas
- ⬜ Cancelar reserva
- ⬜ Historial de reservas

**Validaciones:**
- ⬜ Usuario solo puede tener 1 reserva activa
- ⬜ Horario válido (no pasado)
- ⬜ Espacio disponible
- ⬜ Duración máxima (configurable)

#### Día 18: UI de Reservas

**Pantallas:**
- ⬜ Formulario de nueva reserva
- ⬜ Lista de mis reservas
- ⬜ Detalle de reserva
- ⬜ Confirmación de cancelación

#### Día 19: Disponibilidad en Tiempo Real

**Implementar:**
- ⬜ Actualizar estado del espacio al reservar
- ⬜ Liberar espacio al cancelar/completar
- ⬜ Actualizar contador de espacios disponibles
- ⬜ Notificar cambios a todos los usuarios conectados

---

### FASE 7: NOTIFICACIONES PUSH (2-3 días)

#### Día 20-21: Firebase Cloud Messaging

**Configuración:**
- [ ] Habilitar FCM en Firebase Console
- [ ] Configurar Android (google-services.json)
- [ ] Crear `lib/services/firebase/messaging_service.dart`
- [ ] Solicitar permisos de notificaciones

**Tipos de notificaciones:**
- [ ] Reserva confirmada
- [ ] Recordatorio (15 min antes)
- [ ] Liberación de espacio
- [ ] Reserva por expirar

---

### FASE 8: PULIDO Y TESTING (3-4 días)

#### Día 22-23: Manejo de Errores

- [ ] Try-catch en todos los servicios
- [ ] Mensajes de error amigables
- [ ] Loading indicators
- [ ] Validaciones de formularios
- [ ] Manejo de conexión perdida

#### Día 24: Testing

- [ ] Probar flujo completo de registro
- [ ] Probar crear/cancelar reserva
- [ ] Probar con múltiples usuarios simultáneos
- [ ] Probar offline/online
- [ ] Probar notificaciones

#### Día 25: Optimización

- [ ] Revisar reglas de seguridad Firestore
- [ ] Optimizar consultas (índices)
- [ ] Caché de datos
- [ ] Reducir rebuilds innecesarios

#### Día 26: Documentación

- [ ] README.md completo
- [ ] Comentarios en código crítico
- [ ] Guía de instalación
- [ ] Screenshots de la app

---

## 🎨 EXTRAS OPCIONALES (Si tienes más tiempo)

### Funcionalidades Avanzadas
- [ ] Mapa interactivo con Google Maps
- [ ] Búsqueda por placa de vehículo
- [ ] Estadísticas de uso
- [ ] Modo oscuro (Dark Theme)
- [ ] Favoritos/Espacios frecuentes
- [ ] Pago integrado (opcional)
- [ ] Código QR para check-in
- [ ] Panel de administrador

### Mejoras de UI/UX
- [ ] Animaciones
- [ ] Skeleton loaders
- [ ] Pull to refresh
- [ ] Splash screen personalizada
- [ ] Onboarding tutorial

---

## 📊 PROGRESO TRACKING

Usa esta tabla para marcar tu progreso:

| Fase | Descripción | Días | Estado |
|------|-------------|------|--------|
| 0 | Preparación | - | ✅ |
| 1 | Firebase Config | 2-3 | ✅ |
| 2 | Estructura | 1 | ✅ |
| 3 | Autenticación | 3-4 | ✅ |
| 4 | Firestore | 2-3 | ✅ |
| 5 | UI Principal | 4-5 | ✅ |
| 6 | Reservas | 3-4 | 🔄 |
| 7 | Notificaciones | 2-3 | ⬜ |
| 8 | Testing | 3-4 | 🔄 |

**Símbolos:**
- ⬜ Por hacer
- 🔄 En progreso
- ✅ Completado
- ❌ Bloqueado

---

## 📈 RESUMEN DE AVANCE

**📊 Métricas del Proyecto:**
- **Archivos Dart:** 27 archivos
- **Commits:** 43+ commits
- **Tiempo invertido:** ~2-3 semanas
- **Líneas de código:** 2000+ líneas (aprox.)
- **Cobertura:** 5 de 8 fases completadas

### ✅ Completado (Fases 0-5)

#### FASE 0: Preparación
- ✅ Flutter instalado y configurado
- ✅ Proyecto creado y ejecutando
- ✅ Dispositivos de prueba configurados
- ✅ Git inicializado con commits frecuentes

#### FASE 1: Firebase Configurado
- ✅ Proyecto Firebase creado
- ✅ Firebase CLI configurado
- ✅ Google Sign-In implementado
- ✅ Autenticación web y Android funcionando
- ✅ Cloud Functions para creación automática de usuarios

#### FASE 2: Estructura del Proyecto
- ✅ Arquitectura limpia implementada (Services + Providers)
- ✅ Carpetas organizadas (models, services, screens, widgets, providers)
- ✅ Documentación completa de estructura

#### FASE 3: Autenticación Completa
- ✅ AuthService implementado
- ✅ AuthProvider con ChangeNotifier
- ✅ Login Screen con diseño mejorado
- ✅ Google Sign-In integrado
- ✅ AuthWrapper para manejo de sesiones
- ✅ Persistencia de sesión
- ✅ Manejo de errores robusto

#### FASE 4: Firestore Implementado
- ✅ Base de datos Firestore configurada
- ✅ Modelos de datos completos:
  - ✅ UserModel
  - ✅ ParkingSpotModel
  - ✅ ParkingZoneModel
  - ✅ ReservationModel
  - ✅ CampusModel (multi-campus)
  - ✅ IncidentModel
  - ✅ EntryExitLogModel
- ✅ FirestoreService implementado
- ✅ Script de seed para datos de prueba
- ✅ Reglas de seguridad Firestore configuradas
- ✅ Arquitectura multi-campus escalable

#### FASE 5: UI Principal
- ✅ HomeScreen diseñado
- ✅ MainNavScreen con navegación inferior
- ✅ ProfileScreen implementado
- ✅ ParkingListScreen básico
- ✅ MapScreen iniciado
- ✅ HistoryScreen
- ✅ MyVehicleScreen
- ✅ Widgets comunes:
  - ✅ CustomButton
  - ✅ CustomTextField
  - ✅ LoadingIndicator
  - ✅ ParkingCard
- ✅ Tema personalizado configurado

### 🔄 En Progreso (Fase 6)

#### FASE 6: Sistema de Reservas
- ✅ Modelos de reserva creados
- 🔄 ReservationProvider en desarrollo
- 🔄 Lógica de validaciones
- ⬜ UI de reservas completa
- ⬜ Integración con disponibilidad en tiempo real

### ⬜ Pendiente (Fases 7-8)

#### FASE 7: Notificaciones
- ⬜ Firebase Cloud Messaging
- ⬜ Configuración de permisos
- ⬜ Tipos de notificaciones
- ⬜ Recordatorios automáticos

#### FASE 8: Testing y Optimización
- 🔄 Pruebas manuales continuas
- ⬜ Testing automatizado
- ⬜ Optimización de consultas
- ⬜ Documentación final

---

## 🎯 LOGROS DESTACADOS

### Arquitectura Escalable
- ✅ **Multi-campus**: Sistema preparado para múltiples campus universitarios
- ✅ **Clean Architecture**: Separación clara entre servicios, providers y UI
- ✅ **Cloud Functions**: Automatización de creación de usuarios
- ✅ **Seguridad**: Reglas de Firestore robustas implementadas

### Funcionalidades Implementadas
- ✅ Autenticación con Google (Web + Android)
- ✅ Gestión de perfiles de usuario
- ✅ Base de datos multi-campus
- ✅ Navegación fluida entre pantallas
- ✅ Diseño responsive y moderno
- ✅ Seed script para datos de prueba

### Documentación
- ✅ README completo con arquitectura
- ✅ Guías de configuración para el equipo
- ✅ Diseño de base de datos documentado
- ✅ Diseño de menú y navegación
- ✅ Firestore rules documentadas

---

## 📋 PRÓXIMOS PASOS INMEDIATOS

### Prioridad Alta (Esta semana)
1. **Completar Sistema de Reservas**
   - Implementar ReservationProvider completo
   - Crear UI de formulario de reserva
   - Validaciones de horarios y disponibilidad
   - Integrar con FirestoreService

2. **Disponibilidad en Tiempo Real**
   - StreamBuilder para actualización automática
   - Sincronización entre usuarios
   - Indicadores visuales de estado

3. **Testing de Flujo Completo**
   - Probar crear/cancelar reservas
   - Validar permisos y reglas
   - Pruebas con múltiples usuarios

### Prioridad Media (Próximas 2 semanas)
1. **Notificaciones Push**
   - Configurar FCM
   - Implementar recordatorios
   - Notificaciones de liberación

2. **Optimización**
   - Revisar y optimizar consultas
   - Implementar caché donde sea necesario
   - Mejorar performance

3. **Documentación de Usuario**
   - Manual de usuario
   - Screenshots actualizados
   - Video tutorial básico

### Prioridad Baja (Futuro)
- Mapa interactivo mejorado
- Estadísticas de uso
- Panel de administrador
- Código QR para check-in

---

## 💡 CONSEJOS FINALES

1. **Commits frecuentes**: Haz commits cada vez que completes una tarea
2. **Testing continuo**: Prueba cada función antes de continuar
3. **Hot Reload es tu amigo**: Úsalo para ver cambios al instante
4. **Lee errores completos**: Flutter da errores muy descriptivos
5. **Usa Firebase Console**: Verifica datos en tiempo real
6. **No te saltes pasos**: Sigue el orden del roadmap
7. **Pregunta cuando te atasques**: Es mejor aclarar dudas temprano
8. **Documenta mientras programas**: Comentarios ayudan después

---

## 🆘 RECURSOS ÚTILES

**Documentación Oficial:**
- Flutter: https://docs.flutter.dev
- Firebase: https://firebase.google.com/docs
- Provider: https://pub.dev/packages/provider

**Videos tutoriales:**
- Flutter en español: YouTube "Flutter en español"
- Firebase + Flutter: "The Net Ninja"

**Comunidad:**
- Stack Overflow (flutter tag)
- Reddit r/FlutterDev
- Discord Flutter Community

---

**¡Éxito en tu proyecto! 🚀**

Recuerda: el desarrollo de software es iterativo. No busques la perfección en la primera versión. Haz que funcione, luego mejóralo.
