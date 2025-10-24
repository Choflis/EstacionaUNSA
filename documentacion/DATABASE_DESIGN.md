# 🗄️ Diseño de Base de Datos - EstacionaUNSA
## Versión 2.0 - Planificación Completa

> 📋 **Convenciones:**
> - Tipos de datos: `string`, `int`, `float`, `boolean`, `timestamp`, `array`, `map`
> - PK = Primary Key (ID del documento)
> - FK = Foreign Key (referencia a otro documento)

---

## 📊 Diagrama Entidad-Relación (Firestore)

```
┌─────────────────┐
│     USERS       │
│   (usuarios)    │
└────────┬────────┘
         │ 1
         │
         │ N
    ┌────┴────────────────────────────────┐
    │                                     │
    │                                     │
┌───┴──────────────┐              ┌──────┴─────────────┐
│  RESERVATIONS    │              │   INCIDENTS        │
│   (reservas)     │              │  (incidencias)     │
└───┬──────────────┘              └────────────────────┘
    │ N                                   
    │                                     
    │ 1                                   
┌───┴──────────────┐              ┌────────────────────┐
│  PARKING_SPOTS   │──────1:N────│  ENTRY_EXIT_LOGS   │
│   (espacios)     │              │  (entradas/salidas)│
└───┬──────────────┘              └─────────┬──────────┘
    │ N                                     │ N
    │                                       │
    │ 1                                     │ 1
┌───┴──────────────┐              ┌─────────┴──────────┐
│  PARKING_ZONES   │              │   USERS (Vigilante)│
│    (zonas)       │              └────────────────────┘
└──────────────────┘
         │
         │ 1:N
         ▼
┌──────────────────┐
│  NOTIFICATIONS   │
│ (notificaciones) │
└──────────────────┘
```

---

## 📦 Colecciones Principales

```
firestore/
├── users/                     # Usuarios: usuarios, vigilantes, administradores
├── parking_zones/            # 3 zonas principales (una por entrada UNSA)
├── parking_spots/            # Espacios individuales dentro de cada zona
├── reservations/             # Reservas activas (10-15 min máx, solo cerca de UNSA)
├── entry_exit_logs/          # Registros de entrada/salida por vigilantes
├── incidents/                # Incidencias registradas por vigilantes
├── notifications/            # Notificaciones push a usuarios
└── app_settings/             # Configuración global del sistema
```

---

## 👤 Colección: `users`

**Descripción:** Todos los usuarios del sistema (usuarios regulares, vigilantes, administradores)

**Documento ID:** `string` (Firebase Auth UID)

### Estructura del Documento

| Campo | Tipo | Descripción | Ejemplo | Obligatorio |
|-------|------|-------------|---------|-------------|
| `uid` | string | ID único de Firebase Auth | - | ✅ |
| `email` | string | Correo institucional @unsa.edu.pe | - | ✅ |
| `displayName` | string | Nombre completo del usuario | - | ✅ |
| `photoURL` | string | URL foto de perfil (Google) | - | ❌ |
| **role** | **string** | **Rol del usuario** | - | ✅ |
| | | → `"user"` - Usuario regular (estudiantes, docentes, etc.) | | |
| | | → `"guard"` - Vigilante | | |
| | | → `"admin"` - Administrador | | |
| `isActive` | boolean | ¿Usuario activo en el sistema? | - | ✅ |
| `isVerified` | boolean | ¿Verificado por administrador? | - | ✅ |
| `isBanned` | boolean | ¿Usuario baneado? | - | ✅ |
| `banReason` | string | Razón del baneo | - | ❌ |
| **vehicles** | **array\<map\>** | **Vehículos registrados** | - | ❌ |
| └─ `plateNumber` | string | Placa del vehículo | - | ✅ |
| └─ `brand` | string | Marca | - | ❌ |
| └─ `model` | string | Modelo | - | ❌ |
| └─ `color` | string | Color | - | ❌ |
| └─ `year` | int | Año | - | ❌ |
| └─ `type` | string | `"car"` \| `"motorcycle"` | - | ✅ |
| └─ `isPrimary` | boolean | ¿Es el vehículo principal? | - | ✅ |
| **academicInfo** | **map** | **Info académica/laboral (solo role=user)** | - | ❌ |
| └─ `identificationType` | string | `"CUI"` \| `"DNI"` \| `"Employee"` | - | ❌ |
| └─ `identificationNumber` | string | Número de identificación | - | ❌ |
| └─ `faculty` | string | Facultad | - | ❌ |
| └─ `program` | string | Programa/Escuela profesional | - | ❌ |
| └─ `userType` | string | `"student"` \| `"teacher"` \| `"administrative"` | - | ❌ |
| **stats** | **map** | **Estadísticas del usuario** | - | ✅ |
| └─ `totalReservations` | int | Total de reservas realizadas | - | ✅ |
| └─ `completedReservations` | int | Reservas completadas | - | ✅ |
| └─ `cancelledReservations` | int | Reservas canceladas | - | ✅ |
| └─ `noShowCount` | int | Veces que no llegó (penalización) | - | ✅ |
| └─ `incidentCount` | int | Total de incidencias | - | ✅ |
| `createdAt` | timestamp | Fecha de registro | - | ✅ |
| `updatedAt` | timestamp | Última actualización | - | ✅ |
| `lastLoginAt` | timestamp | Último inicio de sesión | - | ❌ |

### Índices Compuestos Requeridos
```javascript
// Para consultas de usuarios activos por rol
email (ASC)
role (ASC), isActive (ASC)
isBanned (ASC), role (ASC)
```

### Reglas de Negocio
- Email debe terminar en `@unsa.edu.pe`
- Un usuario solo puede tener 1 vehículo primario
- Si `noShowCount >= 3` → Usuario puede ser baneado
- Si `incidentCount >= 5` → Usuario puede ser baneado
- Solo `admin` puede cambiar roles

---

## 🅿️ Colección: `parking_zones`

**Descripción:** Las 3 zonas principales de estacionamiento (una por cada entrada de UNSA)

**Documento ID:** `string` (autogenerado)

### Estructura del Documento

