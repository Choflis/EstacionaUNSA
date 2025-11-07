# 🗄️ Base de Datos - EstacionaUNSA

Documentación completa de la base de datos Firestore del proyecto EstacionaUNSA.

---

## 📊 Diagrama Entidad-Relación

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

## 📦 Estructura de Colecciones

```
firestore/
├── users/                  # Usuarios del sistema
├── parking_zones/          # Zonas de estacionamiento
├── parking_spots/          # Espacios individuales
├── reservations/           # Reservas activas
├── entry_exit_logs/        # Logs de entrada/salida
├── incidents/              # Incidencias reportadas
├── notifications/          # Notificaciones push
└── app_settings/           # Configuración global
```

### Resumen de Colecciones

| # | Colección | Docs Aprox | Descripción | Usuarios |
|---|-----------|------------|-------------|----------|
| 1 | **users** | 500-1000 | Todos los usuarios del sistema | Todos |
| 2 | **parking_zones** | 3 | Las 3 zonas principales | Admin |
| 3 | **parking_spots** | 120-150 | Espacios individuales | Todos |
| 4 | **reservations** | 50-100 | Reservas activas (corta duración) | Usuarios |
| 5 | **entry_exit_logs** | Miles | Historial de entradas/salidas | Guard, Admin |
| 6 | **incidents** | 100-500 | Incidencias y penalizaciones | Guard, Admin |
| 7 | **notifications** | Miles | Notificaciones push | Usuarios |
| 8 | **app_settings** | 1 | Configuración global | Admin |

---

## 🎯 Vista General del Sistema

```
┌───────────────────────────────────────────────────────────────────┐
│                     ESTACIONA UNSA - DATABASE                      │
│                                                                    │
│  👥 ROLES:                                                         │
│  ├─ user         → Usuario regular (estudiantes, docentes, etc.) │
│  ├─ guard        → Vigilante (registra entrada/salida)           │
│  └─ admin        → Administrador (gestión total)                  │
│                                                                    │
│  🅿️ ZONAS: 3 zonas (una por entrada UNSA)                         │
│  ├─ Zona A - Entrada Principal (50 espacios)                     │
│  ├─ Zona B - Biblioteca Central (30 espacios)                    │
│  └─ Zona C - Ingenierías (40 espacios)                           │
│                                                                    │
│  ⏱️ RESERVAS:                                                      │
│  ├─ Solo cuando estás a ≤ 500m de UNSA                          │
│  ├─ Duración: 15 minutos máximo                                  │
│  └─ 1 reserva activa por usuario                                 │
│                                                                    │
│  ⚠️ INCIDENCIAS:                                                   │
│  ├─ 3 no-show → Advertencia                                      │
│  ├─ 5 no-show → Suspensión 7 días                                │
│  └─ 10 no-show → Baneo permanente                                │
└───────────────────────────────────────────────────────────────────┘
```

---

## 📋 Modelos Detallados

### 1. Colección: `users`

**Descripción:** Almacena información de todos los usuarios del sistema.

