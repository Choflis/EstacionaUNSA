# ESTRATEGIA DE PRUEBAS DE INTEGRACIÓN - EstacionaUNSA

**Responsable:** Fernando  
**Fecha:** 29 de Noviembre, 2024  
**Fase:** 2 - Plan de Pruebas

---

## 🎯 Objetivo

Definir la estrategia de pruebas de integración para validar la correcta comunicación entre las diferentes capas de la aplicación EstacionaUNSA, asegurando que los componentes funcionen correctamente cuando se integran.

---

## 🏗️ Arquitectura de la Aplicación

La aplicación sigue una arquitectura en capas:

```
┌─────────────────────────────────────┐
│   UI LAYER (Screens/Widgets)       │
│   - LoginScreen                     │
│   - HomeScreen                      │
│   - ParkingListScreen               │
│   - ReservationScreen               │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   STATE MANAGEMENT (Providers)      │
│   - AuthProvider                    │
│   - ReservationProvider             │
│   - ParkingProvider                 │
│   - NotificationProvider            │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   BUSINESS LOGIC (Services)         │
│   - AuthService                     │
│   - FirestoreService                │
│   - MessagingService                │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   EXTERNAL APIS                     │
│   - Firebase Auth                   │
│   - Cloud Firestore                 │
│   - Firebase Messaging              │
└─────────────────────────────────────┘
```

---

## 🔗 Puntos de Integración Críticos

### 1. **Autenticación (Auth Flow)**
**Flujo:** `UI → AuthProvider → AuthService → Firebase Auth → Firestore`

**Componentes involucrados:**
- `LoginScreen` (UI)
- `AuthProvider` (State Management)
- `AuthService` (Business Logic)
- Firebase Authentication (External API)
- `FirestoreService` (Data Access)

**Puntos de integración a probar:**
- ✅ Provider llama correctamente al servicio
- ✅ Servicio se comunica con Firebase Auth
- ✅ Datos del usuario se crean/actualizan en Firestore
- ✅ Estado de autenticación se propaga a la UI
- ✅ Manejo de errores en toda la cadena

---

### 2. **Gestión de Reservas (Reservation Flow)**
**Flujo:** `UI → ReservationProvider → FirestoreService → Firestore`

**Componentes involucrados:**
- `ReservationScreen` (UI)
- `ReservationProvider` (State Management)
- `FirestoreService` (Data Access)
- Cloud Firestore (External API)

**Puntos de integración a probar:**
- ✅ Creación de reserva actualiza Firestore
- ✅ Estado del spot se actualiza correctamente
- ✅ Validaciones de negocio se ejecutan
- ✅ Streams de datos en tiempo real funcionan
- ✅ Transacciones atómicas se completan

---

### 3. **Carga de Datos de Estacionamiento (Parking Data Flow)**
**Flujo:** `UI → ParkingProvider → FirestoreService → Firestore`

**Componentes involucrados:**
- `ParkingListScreen` (UI)
- `ParkingProvider` (State Management)
- `FirestoreService` (Data Access)
- Cloud Firestore (External API)

**Puntos de integración a probar:**
- ✅ Zonas se cargan correctamente
- ✅ Spots se filtran por zona
- ✅ Disponibilidad se calcula correctamente
- ✅ Actualizaciones en tiempo real funcionan

---

## 🧪 Estrategia de Pruebas de Integración

### Enfoque: **Top-Down Integration Testing**

Comenzaremos probando desde las capas superiores (Providers) hacia las inferiores (Services), validando cada punto de integración.

### Tipos de Pruebas de Integración

#### **A. Integración Provider ↔ Service**
Validar que los Providers llaman correctamente a los Services y manejan las respuestas.

**Técnica:** Mocking de servicios externos (Firebase)

#### **B. Integración Service ↔ Firebase**
Validar que los Services se comunican correctamente con Firebase.

**Técnica:** Pruebas con Firebase Emulator o ambiente de desarrollo

#### **C. Integración End-to-End (E2E)**
Validar flujos completos desde UI hasta persistencia.

**Técnica:** Pruebas manuales con evidencias documentadas

---

## 📋 Casos de Prueba de Integración (3 casos)

### **Caso INT-001: Flujo Completo de Autenticación**
**Descripción:** Validar integración completa desde login hasta carga de datos del usuario

**Componentes integrados:**
- `AuthProvider` → `AuthService` → Firebase Auth → `FirestoreService`

**Escenario:**
1. Usuario inicia sesión con Google
2. AuthService valida correo @unsa.edu.pe
3. Firebase Auth autentica al usuario
4. FirestoreService crea/actualiza documento del usuario
5. AuthProvider actualiza estado y notifica a la UI

**Resultado esperado:**
- Usuario autenticado correctamente
- Documento en Firestore creado/actualizado
- Estado de autenticación propagado a toda la app

---

### **Caso INT-002: Flujo de Creación de Reserva**
**Descripción:** Validar integración completa del proceso de reserva

**Componentes integrados:**
- `ReservationProvider` → `FirestoreService` → Firestore (Transacciones)

**Escenario:**
1. Usuario selecciona un spot disponible
2. ReservationProvider valida que no tenga reservas activas
3. FirestoreService ejecuta transacción para:
   - Crear documento de reserva
   - Actualizar estado del spot a "reserved"
   - Actualizar estadísticas del usuario
