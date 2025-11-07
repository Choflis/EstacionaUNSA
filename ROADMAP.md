# 🗺️ ROADMAP DE DESARROLLO - ESTACIONA UNSA

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

### FASE 1: CONFIGURACIÓN DE FIREBASE (2-3 días)

#### Día 1: Crear Proyecto Firebase
- [ ] Ir a https://console.firebase.google.com
- [ ] Crear proyecto "EstacionaUNSA"
- [ ] Habilitar Google Analytics
- [ ] Agregar app Android
- [ ] Descargar google-services.json

#### Día 2: Configurar en Flutter
- [ ] Instalar Firebase CLI: `dart pub global activate flutterfire_cli`
- [ ] Ejecutar: `flutterfire configure`
- [ ] Verificar que se creó `lib/firebase_options.dart`
- [ ] Modificar `main.dart` para inicializar Firebase
- [ ] Ejecutar test de conexión

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

### FASE 2: ESTRUCTURA DEL PROYECTO (1 día)

#### Crear estructura de carpetas
```bash
cd lib
mkdir -p config models providers services/firebase screens/auth screens/home screens/parking screens/profile widgets/common widgets/parking utils
```

**Checklist de carpetas:**
- [ ] lib/config/
- [ ] lib/models/
- [ ] lib/providers/
- [ ] lib/services/firebase/
- [ ] lib/screens/auth/
- [ ] lib/screens/home/
- [ ] lib/screens/parking/
- [ ] lib/screens/profile/
- [ ] lib/widgets/common/
- [ ] lib/widgets/parking/
- [ ] lib/utils/

---

### FASE 3: AUTENTICACIÓN (3-4 días)

#### Día 3: Modelos y Servicios

**1. Crear UserModel**
- [ ] Crear `lib/models/user_model.dart`
- [ ] Implementar `fromMap()` y `toMap()`
- [ ] Agregar validaciones básicas

**2. Crear AuthService**
- [ ] Crear `lib/services/firebase/auth_service.dart`
- [ ] Implementar `register()`
- [ ] Implementar `login()`
- [ ] Implementar `logout()`
- [ ] Implementar `authStateChanges` stream

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
- [ ] Crear `lib/providers/auth_provider.dart`
- [ ] Implementar ChangeNotifier
- [ ] Agregar métodos login/logout/register
- [ ] Implementar estados de loading y error

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
- [ ] Crear `lib/screens/auth/login_screen.dart`
- [ ] Diseñar formulario (email + password)
- [ ] Agregar validaciones
- [ ] Conectar con AuthProvider
- [ ] Mostrar errores/loading

**2. Register Screen**
- [ ] Crear `lib/screens/auth/register_screen.dart`
- [ ] Diseñar formulario (name, email, password, carPlate)
- [ ] Agregar validaciones
- [ ] Conectar con AuthProvider

**3. Configurar Provider en main.dart**
- [ ] Envolver app con MultiProvider
- [ ] Agregar AuthProvider

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

#### Día 7: Testing de Autenticación
- [ ] Probar registro de usuario nuevo
- [ ] Probar login con usuario existente
- [ ] Probar logout
- [ ] Verificar persistencia (cerrar y abrir app)
- [ ] Verificar datos en Firebase Console

---

### FASE 4: FIRESTORE - ESTRUCTURA DE DATOS (2-3 días)

#### Día 8: Configurar Firestore

**1. En Firebase Console:**
- [ ] Firestore Database → Crear base de datos
- [ ] Modo: "Comenzar en modo de prueba" (por ahora)
- [ ] Ubicación: us-central1 (o la más cercana)

**2. Crear Colecciones Base:**
```
Firestore Console → Iniciar colección

Crear manualmente:
- users (se creará automáticamente al registrarse)
- parking_zones
- parking_spots
- reservations
- notifications
```

#### Día 9: Modelos de Datos

**Crear modelos:**
- [ ] `lib/models/parking_zone_model.dart`
- [ ] `lib/models/parking_spot_model.dart`
- [ ] `lib/models/reservation_model.dart`

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
- [ ] `lib/services/firebase/firestore_service.dart`
- [ ] Implementar CRUD para parking_spots
- [ ] Implementar CRUD para reservations
- [ ] Agregar listeners en tiempo real

