# CASOS DE PRUEBA BACKEND - EstacionaUNSA

**Responsable:** Fernando  
**Fecha:** 29 de Noviembre, 2024  
**Fase:** 3 - Diseño de Casos de Prueba

---

## 📊 RESUMEN

| Tipo | Cantidad | Estado |
|------|----------|--------|
| Pruebas Unitarias | 5 | Diseñadas |
| Pruebas de Integración | 3 | Diseñadas |
| **TOTAL** | **8** | **Pendientes de ejecución** |

---

# 🧪 PRUEBAS UNITARIAS

## UNIT-001: AuthService.signInWithGoogle()

| Campo | Detalle |
|-------|---------|
| **ID** | UNIT-001 |
| **Función/Módulo** | `AuthService.signInWithGoogle()` |
| **Archivo** | `lib/services/firebase/auth_service.dart` |
| **Prioridad** | Alta |
| **Severidad** | Crítica |

### Resumen
Validar el proceso de autenticación con Google, incluyendo la validación de correos institucionales @unsa.edu.pe y el manejo de errores.

### Precondiciones
- Firebase Auth configurado correctamente
- Google Sign In configurado con clientId
- Usuario no autenticado previamente
- Conexión a internet activa

### Pasos de Ejecución

1. Llamar a `AuthService.signInWithGoogle()`
2. Seleccionar cuenta de Google en el diálogo
3. Observar el proceso de autenticación
4. Verificar creación/actualización de usuario en Firestore

### Datos de Prueba

**Caso 1: Correo institucional válido**
- Email: `fernando.test@unsa.edu.pe`
- Nombre: `Fernando Test`

**Caso 2: Correo no institucional (debe fallar)**
- Email: `fernando.test@gmail.com`
- Nombre: `Fernando Test`

**Caso 3: Usuario cancela login**
- Acción: Cerrar diálogo sin seleccionar cuenta

### Resultado Esperado

**Caso 1:**
- ✅ Autenticación exitosa
- ✅ `UserCredential` retornado con datos del usuario
- ✅ Usuario creado/actualizado en Firestore collection `users`
- ✅ Documento contiene: uid, email, displayName, role='user', createdAt, updatedAt

**Caso 2:**
- ❌ Lanza `Exception` con mensaje: "Solo se permiten correos institucionales UNSA (@unsa.edu.pe)"
- ❌ Sesión de Google cerrada automáticamente
- ❌ No se crea usuario en Firestore

**Caso 3:**
- ❌ Lanza `Exception` con mensaje: "Login cancelado por el usuario"
- ❌ No se crea usuario en Firestore

### Resultado Obtenido
_[Se llenará en Fase 4]_

### Estado
⏳ Pendiente

### Notas
- Verificar que `_createOrUpdateUserInFirestore()` se ejecute correctamente
- Validar que usuarios existentes solo actualicen `updatedAt` y `photoURL`
- Verificar que nuevos usuarios tengan `role='user'` por defecto

---

## UNIT-002: FirestoreService.createReservation()

| Campo | Detalle |
|-------|---------|
| **ID** | UNIT-002 |
| **Función/Módulo** | `FirestoreService.createReservation()` |
| **Archivo** | `lib/services/firebase/firestore_service.dart` |
| **Prioridad** | Alta |
| **Severidad** | Crítica |

### Resumen
Validar la creación de documentos de reserva en Firestore con la estructura de datos correcta.

### Precondiciones
- Firestore configurado y accesible
- Usuario autenticado con uid válido
- Spot disponible en la base de datos
- Zona válida existente

### Pasos de Ejecución

1. Crear objeto `ReservationModel` con datos válidos
2. Llamar a `FirestoreService.createReservation(reservation)`
3. Verificar que retorna un ID de documento
4. Consultar Firestore para verificar que el documento existe
5. Validar estructura de datos del documento

### Datos de Prueba

```dart
ReservationModel testReservation = ReservationModel(
  userId: 'test_user_123',
  spotId: 'spot_A1',
  zoneId: 'zone_central',
  status: 'active',
  startTime: DateTime.now(),
  endTime: DateTime.now().add(Duration(hours: 2)),
  durationMinutes: 120,
  createdAt: DateTime.now(),
);
```

### Resultado Esperado