| Campo | Tipo | Descripción | Ejemplo | Obligatorio |
|-------|------|-------------|---------|-------------|
| `zoneId` | string | Código único de la zona | `"ZONA_ENTRADA_PRINCIPAL"` | ✅ |
| `name` | string | Nombre descriptivo | `"Zona Entrada Principal"` | ✅ |
| `description` | string | Descripción de ubicación | `"Estacionamiento junto a portería principal"` | ❌ |
| **location** | **map** | **Ubicación geográfica** | - | ✅ |
| └─ `latitude` | float | Latitud GPS | `-16.4055` | ✅ |
| └─ `longitude` | float | Longitud GPS | `-71.5300` | ✅ |
| └─ `address` | string | Dirección textual | `"Av. Independencia 123"` | ❌ |
| └─ `entrance` | string | Nombre de la entrada | `"Puerta Principal"` | ✅ |
| **capacity** | **map** | **Capacidad de la zona** | - | ✅ |
| └─ `totalSpots` | int | Espacios totales | `50` | ✅ |
| └─ `availableSpots` | int | Espacios disponibles (calculado) | `35` | ✅ |
| └─ `occupiedSpots` | int | Espacios ocupados | `15` | ✅ |
| └─ `reservedSpots` | int | Espacios con reserva activa | `5` | ✅ |
| └─ `maintenanceSpots` | int | Espacios en mantenimiento | `0` | ✅ |
| **schedule** | **map** | **Horarios de operación** | - | ✅ |
| └─ `monday` | map | `{ open: "07:00", close: "22:00" }` | - | ✅ |
| └─ `tuesday` | map | `{ open: "07:00", close: "22:00" }` | - | ✅ |
| └─ `wednesday` | map | `{ open: "07:00", close: "22:00" }` | - | ✅ |
| └─ `thursday` | map | `{ open: "07:00", close: "22:00" }` | - | ✅ |
| └─ `friday` | map | `{ open: "07:00", close: "22:00" }` | - | ✅ |
| └─ `saturday` | map | `{ open: "08:00", close: "14:00" }` | - | ✅ |
| └─ `sunday` | map | `{ open: null, close: null }` (cerrado) | - | ✅ |
| `isActive` | boolean | ¿Zona activa? | `true` | ✅ |
| `isFull` | boolean | ¿Zona llena? (calculado) | `false` | ✅ |
| `isOpen` | boolean | ¿Abierta ahora? (calculado) | `true` | ✅ |
| `createdAt` | timestamp | Fecha de creación | - | ✅ |
| `updatedAt` | timestamp | Última actualización | - | ✅ |

### Índices Compuestos Requeridos
```javascript
isActive (ASC), isFull (ASC)
```

### Reglas de Negocio
- Solo pueden existir 3 zonas activas (una por entrada)
- `availableSpots = totalSpots - occupiedSpots - reservedSpots - maintenanceSpots`
- `isFull = (availableSpots == 0)`
- Notificar cuando `availableSpots < 5` (zona casi llena)
- Notificar cuando `isFull == true` → `isFull == false` (espacios disponibles)

---

## 🚗 Colección: `parking_spots`

**Descripción:** Espacios individuales de estacionamiento dentro de cada zona

**Documento ID:** `string` (autogenerado)

### Estructura del Documento

| Campo | Tipo | Descripción | Ejemplo | Obligatorio |
|-------|------|-------------|---------|-------------|
| `spotId` | string | Código visual del espacio | `"A-001"` | ✅ |
| `spotNumber` | int | Número del espacio | `1` | ✅ |
| **zoneId** | **string** | **FK a parking_zones** | `"ZONA_ENTRADA_PRINCIPAL"` | ✅ |
| `zoneName` | string | Nombre de la zona (desnormalizado) | `"Zona Entrada Principal"` | ✅ |
| **status** | **string** | **Estado actual del espacio** | - | ✅ |
| | | → `"available"` - Disponible | | |
| | | → `"occupied"` - Ocupado | | |
| | | → `"reserved"` - Reservado | | |
| | | → `"maintenance"` - En mantenimiento | | |
| `isActive` | boolean | ¿Espacio activo? | `true` | ✅ |
| `type` | string | Tipo de espacio | `"regular"` \| `"motorcycle"` | ✅ |
| **currentOccupancy** | **map** | **Ocupación actual (si está ocupado/reservado)** | - | ❌ |
| └─ `userId` | string | FK a users | - | ✅ |
| └─ `userEmail` | string | Email del usuario | - | ✅ |
| └─ `userName` | string | Nombre del usuario | - | ✅ |
| └─ `vehiclePlate` | string | Placa del vehículo | - | ✅ |
| └─ `startTime` | timestamp | Inicio de ocupación/reserva | - | ✅ |
| └─ `endTime` | timestamp | Fin estimado | - | ❌ |
| └─ `reservationId` | string | FK a reservations (si aplica) | - | ❌ |
| └─ `entryLogId` | string | FK a entry_exit_logs | - | ❌ |
| `createdAt` | timestamp | Fecha de creación | - | ✅ |
| `updatedAt` | timestamp | Última actualización | - | ✅ |
| `lastOccupiedAt` | timestamp | Última vez ocupado | - | ❌ |

### Índices Compuestos Requeridos
```javascript
zoneId (ASC), status (ASC)
status (ASC), type (ASC)
zoneId (ASC), isActive (ASC), status (ASC)
```

### Reglas de Negocio
- Solo puede estar en un estado a la vez
- Si `status == "reserved"` debe tener `currentOccupancy.reservationId`
- Si `status == "occupied"` debe tener `currentOccupancy.entryLogId`
- Reserva caduca automáticamente después de `endTime`

---

## 📅 Colección: `reservations`

**Descripción:** Reservas activas (solo cuando el usuario está cerca de UNSA, duración: 10-15 min máx)

**Documento ID:** `string` (autogenerado)

### Estructura del Documento