**Métodos esenciales:**
```dart
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener espacios disponibles (Stream en tiempo real)
  Stream<List<ParkingSpot>> getAvailableSpots() { }
  
  // Obtener espacios por zona
  Stream<List<ParkingSpot>> getSpotsByZone(String zoneId) { }
  
  // Crear reserva
  Future<String> createReservation({
    required String userId,
    required String spotId,
    required DateTime startTime,
    required DateTime endTime,
  }) { }
  
  // Obtener reservas del usuario
  Stream<List<Reservation>> getUserReservations(String userId) { }
  
  // Cancelar reserva
  Future<void> cancelReservation(String reservationId) { }
}
```

---

### FASE 5: UI PRINCIPAL (4-5 días)

#### Día 11-12: HomeScreen

**Crear pantalla principal:**
- [ ] `lib/screens/home/home_screen.dart`
- [ ] Diseñar AppBar con logo
- [ ] Agregar BottomNavigationBar
- [ ] Mostrar estadísticas básicas
- [ ] Botón para ver espacios disponibles

**Estructura:**
```dart
class HomeScreen extends StatefulWidget { }

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    DashboardPage(),     // Vista general
    ParkingListPage(),   // Lista de espacios
    MyReservationsPage(),// Mis reservas
    ProfilePage(),       // Perfil
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EstacionaUNSA')),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.local_parking), label: 'Espacios'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Reservas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
```

#### Día 13-14: ParkingListScreen

**Crear lista de espacios:**
- [ ] `lib/screens/parking/parking_list_screen.dart`
- [ ] Mostrar espacios en tiempo real (StreamBuilder)
- [ ] Filtros por zona
- [ ] Indicadores de disponibilidad
- [ ] Navegación a detalle

**Widget Card reutilizable:**
- [ ] `lib/widgets/parking/parking_card.dart`
- [ ] Mostrar número, zona, estado
- [ ] Botón "Reservar"

#### Día 15: ParkingDetailScreen

**Crear detalle del espacio:**
- [ ] `lib/screens/parking/parking_detail_screen.dart`
- [ ] Mostrar información completa
- [ ] Mapa de ubicación
- [ ] Formulario de reserva (fecha/hora)
- [ ] Botón de confirmación

---

### FASE 6: SISTEMA DE RESERVAS (3-4 días)

#### Día 16-17: Lógica de Reservas

**Provider:**
- [ ] `lib/providers/reservation_provider.dart`
- [ ] Crear reserva
- [ ] Listar reservas activas
- [ ] Cancelar reserva
- [ ] Historial de reservas

**Validaciones:**
- [ ] Usuario solo puede tener 1 reserva activa
- [ ] Horario válido (no pasado)
- [ ] Espacio disponible
- [ ] Duración máxima (configurable)

#### Día 18: UI de Reservas

**Pantallas:**
- [ ] Formulario de nueva reserva
- [ ] Lista de mis reservas
- [ ] Detalle de reserva
- [ ] Confirmación de cancelación

#### Día 19: Disponibilidad en Tiempo Real

**Implementar:**
- [ ] Actualizar estado del espacio al reservar
- [ ] Liberar espacio al cancelar/completar
- [ ] Actualizar contador de espacios disponibles
- [ ] Notificar cambios a todos los usuarios conectados

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
| 1 | Firebase Config | 2-3 | ⬜ |
| 2 | Estructura | 1 | ⬜ |
| 3 | Autenticación | 3-4 | ⬜ |
| 4 | Firestore | 2-3 | ⬜ |
| 5 | UI Principal | 4-5 | ⬜ |
| 6 | Reservas | 3-4 | ⬜ |
| 7 | Notificaciones | 2-3 | ⬜ |
| 8 | Testing | 3-4 | ⬜ |

**Símbolos:**
- ⬜ Por hacer
- 🔄 En progreso
- ✅ Completado
- ❌ Bloqueado

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
