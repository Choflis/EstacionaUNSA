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

### ✅ `parking_provider.dart`
**Estado de espacios y zonas de estacionamiento**
- Maneja listas de zonas y espacios de estacionamiento
- Carga zonas y espacios desde Firestore
- Filtra espacios por disponibilidad y tipo
- Actualiza estados de espacios (disponible, ocupado, reservado)
- Proporciona streams en tiempo real
- Propiedades:
  - `zones` - Lista de zonas de estacionamiento
  - `spots` - Lista de espacios de estacionamiento
  - `selectedZone` - Zona actualmente seleccionada
  - `selectedSpot` - Espacio actualmente seleccionado
  - `availableSpots` - Espacios disponibles
  - `availableSpotsCount` - Contador de espacios disponibles
- Métodos:
  - `loadZones()` - Cargar todas las zonas
  - `loadSpotsByZone(zoneId)` - Cargar espacios de una zona
  - `selectZone(zoneId)` - Seleccionar una zona
  - `updateSpotStatus(spotId, status)` - Actualizar estado de espacio
  - `getZoneStatistics(zoneId)` - Obtener estadísticas de zona

### ✅ `reservation_provider.dart`
**Estado de reservas del usuario**
- Gestiona reservas activas e historial
- Crea nuevas reservas con validaciones
- Cancela y expira reservas
- Actualiza estados de espacios al reservar/cancelar
- Validaciones:
  - Solo 1 reserva activa por usuario
  - Verificación de disponibilidad del espacio
  - Manejo automático de expiración
- Propiedades:
  - `activeReservations` - Reservas activas del usuario
  - `reservationHistory` - Historial de reservas
  - `currentReservation` - Reserva actual activa
  - `hasActiveReservation` - Si tiene reserva activa
  - `currentReservationRemainingTime` - Tiempo restante
- Métodos:
  - `createReservation()` - Crear nueva reserva
  - `cancelReservation()` - Cancelar reserva
  - `useReservation()` - Marcar reserva como usada
  - `validateReservation()` - Validar si puede reservar
  - `checkAndExpireReservations()` - Verificar expiración

### ✅ `notification_provider.dart`
**Estado de notificaciones de la aplicación**
- Gestiona notificaciones in-app
- Configurable para notificaciones push (FCM)
- Tipos de notificación:
  - Reserva confirmada
  - Reserva por expirar
  - Reserva expirada
  - Reserva cancelada
  - Espacio disponible
  - Mensajes del sistema
- Propiedades:
  - `notifications` - Lista de notificaciones
  - `unreadNotifications` - Notificaciones no leídas
  - `unreadCount` - Contador de no leídas
  - `pushNotificationsEnabled` - Configuración de push
  - `reservationRemindersEnabled` - Recordatorios activos
- Métodos:
  - `addNotification()` - Agregar notificación
  - `markAsRead()` - Marcar como leída
  - `notifyReservationConfirmed()` - Notificar reserva
  - `notifyReservationExpiring()` - Notificar expiración
  - `togglePushNotifications()` - Configurar notificaciones

---

Cada provider:
- Extiende de `ChangeNotifier`
- Maneja el estado de una funcionalidad específica
- Expone métodos para modificar el estado
- Llama a `notifyListeners()` cuando hay cambios
- Usa services para comunicarse con Firebase
- Implementa manejo de errores robusto
- Proporciona streams para actualizaciones en tiempo real