| Campo | Tipo | Descripción | Ejemplo | Obligatorio |
|-------|------|-------------|---------|-------------|
| `reservationId` | string | ID legible único | `"RES-20241024-001"` | ✅ |
| **userId** | **string** | **FK a users** | - | ✅ |
| `userEmail` | string | Email del usuario (desnormalizado) | - | ✅ |
| `userName` | string | Nombre del usuario (desnormalizado) | - | ✅ |
| **spotId** | **string** | **FK a parking_spots** | - | ✅ |
| `spotNumber` | string | Número visual del espacio | `"A-001"` | ✅ |
| **zoneId** | **string** | **FK a parking_zones** | - | ✅ |
| `zoneName` | string | Nombre de la zona (desnormalizado) | - | ✅ |
| **vehicle** | **map** | **Datos del vehículo** | - | ✅ |
| └─ `plateNumber` | string | Placa | - | ✅ |
| └─ `brand` | string | Marca | - | ❌ |
| └─ `model` | string | Modelo | - | ❌ |
| └─ `color` | string | Color | - | ❌ |
| └─ `type` | string | `"car"` \| `"motorcycle"` | - | ✅ |
| **time** | **map** | **Control de tiempo** | - | ✅ |
| └─ `startTime` | timestamp | Inicio de la reserva | - | ✅ |
| └─ `endTime` | timestamp | Fin de la reserva (max 15 min) | - | ✅ |
| └─ `duration` | int | Duración en minutos (10-15) | `15` | ✅ |
| └─ `expiresAt` | timestamp | Timestamp de expiración | - | ✅ |
| **status** | **string** | **Estado de la reserva** | - | ✅ |
| | | → `"active"` - Activa | | |
| | | → `"used"` - Usuario llegó y entró | | |
| | | → `"expired"` - Expiró (no llegó a tiempo) | | |
| | | → `"cancelled"` - Cancelada por usuario | | |
| **location** | **map** | **Ubicación al crear reserva** | - | ✅ |
| └─ `latitude` | float | Latitud del usuario | - | ✅ |
| └─ `longitude` | float | Longitud del usuario | - | ✅ |
| └─ `distanceToUNSA` | float | Distancia en metros a UNSA | `450.5` | ✅ |
| └─ `wasNearby` | boolean | ¿Estaba cerca al reservar? | `true` | ✅ |
| `checkedInAt` | timestamp | Momento en que entró físicamente | - | ❌ |
| `entryLogId` | string | FK a entry_exit_logs | - | ❌ |
| `createdAt` | timestamp | Fecha de creación | - | ✅ |
| `updatedAt` | timestamp | Última actualización | - | ✅ |
| `cancelledAt` | timestamp | Fecha de cancelación | - | ❌ |
| `cancellationReason` | string | Razón de cancelación | - | ❌ |

### Índices Compuestos Requeridos
```javascript
userId (ASC), status (ASC)
spotId (ASC), status (ASC)
status (ASC), expiresAt (ASC)
userId (ASC), createdAt (DESC)
```

### Reglas de Negocio
- Solo se puede reservar si `distanceToUNSA <= 500 metros` (geolocalización)
- Duración máxima: 15 minutos
- Un usuario solo puede tener 1 reserva activa a la vez
- Si no llega antes de `expiresAt` → `status = "expired"` y se registra incidencia
- Auto-cancelar reservas expiradas cada 1 minuto (Cloud Function)
- Si usuario entra físicamente → `status = "used"` y se crea `entry_exit_log`

---

## 📜 Colección: `entry_exit_logs`

**Descripción:** Registro de entradas y salidas físicas registradas por vigilantes (CU04, CU05)

**Documento ID:** `string` (autogenerado)

### Estructura del Documento

| Campo | Tipo | Descripción | Ejemplo | Obligatorio |
|-------|------|-------------|---------|-------------|
| `logId` | string | ID único del registro | `"LOG-20241024-001"` | ✅ |
| `type` | string | Tipo de registro: `"entry"` \| `"exit"` | `"entry"` | ✅ |
| **userId** | **string** | **FK a users** | - | ✅ |
| `userEmail` | string | Email del usuario (desnormalizado) | - | ✅ |
| `userName` | string | Nombre del usuario (desnormalizado) | - | ✅ |
| `userRole` | string | Rol del usuario | `"user"` \| `"guard"` \| `"admin"` | ✅ |
| **guardId** | **string** | **FK a users (vigilante)** | - | ✅ |
| `guardEmail` | string | Email del vigilante | - | ✅ |
| `guardName` | string | Nombre del vigilante | - | ✅ |
| **spotId** | **string** | **FK a parking_spots** | - | ✅ |
| `spotNumber` | string | Número visual del espacio | `"A-001"` | ✅ |
| **zoneId** | **string** | **FK a parking_zones** | - | ✅ |
| `zoneName` | string | Nombre de la zona | - | ✅ |
| **vehicle** | **map** | **Datos del vehículo** | - | ✅ |
| └─ `plateNumber` | string | Placa | - | ✅ |
| └─ `brand` | string | Marca | - | ❌ |
| └─ `model` | string | Modelo | - | ❌ |
| └─ `color` | string | Color | - | ❌ |
| └─ `type` | string | `"car"` \| `"motorcycle"` | - | ✅ |
| **reservationId** | **string** | **FK a reservations (si venía de reserva)** | - | ❌ |
| `hadReservation` | boolean | ¿Tenía reserva activa? | `true` | ✅ |
| `entryTime` | timestamp | Timestamp de entrada | - | ✅ (si type=entry) |
| `exitTime` | timestamp | Timestamp de salida | - | ✅ (si type=exit) |
| `duration` | int | Minutos de permanencia (solo en exit) | `120` | ❌ |
| **relatedEntryLogId** | **string** | **FK a entry_exit_logs (para exit)** | - | ❌ |
| `notes` | string | Observaciones del vigilante | - | ❌ |
| `createdAt` | timestamp | Fecha de creación | - | ✅ |

### Índices Compuestos Requeridos
```javascript
userId (ASC), type (ASC), createdAt (DESC)
guardId (ASC), createdAt (DESC)
zoneId (ASC), type (ASC), createdAt (DESC)
type (ASC), createdAt (DESC)
```

### Reglas de Negocio
- **Entrada:** Vigilante registra placa → Sistema valida si tiene reserva activa
  - Si tiene reserva activa → Actualiza reserva a `status="used"`
  - Si NO tiene reserva → Registra entrada normal
  - Actualiza `parking_spot.status = "occupied"`
  - Actualiza `parking_spot.currentOccupancy`
- **Salida:** Vigilante registra placa → Sistema busca entrada activa
  - Calcula duración de permanencia
  - Libera `parking_spot.status = "available"`
  - Limpia `parking_spot.currentOccupancy`
  - Vincula con `relatedEntryLogId`

---

## 🔔 Colección: `notifications`

**Descripción:** Notificaciones para usuarios

### Estructura del Documento

```javascript
{
  "userId": "user_123",
  "type": "reservation_reminder",  // "reservation_reminder" | "spot_available" | "reservation_cancelled" | "system"
  
  "title": "Recordatorio de reserva",
  "message": "Tu reserva en Zona A-001 comienza en 15 minutos",
  
  "data": {
    "reservationId": "res_123",
    "spotId": "spot_123"
  },
  
  "isRead": false,
  "readAt": null,
  
  "createdAt": Timestamp
}
```