4. Provider actualiza estado local
5. UI muestra confirmación

**Resultado esperado:**
- Reserva creada en Firestore
- Spot marcado como reservado
- Estadísticas actualizadas
- Estado sincronizado en tiempo real

---

### **Caso INT-003: Flujo de Sincronización en Tiempo Real**
**Descripción:** Validar que los streams de Firestore actualizan correctamente la UI

**Componentes integrados:**
- `ParkingProvider` → `FirestoreService` → Firestore Streams → UI

**Escenario:**
1. Usuario abre pantalla de zonas de estacionamiento
2. ParkingProvider se suscribe al stream de zonas
3. Otro usuario reserva un spot
4. Firestore emite actualización
5. FirestoreService procesa el cambio
6. ParkingProvider actualiza estado
7. UI refleja disponibilidad actualizada

**Resultado esperado:**
- Cambios en Firestore se reflejan en UI en tiempo real
- Disponibilidad de spots se actualiza automáticamente
- No hay inconsistencias de datos

---

## 🛠️ Herramientas para Pruebas de Integración

### 1. **Flutter Test Framework**
- Pruebas de integración Provider ↔ Service
- Mocking con `mockito` o `mocktail`

### 2. **Firebase Emulator Suite**
- Ambiente local para probar integraciones con Firebase
- Evita costos y contaminar datos de producción

### 3. **Integration Test Package (Flutter)**
- Pruebas E2E automatizadas
- Simula interacciones reales del usuario

### 4. **Pruebas Manuales Documentadas**
- Para flujos complejos que requieren validación visual
- Capturas de pantalla y logs como evidencia

---

## 📊 Criterios de Éxito

Una prueba de integración es exitosa si:

1. ✅ **Comunicación correcta:** Los componentes se comunican sin errores
2. ✅ **Datos consistentes:** Los datos se propagan correctamente entre capas
3. ✅ **Manejo de errores:** Los errores se capturan y manejan apropiadamente
4. ✅ **Estado sincronizado:** El estado de la UI refleja el estado del backend
5. ✅ **Transacciones atómicas:** Las operaciones críticas son atómicas

---

## 🎯 Alcance de las Pruebas de Integración

### **Incluye:**
- ✅ Flujos de autenticación completos
- ✅ Operaciones CRUD de reservas
- ✅ Sincronización en tiempo real
- ✅ Validaciones de negocio entre capas
- ✅ Manejo de errores de red/Firebase

### **No Incluye:**
- ❌ Pruebas unitarias de funciones individuales
- ❌ Pruebas de UI/componentes aislados
- ❌ Pruebas de rendimiento/carga
- ❌ Pruebas de seguridad de Firebase Rules

---

## 📝 Formato de Documentación de Resultados

Para cada caso de integración ejecutado, se documentará:

| Campo | Descripción |
|-------|-------------|
| **ID** | Identificador único (INT-001, INT-002, etc.) |
| **Componentes** | Lista de componentes integrados |
| **Precondiciones** | Estado inicial requerido |
| **Pasos** | Secuencia de acciones |
| **Datos de prueba** | Datos específicos usados |
| **Resultado esperado** | Comportamiento esperado |
| **Resultado obtenido** | Comportamiento real observado |
| **Estado** | ✅ Pasó / ❌ Falló / ⚠️ Bloqueado |
| **Evidencias** | Screenshots, logs, videos |
| **Defectos** | IDs de defectos encontrados |

---

## 🔄 Proceso de Ejecución

1. **Preparación:** Configurar ambiente de pruebas (Firebase Emulator o Dev)
2. **Ejecución:** Ejecutar casos de integración en orden de dependencia
3. **Documentación:** Capturar evidencias (logs, screenshots)
4. **Registro:** Documentar resultados en Excel
5. **Defectos:** Registrar defectos encontrados con severidad
6. **Re-ejecución:** Volver a probar casos fallidos después de correcciones

---

## 📅 Cronograma

| Actividad | Tiempo estimado | Responsable |
|-----------|-----------------|-------------|
| Diseño de casos | 2h | Fernando |
| Configuración de ambiente | 1h | Fernando |
| Ejecución de pruebas | 3h | Fernando |
| Documentación de evidencias | 2h | Fernando |
| **TOTAL** | **8h** | **Fernando** |

---

## 🚨 Riesgos y Mitigaciones

| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Firebase Emulator no disponible | Alto | Usar ambiente de desarrollo con datos de prueba |
| Falta de datos de prueba | Medio | Crear script de seed con datos de prueba |
| Errores de red intermitentes | Bajo | Documentar y reintentar |
| Tiempo insuficiente | Alto | Priorizar casos críticos (Auth y Reservas) |

---

## ✅ Entregables

1. **Documento de estrategia** (este archivo) ✅
2. **3 casos de prueba de integración** (Excel) - Fase 3
3. **Evidencias de ejecución** (logs, screenshots) - Fase 4
4. **Registro de defectos** encontrados - Fase 5

---

**Nota:** Esta estrategia será utilizada por Luis para completar la sección de "Pruebas de Integración" en el Plan de Pruebas de la Fase 2.