- ✅ Función retorna String con ID del documento (no vacío)
- ✅ Documento creado en collection `reservations`
- ✅ Documento contiene todos los campos del modelo:
  - `userId`: 'test_user_123'
  - `spotId`: 'spot_A1'
  - `zoneId`: 'zone_central'
  - `status`: 'active'
  - `startTime`: Timestamp válido
  - `endTime`: Timestamp válido
  - `durationMinutes`: 120
  - `createdAt`: Timestamp válido
- ✅ No lanza excepciones

### Resultado Obtenido
_[Se llenará en Fase 4]_

### Estado
⏳ Pendiente

### Notas
- Verificar que `toMap()` de `ReservationModel` funcione correctamente
- Validar que los Timestamps se conviertan correctamente
- Verificar manejo de errores si Firestore no está disponible

---

## UNIT-003: ParkingProvider.loadZones()

| Campo | Detalle |
|-------|---------|
| **ID** | UNIT-003 |
| **Función/Módulo** | `ParkingProvider.loadZones()` |
| **Archivo** | `lib/providers/parking_provider.dart` |
| **Prioridad** | Media |
| **Severidad** | Alta |

### Resumen
Validar la carga de zonas de estacionamiento desde Firestore y la actualización del estado del provider.

### Precondiciones
- Firestore contiene al menos 2 zonas de estacionamiento
- `FirestoreService` configurado correctamente
- Provider inicializado

### Pasos de Ejecución

1. Verificar estado inicial: `_isLoading = false`, `_zones = []`
2. Llamar a `loadZones()`
3. Verificar que `_isLoading = true` durante la carga
4. Esperar a que la operación complete
5. Verificar estado final: `_isLoading = false`, `_zones` contiene datos
6. Verificar que `notifyListeners()` se llamó

### Datos de Prueba

**Zonas esperadas en Firestore:**
- Zona 1: id='zone_central', name='Zona Central', totalSpots=50
- Zona 2: id='zone_norte', name='Zona Norte', totalSpots=30

### Resultado Esperado

**Caso exitoso:**
- ✅ `_isLoading = true` al inicio
- ✅ `_zones` se llena con lista de `ParkingZoneModel`
- ✅ `_zones.length >= 2`
- ✅ `_isLoading = false` al finalizar
- ✅ `_errorMessage = null`
- ✅ `notifyListeners()` llamado al menos 2 veces

**Caso con error de red:**
- ✅ `_isLoading = false` al finalizar
- ✅ `_errorMessage` contiene mensaje de error
- ✅ `_zones` permanece vacío o sin cambios
- ✅ `notifyListeners()` llamado

### Resultado Obtenido
_[Se llenará en Fase 4]_

### Estado
⏳ Pendiente

### Notas
- Simular error de red desconectando internet
- Verificar que el estado se actualiza correctamente en cada paso
- Validar que los listeners de la UI reciban notificaciones

---

## UNIT-004: ReservationProvider.validateReservation()

| Campo | Detalle |
|-------|---------|
| **ID** | UNIT-004 |
| **Función/Módulo** | `ReservationProvider.validateReservation()` |
| **Archivo** | `lib/providers/reservation_provider.dart` |
| **Prioridad** | Alta |
| **Severidad** | Crítica |

### Resumen
Validar las reglas de negocio para permitir o denegar una reserva según el estado del usuario y del spot.

### Precondiciones
- Usuario autenticado con uid válido
- Spots disponibles en Firestore
- Firestore accesible

### Pasos de Ejecución

1. Llamar a `validateReservation(userId: 'user1', spotId: 'spot1')`
2. Verificar respuesta con estructura `Map<String, dynamic>`
3. Validar campo `canReserve` (bool)
4. Validar campo `reason` (String?)

### Datos de Prueba

**Escenario 1: Usuario sin reservas activas, spot disponible**
- userId: 'user_sin_reservas'
- spotId: 'spot_disponible'
- Estado spot: `isAvailable = true`
- Reservas activas del usuario: 0

**Escenario 2: Usuario con reserva activa**
- userId: 'user_con_reserva'
- spotId: 'spot_disponible'
- Reservas activas del usuario: 1

**Escenario 3: Spot no disponible**
- userId: 'user_sin_reservas'
- spotId: 'spot_ocupado'
- Estado spot: `isAvailable = false`

**Escenario 4: Spot no existe**
- userId: 'user_sin_reservas'
- spotId: 'spot_inexistente'