### Índices Requeridos
- `userId`
- `isRead`
- Compuesto: `userId` + `createdAt`

---

## 🔗 Relaciones entre Colecciones

```
users (1) ──────────────── (N) reservations
                              │
parking_zones (1) ─── (N) parking_spots ─── (1) reservations
                              │
                              └─── (N) reservation_history
```

---

## 📊 Consultas Comunes

### 1. Ver espacios disponibles en una zona
```javascript
db.collection('parking_spots')
  .where('zoneId', '==', 'ZONE_A')
  .where('status', '==', 'available')
  .get()
```

### 2. Ver reservas activas de un usuario
```javascript
db.collection('reservations')
  .where('userId', '==', userId)
  .where('status', '==', 'active')
  .get()
```

### 3. Historial de un usuario
```javascript
db.collection('reservation_history')
  .where('userId', '==', userId)
  .orderBy('createdAt', 'desc')
  .limit(10)
  .get()
```

### 4. Notificaciones no leídas
```javascript
db.collection('notifications')
  .where('userId', '==', userId)
  .where('isRead', '==', false)
  .orderBy('createdAt', 'desc')
  .get()
```

---

## ⚠️ Consideraciones Importantes

### 1. Datos Duplicados (Denormalización)
En Firestore es normal duplicar datos para evitar múltiples consultas:

```javascript
// ✅ BUENO: Guardar info del usuario en la reserva
{
  "reservationId": "res_123",
  "userId": "user_123",
  "userName": "Juan Pérez",  // ← Duplicado, pero útil
  "userEmail": "juan@unsa.edu.pe"  // ← Duplicado
}

// ❌ MALO: Solo guardar el ID
{
  "reservationId": "res_123",
  "userId": "user_123"
  // Necesitarías otra consulta para obtener nombre y email
}
```

### 2. Contadores en Tiempo Real
Para `availableSpots` en zonas, usar Cloud Functions que actualicen automáticamente.

### 3. Limpieza de Datos
- Mover reservas completadas a `reservation_history` cada noche
- Eliminar notificaciones leídas después de 30 días

### 4. Seguridad
Ver archivo `firestore.rules` para reglas de acceso.

---

## 🚀 Próximos Pasos

1. ✅ Crear modelos Dart para cada colección
2. ✅ Implementar servicios de Firestore
3. ✅ Configurar reglas de seguridad
4. ✅ Crear datos de prueba
5. ✅ Implementar sincronización en tiempo real


---

## ⚠️ Colección: `incidents`

**Descripción:** Incidencias registradas por vigilantes (CU10) o automáticas (reservas expiradas)

**Documento ID:** `string` (autogenerado)

### Estructura del Documento

| Campo | Tipo | Descripción | Ejemplo | Obligatorio |
|-------|------|-------------|---------|-------------|
| `incidentId` | string | ID único de la incidencia | `"INC-20241024-001"` | ✅ |
| **type** | **string** | **Tipo de incidencia** | - | ✅ |
| | | → `"no_show"` - No llegó a reserva | | |
| | | → `"late_arrival"` - Llegó tarde | | |
| | | → `"unauthorized_parking"` - Estacionamiento sin permiso | | |
| | | → `"damage"` - Daño a propiedad | | |
| | | → `"traffic_violation"` - Infracción de tránsito | | |
| | | → `"other"` - Otra incidencia | | |
| `severity` | string | `"low"` \| `"medium"` \| `"high"` | `"medium"` | ✅ |
| **userId** | **string** | **FK a users (usuario involucrado)** | - | ✅ |
| `userEmail` | string | Email del usuario (desnormalizado) | - | ✅ |
| `userName` | string | Nombre del usuario (desnormalizado) | - | ✅ |
| **reportedBy** | **string** | **FK a users (quien reporta)** | - | ✅ |
| `reportedByEmail` | string | Email de quien reporta | - | ✅ |
| `reportedByName` | string | Nombre de quien reporta | - | ✅ |
| `reportedByRole` | string | Rol: `"guard"` \| `"admin"` \| `"system"` | `"guard"` | ✅ |
| `description` | string | Descripción detallada | - | ✅ |
| **relatedData** | **map** | **Datos relacionados** | - | ❌ |
| └─ `reservationId` | string | FK a reservations | - | ❌ |
| └─ `spotId` | string | FK a parking_spots | - | ❌ |
| └─ `zoneId` | string | FK a parking_zones | - | ❌ |
| └─ `entryLogId` | string | FK a entry_exit_logs | - | ❌ |
| └─ `vehiclePlate` | string | Placa del vehículo | - | ❌ |
| **evidence** | **array<map>** | **Evidencia (fotos, etc.)** | - | ❌ |
| └─ `type` | string | `"photo"` \| `"document"` | - | ✅ |
| └─ `url` | string | URL del archivo (Firebase Storage) | - | ✅ |
| └─ `uploadedAt` | timestamp | Fecha de carga | - | ✅ |
| **status** | **string** | **Estado de la incidencia** | - | ✅ |
| | | → `"pending"` - Pendiente de revisión | | |
| | | → `"reviewed"` - Revisada por admin | | |
| | | → `"resolved"` - Resuelta | | |
| | | → `"dismissed"` - Descartada | | |
| **resolution** | **map** | **Resolución (si aplica)** | - | ❌ |
| └─ `resolvedBy` | string | FK a users (admin) | - | ❌ |
| └─ `resolvedAt` | timestamp | Fecha de resolución | - | ❌ |
| └─ `action` | string | Acción tomada | - | ❌ |
| └─ `notes` | string | Notas de resolución | - | ❌ |
| `createdAt` | timestamp | Fecha de creación | - | ✅ |
| `updatedAt` | timestamp | Última actualización | - | ✅ |

### Índices Compuestos Requeridos
```javascript
userId (ASC), createdAt (DESC)
type (ASC), status (ASC)
reportedBy (ASC), createdAt (DESC)
status (ASC), severity (ASC), createdAt (DESC)
```

### Reglas de Negocio
- **No Show automático:** Si reserva expira → se crea incidencia tipo `"no_show"` por `"system"`
- **Penalización por incidencias:**
  - 3 `no_show` → Advertencia (notificación)
  - 5 `no_show` → Suspensión temporal (7 días sin poder reservar)
  - 10 `no_show` → Baneo permanente (`user.isBanned = true`)
- Solo `admin` y `guard` pueden crear incidencias manualmente
- Solo `admin` puede resolver/descartar incidencias
- Incidencias `severity="high"` requieren evidencia obligatoria

