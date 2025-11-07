# Providers

Gestión de estado global usando el patrón Provider.

## Archivos implementados:

### ✅ `auth_provider.dart` 
**Estado de autenticación y usuario actual**
- Maneja el estado de autenticación global
- Escucha cambios en FirebaseAuth (`authStateChanges`)
- Carga datos del usuario desde Firestore automáticamente
- Expone métodos:
  - `signInWithGoogle()` - Iniciar sesión con Google
  - `signOut()` - Cerrar sesión
  - `refreshUserData()` - Refrescar datos del usuario
  - `clearError()` - Limpiar mensajes de error
- Propiedades:
  - `currentUserData` - Datos completos del usuario desde Firestore
  - `firebaseUser` - Usuario de Firebase Auth
  - `isAuthenticated` - Si el usuario está autenticado
  - `isLoading` - Estado de carga
  - `errorMessage` - Mensaje de error si hay alguno
  - `userRole` - Rol del usuario (user, admin, security)
  - `isAdmin`, `isSecurity`, `isUser` - Helpers para verificar roles

## Archivos pendientes:
- `parking_provider.dart` - Estado de espacios de estacionamiento
- `reservation_provider.dart` - Estado de reservas
- `notification_provider.dart` - Estado de notificaciones

Cada provider:
- Extiende de `ChangeNotifier`
- Maneja el estado de una funcionalidad específica
- Expone métodos para modificar el estado
- Llama a `notifyListeners()` cuando hay cambios
- Usa services para comunicarse con Firebase