```typescript
{
  uid: string,                    // PK - ID de Firebase Auth
  email: string,                  // Correo @unsa.edu.pe
  displayName: string,            // Nombre completo
  photoURL?: string,              // URL de foto de perfil
  role: 'user' | 'guard' | 'admin',
  vehicles: [                     // Array de vehículos
    {
      plate: string,              // Placa del vehículo
      type: 'car' | 'motorcycle',
      model?: string,
      color?: string
    }
  ],
  stats: {
    totalReservations: number,    // Total de reservas hechas
    activeReservations: number,   // Reservas activas (max 1)
    completedReservations: number,
    noShowCount: number,          // Veces que no llegó
    bannedUntil?: timestamp       // Suspensión temporal
  },
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**Restricciones:**
- Email debe terminar en `@unsa.edu.pe`
- Solo puede tener 1 reserva activa
- `noShowCount` incrementa automáticamente
- Si `noShowCount >= 5`, se agrega `bannedUntil`

---

### 2. Colección: `parking_zones`

**Descripción:** Las 3 zonas principales de estacionamiento.

```typescript
{
  zoneId: string,                 // PK - "zone_a", "zone_b", "zone_c"
  name: string,                   // "Entrada Principal"
  description: string,
  location: {
    latitude: number,
    longitude: number,
    address: string
  },
  capacity: {
    totalSpots: number,           // Total de espacios
    availableSpots: number,       // Espacios libres
    reservedSpots: number,        // Espacios reservados
    occupiedSpots: number         // Espacios ocupados
  },
  schedule: {
    openTime: string,             // "06:00"
    closeTime: string,            // "22:00"
    daysOpen: string[]            // ["Mon", "Tue", "Wed", ...]
  },
  isActive: boolean,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**Datos iniciales:**
- Zona A: Entrada Principal (50 espacios)
- Zona B: Biblioteca Central (30 espacios)
- Zona C: Ingenierías (40 espacios)

---

### 3. Colección: `parking_spots`

**Descripción:** Espacios individuales dentro de cada zona.

```typescript
{
  spotId: string,                 // PK - "A-001", "B-015", etc.
  zoneId: string,                 // FK - Referencia a parking_zones
  spotNumber: string,             // "001", "002", etc.
  type: 'car' | 'motorcycle',
  status: 'available' | 'reserved' | 'occupied',
  isActive: boolean,              // Si el espacio está habilitado
  currentReservation?: {
    reservationId: string,
    userId: string,
    expiresAt: timestamp
  },
  features: string[],             // ["covered", "disabled", "electric"]
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**Nomenclatura:**
- Zona A: `A-001` hasta `A-050`
- Zona B: `B-001` hasta `B-030`
- Zona C: `C-001` hasta `C-040`

---

### 4. Colección: `reservations`

**Descripción:** Reservas activas de los usuarios.

```typescript
{
  reservationId: string,          // PK - Auto-generado
  userId: string,                 // FK - Referencia a users
  spotId: string,                 // FK - Referencia a parking_spots
  zoneId: string,                 // FK - Referencia a parking_zones
  time: {
    startedAt: timestamp,
    expiresAt: timestamp,         // startedAt + 15 min
    durationMinutes: number       // 15
  },
  status: 'active' | 'completed' | 'cancelled' | 'expired' | 'no_show',
  location: {
    latitude: number,             // Ubicación del usuario al reservar
    longitude: number,
    distanceToZone: number        // Metros hasta la zona
  },
  createdAt: timestamp,
  updatedAt: timestamp,
  completedAt?: timestamp,
  cancelledAt?: timestamp
}
```

**Reglas de negocio:**
- Usuario solo puede tener 1 reserva activa
- Reserva expira en 15 minutos
- Solo se puede reservar si estás a ≤ 500m de la zona
- Si no llegas en 15 min → status = 'no_show'

---

### 5. Colección: `entry_exit_logs`

**Descripción:** Registro de todas las entradas y salidas.

```typescript
{
  logId: string,                  // PK - Auto-generado
  userId: string,                 // FK - Usuario del vehículo
  spotId: string,                 // FK - Espacio usado
  zoneId: string,                 // FK - Zona
  reservationId?: string,         // FK - Reserva asociada (opcional)
  guardId: string,                // FK - Vigilante que registró
  type: 'entry' | 'exit',
  vehiclePlate: string,
  timestamp: timestamp,
  notes?: string,                 // Observaciones del vigilante
  createdAt: timestamp
}
```

**Usos:**
- Historial completo de uso
- Auditoría de accesos
- Estadísticas de uso
- Reportes para administradores

---

### 6. Colección: `incidents`

**Descripción:** Incidencias reportadas por vigilantes.

```typescript
{
  incidentId: string,             // PK - Auto-generado
  userId: string,                 // FK - Usuario involucrado
  reportedBy: string,             // FK - Vigilante que reportó
  type: 'no_show' | 'wrong_spot' | 'overstay' | 'damage' | 'other',
  severity: 'low' | 'medium' | 'high',
  description: string,
  spotId?: string,
  zoneId?: string,
  reservationId?: string,
  evidence?: {
    photoURL?: string,
    timestamp: timestamp
  },
  status: 'open' | 'resolved' | 'dismissed',
  resolution?: {
    action: string,
    resolvedBy: string,
    resolvedAt: timestamp,
    notes: string
  },
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**Tipos de incidencias:**
- `no_show`: Usuario reservó pero no llegó
- `wrong_spot`: Estacionado en espacio incorrecto
- `overstay`: Excedió tiempo permitido
- `damage`: Daño a propiedad
- `other`: Otras incidencias

---

### 7. Colección: `notifications`

**Descripción:** Notificaciones push a usuarios.

```typescript
{
  notificationId: string,         // PK - Auto-generado
  userId: string,                 // FK - Destinatario
  type: 'reservation_confirmed' | 'reservation_expiring' | 
        'spot_available' | 'incident_reported' | 'system',
  title: string,
  body: string,
  data?: {                        // Datos adicionales
    reservationId?: string,
    spotId?: string,
    incidentId?: string
  },
  isRead: boolean,
  sentAt: timestamp,
  readAt?: timestamp
}
```

**Tipos de notificaciones:**
- Reserva confirmada
- Recordatorio (5 min antes de expirar)
- Espacio liberado en zona favorita
- Incidencia reportada
- Mensajes del sistema

---

### 8. Colección: `app_settings`

**Descripción:** Configuración global del sistema (1 documento único).

```typescript
{
  settingsId: "global_settings",  // PK - Siempre el mismo ID
  reservation: {
    maxDurationMinutes: number,   // 15
    maxDistanceMeters: number,    // 500
    maxActivePerUser: number      // 1
  },
  penalties: {
    warningThreshold: number,     // 3 no-shows
    suspensionThreshold: number,  // 5 no-shows
    suspensionDays: number,       // 7 días
    banThreshold: number          // 10 no-shows
  },
  features: {
    enableReservations: boolean,
    enableNotifications: boolean,
    enableIncidents: boolean
  },
  maintenance: {
    isActive: boolean,
    message?: string,
    startAt?: timestamp,
    endAt?: timestamp
  },
  updatedAt: timestamp,
  updatedBy: string               // userId del admin
}
```

---

## 🔄 Flujo de Datos Principal

### 1. Usuario se acerca a UNSA

```
1. App detecta ubicación del usuario
2. Si distancia ≤ 500m → Habilitar reservas
3. Mostrar zonas disponibles con espacios libres
```

### 2. Usuario hace reserva

```
1. Usuario selecciona zona
2. Sistema verifica:
   - ¿Usuario tiene reserva activa? → NO
   - ¿Hay espacios disponibles? → SÍ
   - ¿Usuario está a ≤ 500m? → SÍ
3. Sistema crea documento en reservations/
4. Actualiza parking_spots/ (status = 'reserved')
5. Actualiza parking_zones/ (reservedSpots++)
6. Envía notificación confirmación
7. Inicia timer de 15 minutos
```

### 3. Usuario llega y vigilante registra entrada

```
1. Vigilante escanea placa o CUI
2. Sistema busca reserva activa del usuario
3. Crea documento en entry_exit_logs/ (type = 'entry')
4. Actualiza reservations/ (status = 'completed')
5. Actualiza parking_spots/ (status = 'occupied')
6. Actualiza parking_zones/ (reservedSpots--, occupiedSpots++)
```

### 4. Usuario sale y vigilante registra salida

```
1. Vigilante registra salida
2. Crea documento en entry_exit_logs/ (type = 'exit')
3. Actualiza parking_spots/ (status = 'available')
4. Actualiza parking_zones/ (occupiedSpots--, availableSpots++)
5. Actualiza users/stats (completedReservations++)
```

---

## 🔒 Reglas de Seguridad

Las reglas de Firestore están en `firestore.rules`. Principales restricciones:

| Colección | Lectura | Escritura | Eliminación |
|-----------|---------|-----------|-------------|
| `users` | Usuario mismo | Usuario mismo | ❌ |
| `parking_zones` | ✅ Todos auth | Admin | Admin |
| `parking_spots` | ✅ Todos auth | Guards/Admin | Admin |
| `reservations` | Usuario mismo | Usuario mismo | ❌ |
| `entry_exit_logs` | Usuario/Guards | Guards/Admin | ❌ |
| `incidents` | Usuario/Guards | Guards/Admin | Admin |
| `notifications` | Usuario mismo | Sistema | Usuario mismo |
| `app_settings` | ✅ Todos auth | Admin | ❌ |

**Restricciones especiales:**
- Email debe ser `@unsa.edu.pe`
- Solo 1 reserva activa por usuario
- Guards solo pueden crear logs donde ellos son el guard
- No se pueden eliminar logs ni reservas (solo actualizar status)

---

## 📊 Índices Recomendados

Para optimizar queries, crear estos índices compuestos en Firestore:

1. **reservations**: `userId` + `status` (ASC)
2. **parking_spots**: `zoneId` + `status` (ASC)
3. **entry_exit_logs**: `userId` + `timestamp` (DESC)
4. **incidents**: `userId` + `status` (ASC)
5. **notifications**: `userId` + `isRead` + `sentAt` (DESC)

Firestore sugerirá estos índices automáticamente al hacer queries.

---

## 🚀 Inicialización de Datos

Ver archivo `lib/utils/firestore_seed.dart` para el script de inicialización que crea:

- 3 zonas de estacionamiento
- 120 espacios distribuidos
- Configuración global del sistema

---

**Documentación actualizada:** Noviembre 2024