---

## 🔔 Colección: `notifications`

**Descripción:** Notificaciones push para usuarios (CU06)

**Documento ID:** `string` (autogenerado)

### Estructura del Documento

| Campo | Tipo | Descripción | Ejemplo | Obligatorio |
|-------|------|-------------|---------|-------------|
| `notificationId` | string | ID único | - | ✅ |
| **userId** | **string** | **FK a users** | - | ✅ |
| **type** | **string** | **Tipo de notificación** | - | ✅ |
| | | → `"zone_available"` - Espacios disponibles en zona | | |
| | | → `"zone_full"` - Zona llena | | |
| | | → `"reservation_reminder"` - Recordatorio de reserva | | |
| | | → `"reservation_expiring"` - Reserva por expirar | | |
| | | → `"reservation_expired"` - Reserva expirada | | |
| | | → `"nearby_university"` - Cerca de UNSA (habilita reserva) | | |
| | | → `"incident_reported"` - Incidencia registrada | | |
| | | → `"account_warning"` - Advertencia de cuenta | | |
| | | → `"account_suspended"` - Cuenta suspendida | | |
| | | → `"system"` - Notificación del sistema | | |
| `title` | string | Título de la notificación | - | ✅ |
| `message` | string | Mensaje descriptivo | - | ✅ |
| `priority` | string | `"low"` \| `"normal"` \| `"high"` | `"normal"` | ✅ |
| **data** | **map** | **Datos adicionales** | - | ❌ |
| └─ `reservationId` | string | FK a reservations | - | ❌ |
| └─ `zoneId` | string | FK a parking_zones | - | ❌ |
| └─ `incidentId` | string | FK a incidents | - | ❌ |
| └─ `actionUrl` | string | URL de acción (deep link) | - | ❌ |
| `isRead` | boolean | ¿Leída? | `false` | ✅ |
| `readAt` | timestamp | Fecha de lectura | - | ❌ |
| `isSent` | boolean | ¿Enviada por FCM? | `true` | ✅ |
| `sentAt` | timestamp | Fecha de envío | - | ❌ |
| `createdAt` | timestamp | Fecha de creación | - | ✅ |

### Índices Compuestos Requeridos
```javascript
userId (ASC), isRead (ASC), createdAt (DESC)
userId (ASC), type (ASC), createdAt (DESC)
```

### Reglas de Negocio
- Auto-eliminar notificaciones leídas después de 30 días
- `priority="high"` → enviar inmediatamente por FCM
- Notificación `nearby_university` se activa cuando usuario está a <= 500m de UNSA
- Máximo 100 notificaciones no leídas por usuario (eliminar las más antiguas)

---

## ⚙️ Colección: `app_settings`

**Descripción:** Configuración global del sistema (solo lectura para usuarios, escritura admin)

**Documento ID:** `"config"` (documento único)

### Estructura del Documento

| Campo | Tipo | Descripción | Ejemplo | Obligatorio |
|-------|------|-------------|---------|-------------|
| **reservationSettings** | **map** | **Configuración de reservas** | - | ✅ |
| └─ `enabled` | boolean | ¿Reservas habilitadas? | `true` | ✅ |
| └─ `maxDurationMinutes` | int | Duración máxima (min) | `15` | ✅ |
| └─ `minDurationMinutes` | int | Duración mínima (min) | `10` | ✅ |
| └─ `maxDistanceMeters` | int | Distancia máx a UNSA (m) | `500` | ✅ |
| └─ `maxActiveReservations` | int | Reservas activas por usuario | `1` | ✅ |
| **incidentSettings** | **map** | **Configuración de incidencias** | - | ✅ |
| └─ `noShowWarningLimit` | int | No-shows para advertencia | `3` | ✅ |
| └─ `noShowSuspensionLimit` | int | No-shows para suspensión | `5` | ✅ |
| └─ `noShowBanLimit` | int | No-shows para baneo | `10` | ✅ |
| └─ `suspensionDurationDays` | int | Días de suspensión | `7` | ✅ |
| **universityLocation** | **map** | **Ubicación de UNSA** | - | ✅ |
| └─ `latitude` | float | Latitud central | `-16.4055` | ✅ |
| └─ `longitude` | float | Longitud central | `-71.5300` | ✅ |
| └─ `name` | string | Nombre | `"UNSA Campus"` | ✅ |
| **systemSettings** | **map** | **Configuración del sistema** | - | ✅ |
| └─ `maintenanceMode` | boolean | ¿Modo mantenimiento? | `false` | ✅ |
| └─ `maintenanceMessage` | string | Mensaje de mantenimiento | - | ❌ |
| └─ `minAppVersion` | string | Versión mínima de app | `"1.0.0"` | ✅ |
| `updatedAt` | timestamp | Última actualización | - | ✅ |
| `updatedBy` | string | FK a users (admin) | - | ✅ |

### Reglas de Negocio
- Solo `admin` puede modificar
- Todos los usuarios pueden leer
- Cambios se reflejan inmediatamente en la app (Firestore realtime)


---

## 🔗 RELACIONES ENTRE COLECCIONES (Actualizado)

```
                    ┌─────────────────┐
                    │     USERS       │
                    └────────┬────────┘
                             │ 1
              ┌──────────────┼──────────────┬──────────────┐
              │              │              │              │
              │ N            │ N            │ N            │ N
    ┌─────────┴────┐  ┌──────┴──────┐ ┌────┴────────┐ ┌──┴────────────┐
    │ RESERVATIONS │  │ ENTRY_EXIT  │ │  INCIDENTS  │ │ NOTIFICATIONS │
    │              │  │    _LOGS    │ │             │ │               │
    └──────┬───────┘  └──────┬──────┘ └─────────────┘ └───────────────┘
           │ N               │ N
           │ 1               │ 1
    ┌──────┴───────┐  ┌──────┴───────┐
    │ PARKING      │  │ PARKING      │
    │  _SPOTS      │  │  _SPOTS      │
    └──────┬───────┘  └──────┬───────┘
           │ N               │ N
           │ 1               │ 1
    ┌──────┴────────────────┴────┐
    │    PARKING_ZONES           │
    └────────────────────────────┘
```

### Relaciones Detalladas

