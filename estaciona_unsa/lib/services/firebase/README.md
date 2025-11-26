# Services - Firebase

Servicios que interactúan directamente con Firebase.

## Archivos implementados:

### ✅ `auth_service.dart`
**Autenticación con Firebase Auth y Google Sign-In**
- `signInWithGoogle()` - Login con Google (valida @unsa.edu.pe)
- `signOut()` - Cerrar sesión en Firebase y Google
- `authStateChanges` - Stream del estado de autenticación
- `currentUser` - Usuario actual de Firebase
- `isAuthenticated()` - Verificar si está autenticado
- `getCurrentUserData()` - Obtener datos del usuario desde Firestore
- `getCurrentUserDataStream()` - Stream de datos del usuario
- Crea/actualiza usuario en Firestore automáticamente al login

### ✅ `firestore_service.dart`
**CRUD a Cloud Firestore**
- Operaciones CRUD completas para todas las colecciones
- Métodos helper y transacciones atómicas
- Streams en tiempo real

### ✅ `messaging_service.dart`
**Firebase Cloud Messaging - Notificaciones Push**
- Gestiona notificaciones push de Firebase
- Solicita y maneja permisos
- Obtiene y refresca tokens FCM
- Configuración de notificaciones locales
- Suscripción a topics (zonas, roles, general)
- Métodos:
  - `initialize()` - Inicializar FCM y permisos
  - `subscribeToTopic(topic)` - Suscribirse a topic
  - `subscribeToZone(zoneId)` - Notificaciones de zona
  - `subscribeByRole(role)` - Notificaciones por rol
  - `sendTokenToServer(userId)` - Enviar token al backend
  - `deleteToken()` - Eliminar token FCM
- Handlers:
  - Mensajes en primer plano (app abierta)
  - Mensajes en segundo plano (app cerrada)
  - Tap en notificaciones
- **NOTA**: Requiere configuración adicional (ver comentarios en archivo)

---

## Archivos opcionales:
- `storage_service.dart` - Firebase Storage (si se necesita subir archivos/imágenes)
- `analytics_service.dart` - Firebase Analytics (métricas y eventos)

Estos servicios:
- Encapsulan la lógica de Firebase
- NO manejan estado (solo operaciones)
- Retornan Futures o Streams
- Manejan errores y los propagan
- Son singleton para evitar múltiples instancias
