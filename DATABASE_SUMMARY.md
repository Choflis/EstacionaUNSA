# 📊 Resumen Visual - Base de Datos EstacionaUNSA

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
│  ├─ Zona Entrada Principal                                       │
│  ├─ Zona Entrada Secundaria                                      │
│  └─ Zona Entrada Lateral                                         │
│                                                                    │
│  ⏱️ RESERVAS:                                                      │
│  ├─ Solo cuando estás a ≤ 500m de UNSA                          │
│  ├─ Duración: 10-15 minutos máximo                              │
│  └─ 1 reserva activa por usuario                                 │
│                                                                    │
│  ⚠️ INCIDENCIAS:                                                   │
│  ├─ 3 no-show → Advertencia                                      │
│  ├─ 5 no-show → Suspensión 7 días                                │
│  └─ 10 no-show → Baneo permanente                                │
└───────────────────────────────────────────────────────────────────┘
```

---

## 📦 Colecciones (8 Total)

| # | Colección | Documentos | Descripción | Principal Para |
|---|-----------|------------|-------------|----------------|
| 1 | **users** | ~500-1000 | Todos los usuarios del sistema | Todos |
| 2 | **parking_zones** | 3 | Las 3 zonas principales | Admin |
| 3 | **parking_spots** | ~150 | Espacios individuales (50 por zona) | Todos |
| 4 | **reservations** | ~50-100 | Reservas activas (corta duración) | Usuarios |
| 5 | **entry_exit_logs** | Miles | Historial de entradas/salidas | Guard, Admin |
| 6 | **incidents** | ~100-500 | Incidencias y penalizaciones | Guard, Admin |
| 7 | **notifications** | Miles | Notificaciones push | Usuarios |
| 8 | **app_settings** | 1 | Configuración global | Admin |

---

## 🔄 Flujo Principal de Uso

### 1️⃣ Usuario se acerca a UNSA

```
Usuario abre app
    ↓
App detecta ubicación GPS
    ↓
¿Está a ≤ 500m de UNSA? ─── NO ──→ "Debes estar cerca de UNSA para reservar"
    │
    SÍ
    ↓
Habilita botón "Reservar Espacio"
    ↓
Usuario selecciona zona
    ↓
Sistema muestra espacios disponibles
    ↓
Usuario reserva espacio (duración: 15 min)
    ↓
RESERVA CREADA
    │
    ├──→ parking_spot.status = "reserved"
    ├──→ parking_zone.reservedSpots++
    └──→ Notificación: "Reserva confirmada - Tienes 15 min"
```

### 2️⃣ Usuario llega a la entrada (Vigilante)

```
Vigilante abre "Registrar Entrada"
    ↓
Ingresa placa del vehículo
    ↓
Sistema busca reserva activa
    │
    ├─── TIENE RESERVA ──→ Marca reserva como "used"
    │                       └─→ Asigna espacio reservado
    │
    └─── NO TIENE ──────→ Busca espacio disponible
                           └─→ Asigna espacio libre
    ↓
ENTRADA REGISTRADA
    │
    ├──→ entry_exit_logs (nuevo registro)
    ├──→ parking_spot.status = "occupied"
    ├──→ parking_zone.occupiedSpots++
    └──→ Notificación: "Bienvenido - Espacio A-005"
```

### 3️⃣ Usuario sale (Vigilante)

```
Vigilante abre "Registrar Salida"
    ↓
Ingresa placa del vehículo
    ↓
Sistema busca registro de entrada activo
    ↓
SALIDA REGISTRADA
    │
    ├──→ entry_exit_logs (actualiza con hora salida)
    ├──→ parking_spot.status = "available"
    ├──→ parking_zone.occupiedSpots--
    └──→ Notificación a usuarios: "Espacio disponible en Zona A"
```

### 4️⃣ Usuario NO llega (Automático)

```
Cloud Function cada 1 minuto
    ↓
Busca reservas con expiresAt <= now
    ↓