### Resultado Esperado

**Escenario 1:**
```dart
{
  'canReserve': true,
  'reason': null,
}
```

**Escenario 2:**
```dart
{
  'canReserve': false,
  'reason': 'Ya tienes una reserva activa',
}
```

**Escenario 3:**
```dart
{
  'canReserve': false,
  'reason': 'El espacio no está disponible',
}
```

**Escenario 4:**
```dart
{
  'canReserve': false,
  'reason': 'El espacio no existe',
}
```

### Resultado Obtenido
_[Se llenará en Fase 4]_

### Estado
⏳ Pendiente

### Notas
- Esta función es crítica para evitar dobles reservas
- Validar que todas las reglas de negocio se cumplan
- Verificar manejo de errores de Firestore

---

## UNIT-005: UserModel.toMap() / fromMap()

| Campo | Detalle |
|-------|---------|
| **ID** | UNIT-005 |
| **Función/Módulo** | `UserModel.toMap()` y `UserModel.fromMap()` |
| **Archivo** | `lib/models/user_model.dart` |
| **Prioridad** | Media |
| **Severidad** | Media |

### Resumen
Validar la serialización y deserialización correcta del modelo de usuario para persistencia en Firestore.

### Precondiciones
- Ninguna (prueba de lógica pura)

### Pasos de Ejecución

**Test 1: toMap()**
1. Crear objeto `UserModel` con todos los campos
2. Llamar a `toMap()`
3. Verificar estructura del Map resultante
4. Validar tipos de datos

**Test 2: fromMap()**
1. Crear Map con estructura de Firestore
2. Llamar a `UserModel.fromMap(map, uid)`
3. Verificar que el objeto se crea correctamente
4. Validar que todos los campos se mapean

**Test 3: Round-trip (toMap → fromMap)**
1. Crear `UserModel` original
2. Convertir a Map con `toMap()`
3. Recrear desde Map con `fromMap()`
4. Comparar objeto original con recreado

### Datos de Prueba

```dart
UserModel testUser = UserModel(
  uid: 'test_123',
  email: 'test@unsa.edu.pe',
  displayName: 'Test User',
  role: 'user',
  vehicles: [
    VehicleInfo(
      licensePlate: 'ABC-123',
      brand: 'Toyota',
      model: 'Corolla',
      color: 'Rojo',
      isPrimary: true,
    ),
  ],
  stats: UserStats(
    totalReservations: 5,
    completedReservations: 3,
    cancelledReservations: 1,
    noShowCount: 1,
  ),
  createdAt: DateTime(2024, 1, 1),
  updatedAt: DateTime(2024, 11, 29),
  phoneNumber: '987654321',
  photoURL: 'https://example.com/photo.jpg',
  isActive: true,
);
```

### Resultado Esperado

**toMap():**
```dart
{
  'email': 'test@unsa.edu.pe',
  'displayName': 'Test User',
  'role': 'user',
  'vehicles': [
    {
      'licensePlate': 'ABC-123',
      'brand': 'Toyota',
      'model': 'Corolla',
      'color': 'Rojo',
      'isPrimary': true,
    }
  ],
  'stats': {
    'totalReservations': 5,
    'completedReservations': 3,
    'cancelledReservations': 1,
    'noShowCount': 1,
    // ... otros campos
  },
  'createdAt': Timestamp,
  'updatedAt': FieldValue.serverTimestamp(),
  'phoneNumber': '987654321',
  'photoURL': 'https://example.com/photo.jpg',
  'isActive': true,
}
```

**fromMap():**
- ✅ Objeto `UserModel` con todos los campos correctos
- ✅ Tipos de datos correctos (String, int, bool, DateTime, List)
- ✅ Timestamps convertidos a DateTime
- ✅ Listas de vehículos deserializadas correctamente
- ✅ Stats deserializados correctamente

**Round-trip:**
- ✅ `original.email == recreated.email`
- ✅ `original.displayName == recreated.displayName`
- ✅ `original.vehicles.length == recreated.vehicles.length`
- ✅ Todos los campos coinciden

### Resultado Obtenido
_[Se llenará en Fase 4]_

### Estado
⏳ Pendiente

### Notas
- Validar manejo de campos opcionales (null safety)
- Verificar conversión correcta de Timestamps
- Validar serialización de objetos anidados (VehicleInfo, UserStats)

