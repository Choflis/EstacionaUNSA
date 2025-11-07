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

## Archivos pendientes:
- `messaging_service.dart` - Firebase Cloud Messaging (notificaciones push)
- `storage_service.dart` - Firebase Storage (si se necesita subir archivos)

Estos servicios:
- Encapsulan la lógica de Firebase
- NO manejan estado (solo operaciones)
- Retornan Futures o Streams
- Manejan errores y los propagan