RESERVA EXPIRADA
    │
    ├──→ reservation.status = "expired"
    ├──→ parking_spot.status = "available"
    ├──→ parking_zone.reservedSpots--
    ├──→ CREA INCIDENCIA (type: "no_show")
    ├──→ user.stats.noShowCount++
    └──→ Si noShowCount >= 3 → Advertencia
         Si noShowCount >= 5 → Suspensión 7 días
         Si noShowCount >= 10 → Baneo permanente
```

---

## 📱 Casos de Uso vs Colecciones

| Caso de Uso | Colecciones Involucradas |
|-------------|--------------------------|
| **CU01** - Iniciar sesión | `users` |
| **CU02** - Consultar disponibilidad | `parking_zones`, `parking_spots` |
| **CU03** - Visualizar mapa campus | `parking_zones` |
| **CU04** - Registrar entrada | `entry_exit_logs`, `parking_spots`, `users`, `reservations` |
| **CU05** - Registrar salida | `entry_exit_logs`, `parking_spots`, `notifications` |
| **CU06** - Recibir notificaciones | `notifications` |
| **CU07** - Gestionar usuarios | `users` |
| **CU08** - Gestionar estacionamientos | `parking_zones`, `parking_spots` |
| **CU09** - Generar reportes | `entry_exit_logs`, `incidents`, `reservations` |
| **CU10** - Reportar incidencia | `incidents`, `users` |

---

## 🔐 Permisos por Rol

| Operación | user | guard | admin |
|-----------|------|-------|-------|
| Ver disponibilidad | ✅ | ✅ | ✅ |
| Crear reserva | ✅ | ❌ | ✅ |
| Registrar entrada/salida | ❌ | ✅ | ✅ |
| Reportar incidencia | ❌ | ✅ | ✅ |
| Resolver incidencia | ❌ | ❌ | ✅ |
| Gestionar usuarios | ❌ | ❌ | ✅ |
| Gestionar zonas | ❌ | ❌ | ✅ |
| Ver reportes | ❌ | ✅ (limitado) | ✅ |
| Modificar config | ❌ | ❌ | ✅ |

---

## 🎨 Estados y Transiciones

### Estado de Parking Spot

```
┌─────────────┐
│  AVAILABLE  │ ◄──────────┐
└──────┬──────┘            │
       │                   │
       │ (reserva)         │ (sale/cancela/expira)
       ↓                   │
┌─────────────┐            │
│  RESERVED   │ ───────────┤
└──────┬──────┘            │
       │                   │
       │ (entra)           │
       ↓                   │
┌─────────────┐            │
│  OCCUPIED   │ ───────────┘
└─────────────┘

┌─────────────┐
│ MAINTENANCE │ (estado especial, solo admin)
└─────────────┘
```

### Estado de Reserva

```
┌────────┐
│ ACTIVE │ ──┬── (usuario entra) ───→ USED
└────────┘   │
             ├── (expira tiempo) ───→ EXPIRED ──→ Crea INCIDENCIA
             │
             └── (usuario cancela) ─→ CANCELLED
```

### Estado de Incidencia

```
┌─────────┐
│ PENDING │ ──┬── (admin revisa) ──→ REVIEWED ──→ RESOLVED
└─────────┘   │
              └── (admin descarta) ──→ DISMISSED