---

# 🔗 PRUEBAS DE INTEGRACIÓN

## INT-001: AuthProvider → AuthService → Firebase

| Campo | Detalle |
|-------|---------|
| **ID** | INT-001 |
| **Componentes** | AuthProvider, AuthService, Firebase Auth, FirestoreService |
| **Prioridad** | Alta |
| **Severidad** | Crítica |

### Resumen
Validar el flujo completo de autenticación desde el Provider hasta la persistencia en Firestore, incluyendo la propagación de estado a la UI.

### Precondiciones
- Firebase Auth configurado
- Firestore configurado
- Google Sign In configurado
- Usuario no autenticado
- Conexión a internet

### Pasos de Ejecución

1. **UI:** Usuario presiona botón "Iniciar sesión con Google"
2. **AuthProvider:** Llamar a `signInWithGoogle()`
3. **AuthProvider:** Verificar que `_isLoading = true`
4. **AuthService:** Ejecutar flujo de Google Sign In
5. **AuthService:** Validar correo @unsa.edu.pe
6. **Firebase Auth:** Autenticar con credenciales de Google
7. **FirestoreService:** Crear/actualizar documento de usuario
8. **AuthProvider:** Escuchar cambio de `authStateChanges`
9. **AuthProvider:** Cargar datos del usuario desde Firestore
10. **AuthProvider:** Actualizar `_currentUserData` y `_firebaseUser`
11. **AuthProvider:** Llamar `notifyListeners()`
12. **UI:** Navegar a HomeScreen

### Datos de Prueba

- Email: `fernando.test@unsa.edu.pe`
- Nombre: `Fernando Test`
- Foto: URL de Google

### Resultado Esperado

**Flujo exitoso:**
1. ✅ `AuthProvider._isLoading = true` durante el proceso
2. ✅ Diálogo de Google Sign In se muestra
3. ✅ Usuario selecciona cuenta @unsa.edu.pe
4. ✅ `AuthService.signInWithGoogle()` retorna `UserCredential`
5. ✅ Documento creado/actualizado en Firestore `users/{uid}`:
   ```
   {
     uid: auto-generado,
     email: 'fernando.test@unsa.edu.pe',
     displayName: 'Fernando Test',
     role: 'user',
     vehicles: [],
     stats: { totalReservations: 0, ... },
     createdAt: Timestamp,
     updatedAt: Timestamp,
     photoURL: URL,
     isActive: true,
   }
   ```
6. ✅ `AuthProvider._firebaseUser` contiene datos de Firebase Auth
7. ✅ `AuthProvider._currentUserData` contiene datos de Firestore
8. ✅ `AuthProvider.isAuthenticated = true`
9. ✅ `AuthProvider._isLoading = false`
10. ✅ `AuthProvider._errorMessage = null`
11. ✅ UI recibe notificación y navega a HomeScreen
12. ✅ HomeScreen muestra nombre y foto del usuario

**Flujo con correo no institucional:**
1. ✅ Usuario selecciona cuenta @gmail.com
2. ✅ `AuthService` lanza Exception
3. ✅ Sesión de Google se cierra
4. ✅ `AuthProvider._errorMessage = "Solo se permiten correos institucionales UNSA..."`
5. ✅ `AuthProvider._isLoading = false`
6. ✅ UI muestra mensaje de error
7. ✅ Usuario permanece en LoginScreen

### Resultado Obtenido
_[Se llenará en Fase 4]_

### Estado
⏳ Pendiente

### Evidencias Requeridas
- Screenshot del diálogo de Google Sign In
- Screenshot de Firestore mostrando documento creado
- Screenshot de HomeScreen con usuario autenticado
- Log de consola mostrando flujo completo

### Notas
- Verificar que el listener de `authStateChanges` se active
- Validar que `_loadUserData()` se ejecute automáticamente
- Verificar sincronización de estado entre Provider y UI

---

## INT-002: ReservationProvider → FirestoreService → Firestore

| Campo | Detalle |
|-------|---------|
| **ID** | INT-002 |
| **Componentes** | ReservationProvider, FirestoreService, Firestore (Transacciones) |
| **Prioridad** | Alta |
| **Severidad** | Crítica |