| Desde | Hacia | Tipo | FK Campo |
|-------|-------|------|----------|
| `users` | `reservations` | 1:N | `userId` |
| `users` | `entry_exit_logs` | 1:N | `userId`, `guardId` |
| `users` | `incidents` | 1:N | `userId`, `reportedBy` |
| `users` | `notifications` | 1:N | `userId` |
| `parking_zones` | `parking_spots` | 1:N | `zoneId` |
| `parking_spots` | `reservations` | 1:1 | `spotId` |
| `parking_spots` | `entry_exit_logs` | 1:N | `spotId` |
| `reservations` | `entry_exit_logs` | 1:1 | `reservationId` |
| `reservations` | `incidents` | 1:1 | `reservationId` |

---

## 📊 CONSULTAS COMUNES (Actualizadas)

### 1. Ver espacios disponibles en una zona
```javascript
db.collection('parking_spots')
  .where('zoneId', '==', 'ZONA_ENTRADA_PRINCIPAL')
  .where('status', '==', 'available')
  .where('isActive', '==', true)
  .get()
```

### 2. Ver reserva activa de un usuario
```javascript
db.collection('reservations')
  .where('userId', '==', userId)
  .where('status', '==', 'active')
  .limit(1)
  .get()
```

### 3. Registros de entrada/salida de hoy por vigilante
```javascript
const today = new Date();
today.setHours(0, 0, 0, 0);

db.collection('entry_exit_logs')
  .where('guardId', '==', guardId)
  .where('createdAt', '>=', today)
  .orderBy('createdAt', 'desc')
  .get()
```

### 4. Incidencias pendientes de un usuario
```javascript
db.collection('incidents')
  .where('userId', '==', userId)
  .where('status', '==', 'pending')
  .orderBy('createdAt', 'desc')
  .get()
```

### 5. Notificaciones no leídas
```javascript
db.collection('notifications')
  .where('userId', '==', userId)
  .where('isRead', '==', false)
  .orderBy('createdAt', 'desc')
  .limit(20)
  .get()
```

### 6. Buscar entrada activa por placa (para registrar salida)
```javascript
db.collection('entry_exit_logs')
  .where('vehicle.plateNumber', '==', 'ABC-123')
  .where('type', '==', 'entry')
  .where('exitTime', '==', null)  // Sin salida registrada
  .limit(1)
  .get()
```

### 7. Estadísticas de zona (admin)
```javascript
// Obtener zona con espacios disponibles
db.collection('parking_zones')
  .doc(zoneId)
  .get()

// Obtener ocupación en tiempo real
db.collection('parking_spots')
  .where('zoneId', '==', zoneId)
  .get()
  .then(snapshot => {
    const total = snapshot.size;
    const available = snapshot.docs.filter(d => d.data().status === 'available').length;
    const occupied = snapshot.docs.filter(d => d.data().status === 'occupied').length;
    const reserved = snapshot.docs.filter(d => d.data().status === 'reserved').length;
  })
```

---

## ⚠️ CONSIDERACIONES IMPORTANTES

### 1. Denormalización de Datos (NoSQL Best Practice)

En Firestore, **duplicar datos es correcto** para optimizar consultas:

```javascript
// ✅ BUENO: Datos desnormalizados
{
  "reservationId": "RES-001",
  "userId": "user_123",
  "userName": "string",      // ← Duplicado desde users
  "userEmail": "string",     // ← Duplicado desde users
  "spotNumber": "A-001",     // ← Duplicado desde parking_spots
  "zoneName": "string"       // ← Duplicado desde parking_zones
}

// ❌ MALO: Solo IDs (requiere múltiples consultas)
{
  "reservationId": "RES-001",
  "userId": "user_123",
  "spotId": "spot_123"
  // Necesitas 3 consultas para mostrar la reserva completa
}
```

**Regla:** Si un dato se usa frecuentemente en la UI, desnormalízalo.

### 2. Contadores en Tiempo Real

Para mantener `availableSpots` actualizado en `parking_zones`:

**Opción A:** Cloud Function (recomendado)
```javascript
// Trigger cuando cambia un parking_spot
exports.updateZoneAvailability = functions.firestore
  .document('parking_spots/{spotId}')
  .onUpdate(async (change, context) => {
    const newStatus = change.after.data().status;
    const oldStatus = change.before.data().status;
    const zoneId = change.after.data().zoneId;
    
    if (newStatus !== oldStatus) {
      // Actualizar contador en parking_zones
      await updateZoneCounters(zoneId);
    }
  });
```

**Opción B:** Transaction en cliente (menos confiable)

### 3. Geolocalización para Reservas

Usar paquete `geolocator` para verificar distancia:

```dart
import 'package:geolocator/geolocator.dart';

// Obtener ubicación actual
Position userPosition = await Geolocator.getCurrentPosition();

// Calcular distancia a UNSA
double distanceInMeters = Geolocator.distanceBetween(
  userPosition.latitude,
  userPosition.longitude,
  -16.4055,  // UNSA lat
  -71.5300,  // UNSA lng
);

// Permitir reserva solo si está cerca
if (distanceInMeters <= 500) {
  // Crear reserva
}
```

### 4. Expiración Automática de Reservas

**Cloud Function programada:**

```javascript
exports.expireReservations = functions.pubsub
  .schedule('every 1 minutes')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    
    const expiredReservations = await db.collection('reservations')
      .where('status', '==', 'active')
      .where('expiresAt', '<=', now)
      .get();
    
    const batch = db.batch();
    
    expiredReservations.forEach(doc => {
      // Actualizar reserva a expirada
      batch.update(doc.ref, { status: 'expired', updatedAt: now });
      
      // Crear incidencia
      const incidentRef = db.collection('incidents').doc();
      batch.set(incidentRef, {
        type: 'no_show',
        userId: doc.data().userId,
        reportedBy: 'system',
        // ... más campos
      });
      
      // Liberar espacio
      const spotRef = db.collection('parking_spots').doc(doc.data().spotId);
      batch.update(spotRef, { 
        status: 'available',
        currentOccupancy: null
      });
    });
    
    await batch.commit();
  });
```

### 5. Seguridad - Firestore Rules