```

---

## 📊 Métricas y Analytics

### Métricas en Tiempo Real
- Espacios disponibles por zona
- Espacios ocupados totales
- Reservas activas
- Usuarios conectados

### Métricas Históricas (admin)
- Promedio de ocupación por día/semana
- Horas pico de uso
- Tasa de no-show por usuario/general
- Zonas más usadas
- Duración promedio de permanencia
- Incidencias por tipo/severidad

---

## 🚀 Tecnologías

| Componente | Tecnología |
|------------|------------|
| Base de Datos | **Cloud Firestore** (NoSQL) |
| Autenticación | **Firebase Auth** (Google Sign-In) |
| Notificaciones | **Firebase Cloud Messaging (FCM)** |
| Geolocalización | **Geolocator** (Flutter package) |
| Mapas | **Google Maps API** |
| Backend Logic | **Cloud Functions** (Node.js/TypeScript) |
| Storage | **Firebase Storage** (evidencia de incidencias) |
| Analytics | **Firebase Analytics** |

---

## 📈 Escalabilidad

| Aspecto | Capacidad Actual | Escalable a |
|---------|------------------|-------------|
| Usuarios | ~1,000 | Ilimitado |
| Zonas | 3 | 10+ |
| Espacios por zona | 50 | 500+ |
| Reservas simultáneas | ~100 | 1,000+ |
| Lecturas/día | ~50K | 1M+ |
| Escrituras/día | ~10K | 500K+ |

**Firestore Plan Spark (Gratis):**
- 50K lecturas/día
- 20K escrituras/día
- 1GB almacenamiento

**Firestore Plan Blaze (Pago por uso):**
- Ilimitado (pagas por uso)
- $0.06 por 100K lecturas
- $0.18 por 100K escrituras

---

## ✅ Checklist de Implementación

### Fase 1: Base de Datos ✅
- [x] Diseño completo de colecciones
- [x] Definir tipos de datos
- [x] Establecer reglas de negocio
- [x] Documentar flujos principales

### Fase 2: Modelos y Servicios (Próximo)
- [ ] Crear modelos Dart
- [ ] Servicios de Firestore
- [ ] Firestore Rules
- [ ] Crear índices

### Fase 3: UI y Funcionalidades
- [ ] Pantallas de usuario
- [ ] Pantallas de vigilante
- [ ] Pantallas de admin
- [ ] Integración Google Maps
- [ ] Sistema de notificaciones

### Fase 4: Cloud Functions
- [ ] Expiración de reservas
- [ ] Actualización de contadores
- [ ] Creación de incidencias
- [ ] Envío de notificaciones

### Fase 5: Testing y Deploy
- [ ] Datos de prueba
- [ ] Testing funcional
- [ ] Testing de seguridad
- [ ] Deploy a producción

---

## 📞 Soporte

Para más detalles ver:
- `DATABASE_DESIGN.md` - Especificación completa
- `casosDeUso.md` - Casos de uso detallados
- `firestore.rules` - Reglas de seguridad

---

**Versión:** 2.0  
**Última actualización:** 2024-10-24  
**Estado:** ✅ Planificación Completa

---

## 📝 QUICK REFERENCE - Colecciones por Campo

### users
`uid, email, displayName, photoURL, role, isActive, isVerified, isBanned, banReason, vehicles[], academicInfo{}, stats{}, createdAt, updatedAt, lastLoginAt`

### parking_zones
`zoneId, name, description, location{}, capacity{}, schedule{}, isActive, isFull, isOpen, createdAt, updatedAt`

### parking_spots
`spotId, spotNumber, zoneId, zoneName, status, isActive, type, currentOccupancy{}, createdAt, updatedAt, lastOccupiedAt`

### reservations
`reservationId, userId, userEmail, userName, spotId, spotNumber, zoneId, zoneName, vehicle{}, time{}, status, location{}, checkedInAt, entryLogId, createdAt, updatedAt, cancelledAt, cancellationReason`

### entry_exit_logs
`logId, type, userId, userEmail, userName, userRole, guardId, guardEmail, guardName, spotId, spotNumber, zoneId, zoneName, vehicle{}, reservationId, hadReservation, entryTime, exitTime, duration, relatedEntryLogId, notes, createdAt`

### incidents
`incidentId, type, severity, userId, userEmail, userName, reportedBy, reportedByEmail, reportedByName, reportedByRole, description, relatedData{}, evidence[], status, resolution{}, createdAt, updatedAt`

### notifications
`notificationId, userId, type, title, message, priority, data{}, isRead, readAt, isSent, sentAt, createdAt`

### app_settings
`reservationSettings{}, incidentSettings{}, universityLocation{}, systemSettings{}, updatedAt, updatedBy`