### Resumen
Validar el flujo completo de creación de reserva, incluyendo transacciones atómicas para actualizar spot y crear reserva simultáneamente.

### Precondiciones
- Usuario autenticado (uid: 'test_user')
- Spot disponible (id: 'spot_A1', status: 'available')
- Zona válida (id: 'zone_central')
- Usuario sin reservas activas
- Firestore accesible

### Pasos de Ejecución

1. **UI:** Usuario selecciona spot disponible
2. **ReservationProvider:** Llamar a `validateReservation(userId, spotId)`
3. **ReservationProvider:** Verificar que `canReserve = true`
4. **ReservationProvider:** Llamar a `createReservation(...)`
5. **ReservationProvider:** Verificar que `_isLoading = true`
6. **FirestoreService:** Ejecutar transacción:
   - Crear documento en `reservations`
   - Actualizar `spots/{spotId}` → status: 'reserved'
   - Actualizar `users/{userId}/stats` → incrementar totalReservations
7. **ReservationProvider:** Actualizar listas locales
8. **ReservationProvider:** Llamar `notifyListeners()`
9. **UI:** Mostrar confirmación de reserva

### Datos de Prueba

```dart
userId: 'test_user_123'
spotId: 'spot_A1'
zoneId: 'zone_central'
durationMinutes: 120
latitude: -16.4090
longitude: -71.5375
```

### Resultado Esperado

**Flujo exitoso:**
1. ✅ `validateReservation()` retorna `{canReserve: true, reason: null}`
2. ✅ `_isLoading = true` durante el proceso
3. ✅ Documento creado en `reservations/{reservationId}`:
   ```
   {
     userId: 'test_user_123',
     spotId: 'spot_A1',
     zoneId: 'zone_central',
     status: 'active',
     startTime: Timestamp (ahora),
     endTime: Timestamp (ahora + 2h),
     durationMinutes: 120,
     createdAt: Timestamp,
   }
   ```
4. ✅ Documento `spots/spot_A1` actualizado:
   ```
   {
     status: 'reserved',
     currentOccupancy: {
       userId: 'test_user_123',
       reservationId: auto-generado,
       startTime: Timestamp,
     }
   }
   ```
5. ✅ `users/test_user_123/stats.totalReservations` incrementado en 1
6. ✅ `ReservationProvider._activeReservations` contiene nueva reserva
7. ✅ `_isLoading = false`
8. ✅ `_errorMessage = null`
9. ✅ UI muestra mensaje de éxito
10. ✅ Spot ya no aparece como disponible en la lista

**Flujo con usuario con reserva activa:**
1. ✅ `validateReservation()` retorna `{canReserve: false, reason: 'Ya tienes una reserva activa'}`
2. ✅ `createReservation()` no se ejecuta
3. ✅ UI muestra mensaje de error
4. ✅ No se crea documento en Firestore

### Resultado Obtenido
_[Se llenará en Fase 4]_

### Estado
⏳ Pendiente

### Evidencias Requeridas
- Screenshot de Firestore mostrando documento de reserva
- Screenshot de Firestore mostrando spot actualizado
- Screenshot de UI mostrando confirmación
- Log de transacción de Firestore

### Notas
- **CRÍTICO:** Verificar atomicidad de la transacción
- Si falla la actualización del spot, la reserva NO debe crearse
- Validar que no haya condiciones de carrera (race conditions)
- Verificar rollback en caso de error

---

## INT-003: UI → Provider → Service (Flujo Completo)

| Campo | Detalle |
|-------|---------|
| **ID** | INT-003 |
| **Componentes** | ParkingListScreen, ParkingProvider, FirestoreService, Firestore Streams |
| **Prioridad** | Media |
| **Severidad** | Alta |

### Resumen
Validar la sincronización en tiempo real entre Firestore y la UI, asegurando que cambios en la base de datos se reflejen automáticamente en la interfaz.

### Precondiciones
- Usuario autenticado
- Al menos 2 zonas con spots en Firestore
- Firestore accesible
- Conexión a internet estable

### Pasos de Ejecución

**Parte 1: Carga inicial**
1. **UI:** Usuario abre `ParkingListScreen`
2. **ParkingProvider:** Llamar a `loadZones()`
3. **FirestoreService:** Consultar collection `zones`
4. **ParkingProvider:** Actualizar `_zones`
5. **UI:** Renderizar lista de zonas