Actualizar `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isAdmin() {
      return isAuthenticated() && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    function isGuard() {
      return isAuthenticated() && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'guard';
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && isOwner(userId);
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if false;  // No permitir eliminación
    }
    
    // Parking zones (lectura pública, escritura admin)
    match /parking_zones/{zoneId} {
      allow read: if true;  // Público
      allow write: if isAdmin();
    }
    
    // Parking spots (lectura pública, escritura admin/guard)
    match /parking_spots/{spotId} {
      allow read: if true;
      allow create, update: if isAdmin() || isGuard();
      allow delete: if isAdmin();
    }
    
    // Reservations (solo propietario puede leer/crear, guard puede actualizar)
    match /reservations/{reservationId} {
      allow read: if isOwner(resource.data.userId) || isAdmin() || isGuard();
      allow create: if isAuthenticated() && isOwner(request.resource.data.userId);
      allow update: if isOwner(resource.data.userId) || isGuard() || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Entry/Exit logs (solo guard y admin pueden escribir)
    match /entry_exit_logs/{logId} {
      allow read: if isAuthenticated();
      allow write: if isGuard() || isAdmin();
    }
    
    // Incidents (guard y admin pueden crear, admin puede resolver)
    match /incidents/{incidentId} {
      allow read: if isAuthenticated();
      allow create: if isGuard() || isAdmin();
      allow update: if isAdmin();
      allow delete: if isAdmin();
    }
    
    // Notifications (solo propietario puede leer/actualizar)
    match /notifications/{notificationId} {
      allow read, update: if isOwner(resource.data.userId);
      allow create: if isAdmin() || isGuard();  // Sistema crea notificaciones
      allow delete: if isOwner(resource.data.userId) || isAdmin();
    }
    
    // App settings (lectura pública, escritura solo admin)
    match /app_settings/config {
      allow read: if true;
      allow write: if isAdmin();
    }
  }
}
```

### 6. Índices a Crear en Firestore Console

Ir a Firebase Console > Firestore > Índices y crear:

```
Collection: reservations
Fields: userId (ASC), status (ASC), createdAt (DESC)

Collection: reservations
Fields: spotId (ASC), status (ASC)

Collection: entry_exit_logs
Fields: userId (ASC), type (ASC), createdAt (DESC)

Collection: entry_exit_logs
Fields: guardId (ASC), createdAt (DESC)

Collection: incidents
Fields: userId (ASC), status (ASC), createdAt (DESC)

Collection: parking_spots
Fields: zoneId (ASC), status (ASC), isActive (ASC)

Collection: notifications
Fields: userId (ASC), isRead (ASC), createdAt (DESC)
```

---

## 🚀 PRÓXIMOS PASOS

1. ✅ **Fase 1: Planificación** (Completada)
   - [x] Diseño de base de datos
   - [x] Definir colecciones y campos
   - [x] Establecer reglas de negocio

2. ⏭️ **Fase 2: Implementación**
   - [ ] Crear modelos Dart para cada colección
   - [ ] Implementar servicios de Firestore
   - [ ] Configurar reglas de seguridad
   - [ ] Crear índices en Firestore Console

3. ⏭️ **Fase 3: Datos de Prueba**
   - [ ] Crear 3 zonas de estacionamiento
   - [ ] Crear espacios de estacionamiento por zona
   - [ ] Crear usuarios de prueba (admin, guard, students)
   - [ ] Crear configuración inicial (`app_settings`)

4. ⏭️ **Fase 4: Funcionalidades**
   - [ ] Sistema de reservas con geolocalización
   - [ ] Registro de entrada/salida (vigilante)
   - [ ] Sistema de incidencias
   - [ ] Notificaciones push
   - [ ] Dashboard de administrador

5. ⏭️ **Fase 5: Cloud Functions**
   - [ ] Expiración automática de reservas
   - [ ] Actualización de contadores en zonas
   - [ ] Creación automática de incidencias
   - [ ] Envío de notificaciones push

---

## 📚 RESUMEN FINAL

### Colecciones: 8
1. `users` - Usuarios del sistema
2. `parking_zones` - 3 zonas principales
3. `parking_spots` - Espacios individuales
4. `reservations` - Reservas activas (10-15 min)
5. `entry_exit_logs` - Registros de entrada/salida
6. `incidents` - Incidencias y penalizaciones
7. `notifications` - Notificaciones push
8. `app_settings` - Configuración global

### Roles: 5
- `student` - Estudiante
- `teacher` - Docente
- `administrative` - Administrativo
- `guard` - Vigilante (registra entradas/salidas)
- `admin` - Administrador (gestión total)

### Funcionalidades Clave:
- ✅ Reservas solo cuando estás cerca de UNSA (≤ 500m)
- ✅ Duración máxima: 15 minutos
- ✅ Vigilantes registran entrada/salida
- ✅ Sistema de incidencias automático (no-show)
- ✅ Penalizaciones progresivas (3 → 5 → 10 incidencias)
- ✅ Notificaciones en tiempo real
- ✅ 3 zonas (una por entrada de UNSA)
- ✅ Sin zonas especiales (todos los usuarios pueden usar cualquier zona)


---

## 📋 RESUMEN VISUAL - SCHEMA DE COLECCIONES

### 1️⃣ Collection: `users`
```
users/{userId}
├── uid: string
├── email: string
├── displayName: string
├── photoURL: string
├── role: string ["user" | "guard" | "admin"]
├── isActive: boolean
├── isVerified: boolean
├── isBanned: boolean
├── banReason: string
├── vehicles: array<map>
│   ├── plateNumber: string
│   ├── brand: string
│   ├── model: string
│   ├── color: string
│   ├── year: int
│   ├── type: string ["car" | "motorcycle"]
│   └── isPrimary: boolean
├── academicInfo: map
│   ├── identificationType: string
│   ├── identificationNumber: string
│   ├── faculty: string
│   ├── program: string
│   └── userType: string ["student" | "teacher" | "administrative"]
├── stats: map
│   ├── totalReservations: int
│   ├── completedReservations: int
│   ├── cancelledReservations: int
│   ├── noShowCount: int
│   └── incidentCount: int
├── createdAt: timestamp
├── updatedAt: timestamp
└── lastLoginAt: timestamp
```

### 2️⃣ Collection: `parking_zones`
```
parking_zones/{zoneId}
├── zoneId: string
├── name: string
├── description: string
├── location: map
│   ├── latitude: float
│   ├── longitude: float
│   ├── address: string
│   └── entrance: string
├── capacity: map
│   ├── totalSpots: int
│   ├── availableSpots: int
│   ├── occupiedSpots: int
│   ├── reservedSpots: int
│   └── maintenanceSpots: int
├── schedule: map
│   ├── monday: map { open: string, close: string }
│   ├── tuesday: map { open: string, close: string }
│   ├── wednesday: map { open: string, close: string }
│   ├── thursday: map { open: string, close: string }
│   ├── friday: map { open: string, close: string }
│   ├── saturday: map { open: string, close: string }
│   └── sunday: map { open: string, close: string }
├── isActive: boolean
├── isFull: boolean
├── isOpen: boolean
├── createdAt: timestamp
└── updatedAt: timestamp
```