**Parte 2: Suscripción a streams**
6. **ParkingProvider:** Suscribirse a `zonesStream()`
7. **FirestoreService:** Retornar Stream de Firestore
8. **UI:** Mostrar datos en tiempo real

**Parte 3: Simulación de cambio externo**
9. **Simulación:** Otro usuario reserva un spot (desde otra sesión/dispositivo)
10. **Firestore:** Emite actualización en el stream
11. **FirestoreService:** Procesa snapshot actualizado
12. **ParkingProvider:** Actualiza `_zones` con nueva disponibilidad
13. **ParkingProvider:** Llama `notifyListeners()`
14. **UI:** Re-renderiza automáticamente mostrando spot reservado

### Datos de Prueba

**Estado inicial:**
- Zona Central: 10 spots disponibles
- Zona Norte: 5 spots disponibles

**Cambio simulado:**
- Otro usuario reserva spot_A1 en Zona Central
- Disponibilidad Zona Central: 9 spots

### Resultado Esperado

**Carga inicial:**
1. ✅ `ParkingListScreen` muestra loading indicator
2. ✅ `loadZones()` se ejecuta al montar el widget
3. ✅ Lista de zonas se muestra con datos correctos
4. ✅ Cada zona muestra: nombre, disponibilidad, total de spots

**Sincronización en tiempo real:**
1. ✅ Stream de Firestore se establece correctamente
2. ✅ Cuando otro usuario reserva un spot:
   - Firestore emite evento de actualización
   - `ParkingProvider` recibe el cambio
   - `_zones` se actualiza automáticamente
   - UI se re-renderiza sin intervención manual
3. ✅ Disponibilidad actualizada: Zona Central muestra "9 disponibles"
4. ✅ No hay delay perceptible (< 2 segundos)
5. ✅ No se requiere refresh manual

**Manejo de errores:**
1. ✅ Si se pierde conexión, UI muestra mensaje de error
2. ✅ Al recuperar conexión, stream se reconecta automáticamente
3. ✅ Datos se sincronizan al reconectar

### Resultado Obtenido
_[Se llenará en Fase 4]_

### Estado
⏳ Pendiente

### Evidencias Requeridas
- Video mostrando actualización en tiempo real (2 dispositivos/sesiones)
- Screenshot de UI antes del cambio
- Screenshot de UI después del cambio
- Log de Firestore mostrando eventos del stream

### Notas
- Usar Firebase Console para simular cambios externos
- Verificar que no haya memory leaks en los streams
- Validar que los listeners se cancelen al salir de la pantalla
- Probar con conexión intermitente

---

## 📊 MATRIZ DE TRAZABILIDAD

| Requisito | Caso de Prueba | Tipo | Prioridad |
|-----------|----------------|------|-----------|
| RF-001: Autenticación con Google | UNIT-001, INT-001 | Unitaria, Integración | Alta |
| RF-002: Validación correo @unsa.edu.pe | UNIT-001, INT-001 | Unitaria, Integración | Alta |
| RF-003: Crear reserva | UNIT-002, INT-002 | Unitaria, Integración | Alta |
| RF-004: Validar disponibilidad | UNIT-004, INT-002 | Unitaria, Integración | Alta |
| RF-005: Cargar zonas | UNIT-003, INT-003 | Unitaria, Integración | Media |
| RF-006: Sincronización tiempo real | INT-003 | Integración | Media |
| RF-007: Serialización de datos | UNIT-005 | Unitaria | Media |

---

## ✅ CHECKLIST DE EJECUCIÓN

### Antes de ejecutar
- [ ] Configurar Firebase Emulator (opcional)
- [ ] Preparar datos de prueba en Firestore
- [ ] Verificar conexión a internet
- [ ] Limpiar caché de la aplicación

### Durante la ejecución
- [ ] Capturar screenshots de cada paso
- [ ] Guardar logs de consola
- [ ] Documentar errores encontrados
- [ ] Medir tiempos de respuesta

### Después de ejecutar
- [ ] Completar campo "Resultado Obtenido"
- [ ] Actualizar estado (Pasó/Falló)
- [ ] Registrar defectos encontrados
- [ ] Archivar evidencias

---

**Documento creado:** 29 de Noviembre, 2024  
**Próxima fase:** Fase 4 - Ejecución de Pruebas