### 3️⃣ Collection: `parking_spots`
```
parking_spots/{spotId}
├── spotId: string
├── spotNumber: int
├── zoneId: string (FK → parking_zones)
├── zoneName: string
├── status: string ["available" | "occupied" | "reserved" | "maintenance"]
├── isActive: boolean
├── type: string ["regular" | "motorcycle"]
├── currentOccupancy: map
│   ├── userId: string (FK → users)
│   ├── userEmail: string
│   ├── userName: string
│   ├── vehiclePlate: string
│   ├── startTime: timestamp
│   ├── endTime: timestamp
│   ├── reservationId: string (FK → reservations)
│   └── entryLogId: string (FK → entry_exit_logs)
├── createdAt: timestamp
├── updatedAt: timestamp
└── lastOccupiedAt: timestamp
```

### 4️⃣ Collection: `reservations`
```
reservations/{reservationId}
├── reservationId: string
├── userId: string (FK → users)
├── userEmail: string
├── userName: string
├── spotId: string (FK → parking_spots)
├── spotNumber: string
├── zoneId: string (FK → parking_zones)
├── zoneName: string
├── vehicle: map
│   ├── plateNumber: string
│   ├── brand: string
│   ├── model: string
│   ├── color: string
│   └── type: string ["car" | "motorcycle"]
├── time: map
│   ├── startTime: timestamp
│   ├── endTime: timestamp
│   ├── duration: int
│   └── expiresAt: timestamp
├── status: string ["active" | "used" | "expired" | "cancelled"]
├── location: map
│   ├── latitude: float
│   ├── longitude: float
│   ├── distanceToUNSA: float
│   └── wasNearby: boolean
├── checkedInAt: timestamp
├── entryLogId: string (FK → entry_exit_logs)
├── createdAt: timestamp
├── updatedAt: timestamp
├── cancelledAt: timestamp
└── cancellationReason: string
```

### 5️⃣ Collection: `entry_exit_logs`
```
entry_exit_logs/{logId}
├── logId: string
├── type: string ["entry" | "exit"]
├── userId: string (FK → users)
├── userEmail: string
├── userName: string
├── userRole: string
├── guardId: string (FK → users)
├── guardEmail: string
├── guardName: string
├── spotId: string (FK → parking_spots)
├── spotNumber: string
├── zoneId: string (FK → parking_zones)
├── zoneName: string
├── vehicle: map
│   ├── plateNumber: string
│   ├── brand: string
│   ├── model: string
│   ├── color: string
│   └── type: string ["car" | "motorcycle"]
├── reservationId: string (FK → reservations)
├── hadReservation: boolean
├── entryTime: timestamp
├── exitTime: timestamp
├── duration: int
├── relatedEntryLogId: string (FK → entry_exit_logs)
├── notes: string
└── createdAt: timestamp
```

### 6️⃣ Collection: `incidents`
```
incidents/{incidentId}
├── incidentId: string
├── type: string ["no_show" | "late_arrival" | "unauthorized_parking" | "damage" | "traffic_violation" | "other"]
├── severity: string ["low" | "medium" | "high"]
├── userId: string (FK → users)
├── userEmail: string
├── userName: string
├── reportedBy: string (FK → users)
├── reportedByEmail: string
├── reportedByName: string
├── reportedByRole: string ["guard" | "admin" | "system"]
├── description: string
├── relatedData: map
│   ├── reservationId: string
│   ├── spotId: string
│   ├── zoneId: string
│   ├── entryLogId: string
│   └── vehiclePlate: string
├── evidence: array<map>
│   ├── type: string ["photo" | "document"]
│   ├── url: string
│   └── uploadedAt: timestamp
├── status: string ["pending" | "reviewed" | "resolved" | "dismissed"]
├── resolution: map
│   ├── resolvedBy: string
│   ├── resolvedAt: timestamp
│   ├── action: string
│   └── notes: string
├── createdAt: timestamp
└── updatedAt: timestamp
```

### 7️⃣ Collection: `notifications`
```
notifications/{notificationId}
├── notificationId: string
├── userId: string (FK → users)
├── type: string ["zone_available" | "zone_full" | "reservation_reminder" | "reservation_expiring" | "reservation_expired" | "nearby_university" | "incident_reported" | "account_warning" | "account_suspended" | "system"]
├── title: string
├── message: string
├── priority: string ["low" | "normal" | "high"]
├── data: map
│   ├── reservationId: string
│   ├── zoneId: string
│   ├── incidentId: string
│   └── actionUrl: string
├── isRead: boolean
├── readAt: timestamp
├── isSent: boolean
├── sentAt: timestamp
└── createdAt: timestamp
```

### 8️⃣ Collection: `app_settings`
```
app_settings/config
├── reservationSettings: map
│   ├── enabled: boolean
│   ├── maxDurationMinutes: int
│   ├── minDurationMinutes: int
│   ├── maxDistanceMeters: int
│   └── maxActiveReservations: int
├── incidentSettings: map
│   ├── noShowWarningLimit: int
│   ├── noShowSuspensionLimit: int
│   ├── noShowBanLimit: int
│   └── suspensionDurationDays: int
├── universityLocation: map
│   ├── latitude: float
│   ├── longitude: float
│   └── name: string
├── systemSettings: map
│   ├── maintenanceMode: boolean
│   ├── maintenanceMessage: string
│   └── minAppVersion: string
├── updatedAt: timestamp
└── updatedBy: string (FK → users)
```

---

## 📊 TABLA RESUMEN DE CAMPOS

| Colección | Campos Totales | FKs | Obligatorios | Opcionales |
|-----------|----------------|-----|--------------|------------|
| **users** | 18 | 0 | 13 | 5 |
| **parking_zones** | 14 | 0 | 13 | 1 |
| **parking_spots** | 12 | 1 | 9 | 3 |
| **reservations** | 20 | 3 | 16 | 4 |
| **entry_exit_logs** | 23 | 4 | 18 | 5 |
| **incidents** | 18 | 1 | 11 | 7 |
| **notifications** | 13 | 1 | 9 | 4 |
| **app_settings** | 15 | 1 | 14 | 1 |
| **TOTAL** | **133** | **11** | **103** | **30** |

---

**FIN DEL DOCUMENTO** - Total: 8 colecciones, 133 campos, 11 relaciones FK

