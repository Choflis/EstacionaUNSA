# REGISTRO DE DEFECTOS - BACKEND
**Responsable:** Fernando Garambel
**Fecha:** 02 de Diciembre, 2024
**Fase:** 5 - Gestión de Defectos

---

## 📊 Resumen de Defectos

| Severidad | Cantidad | Estado |
|-----------|----------|--------|
| 🔴 **Crítico** | 3 | 3 Resueltos / 0 Pendientes |
| 🟠 **Alto** | 3 | 3 Resueltos / 0 Pendientes |
| 🟡 **Medio** | 2 | 1 Resuelto / 1 Pendiente |
| 🟢 **Bajo** | 2 | 1 Resuelto / 1 Pendiente |
| **TOTAL** | **10** | **8 Resueltos / 2 Pendientes** |

---

## 📝 Detalle de Defectos

### 🔴 DEF-001: Dependencia Faltante `flutter_local_notifications`
- **ID:** DEF-001 (E001-E015)
- **Origen:** Fase 1 - Análisis Estático
- **Severidad:** Crítica
- **Prioridad:** Alta
- **Componente:** `MessagingService`
- **Descripción:** El paquete `flutter_local_notifications` no está declarado en `pubspec.yaml` pero se intenta importar, causando 19 errores de compilación y rompiendo la funcionalidad de notificaciones.
- **Pasos para reproducir:**
  1. Ejecutar `flutter analyze`
  2. Observar errores en `lib/services/firebase/messaging_service.dart`
- **Estado:** ✅ **RESUELTO**
- **Solución:** Se agregó la dependencia `flutter_local_notifications: ^18.0.1` en `pubspec.yaml`.

### 🔴 DEF-006: Reglas de Firestore Bloquean Reservas
- **ID:** DEF-006
- **Origen:** Fase 4 - Ejecución (INT-002)
- **Severidad:** Crítica
- **Prioridad:** Inmediata
- **Componente:** `firestore.rules`
- **Descripción:** Las reglas de seguridad no permitían la transición de estado de `available` a `reserved` para usuarios autenticados, impidiendo crear reservas.
- **Pasos para reproducir:**
  1. Intentar crear una reserva desde la app.
  2. Observar error de permisos en logs de Firestore.
- **Estado:** ✅ **RESUELTO** (Fix aplicado en commit `127e3e7`)
- **Solución:** Se actualizaron las reglas para permitir transiciones de estado explícitas.

### 🔴 DEF-007: `currentOccupancy` No Se Elimina al Cancelar
- **ID:** DEF-007
- **Origen:** Fase 4 - Ejecución (INT-002)
- **Severidad:** Alta
- **Prioridad:** Alta
- **Componente:** `FirestoreService`
- **Descripción:** Al cancelar una reserva o liberar un spot, el campo `currentOccupancy` quedaba con datos basura en lugar de eliminarse, causando inconsistencias.
- **Pasos para reproducir:**
  1. Cancelar una reserva activa.
  2. Verificar documento en `parking_spots`.
  3. `currentOccupancy` sigue existiendo con valores null o viejos.
- **Estado:** ✅ **RESUELTO** (Fix aplicado en commit `127e3e7`)
- **Solución:** Se implementó `FieldValue.delete()` cuando `occupancy` es null.

### 🟠 DEF-008: Falta de Expiración Automática de Reservas
- **ID:** DEF-008
- **Origen:** Fase 4 - Ejecución
- **Severidad:** Alta
- **Prioridad:** Alta
- **Componente:** `ReservationProvider`
- **Descripción:** Las reservas no expiraban automáticamente al cumplirse el tiempo, manteniendo los spots ocupados indefinidamente.
- **Pasos para reproducir:**
  1. Crear reserva de 1 minuto.
  2. Esperar 2 minutos.
  3. Verificar que el spot sigue `reserved`.
- **Estado:** ✅ **RESUELTO** (Fix aplicado en commit `127e3e7`)
- **Solución:** Se implementó un Timer en `ReservationProvider` y un wrapper `ExpirationCheckerWrapper`.

### 🟠 DEF-002: Import Sin Usar en `home_screen.dart`
- **ID:** DEF-002 (CS004)
- **Origen:** Fase 1 - Análisis Estático
- **Severidad:** Alta (Code Smell)
- **Prioridad:** Media
- **Componente:** `HomeScreen`
- **Descripción:** Import de `firebase_auth` no utilizado. Aumenta el acoplamiento innecesariamente.
- **Estado:** ✅ **RESUELTO**
- **Solución:** Se eliminó el import innecesario en `lib/screens/home_screen.dart`.

### 🟡 DEF-005: `UserModel.toMap` Difícil de Testear
- **ID:** DEF-005
- **Origen:** Fase 4 - Ejecución (UNIT-005)
- **Severidad:** Media
- **Prioridad:** Media
- **Componente:** `UserModel`
- **Descripción:** El método `toMap` usa `FieldValue.serverTimestamp()` directamente, lo que hace fallar los tests unitarios que no tienen conexión a Firebase.
- **Pasos para reproducir:**
  1. Ejecutar test unitario de `toMap`.
  2. Observar error de casting `FieldValue` vs `Timestamp`.
- **Estado:** ⏳ Pendiente (Workaround aplicado en tests)

### 🟡 DEF-003: Uso de API Deprecada `withOpacity`
- **ID:** DEF-003 (CS003)
- **Origen:** Fase 1 - Análisis Estático
- **Severidad:** Media
- **Prioridad:** Baja
- **Componente:** `LoginScreen`
- **Descripción:** 6 usos de `.withOpacity()` que está deprecado en versiones recientes de Flutter.
- **Estado:** ✅ **RESUELTO**
- **Solución:** Se migró todo el código a `.withValues(alpha: ...)` en `LoginScreen`.

### 🟢 DEF-004: Mensaje de Error Confuso en Validación
- **ID:** DEF-004
- **Origen:** Fase 4 - Ejecución (UNIT-004)
- **Severidad:** Baja
- **Prioridad:** Baja
- **Componente:** `ReservationProvider`
- **Descripción:** Al validar un spot inexistente, retorna "Ya tienes una reserva activa" en lugar de "El espacio no existe".
- **Estado:** ⏳ Pendiente

### 🟢 DEF-009: Excesivo Uso de `print()`
- **ID:** DEF-009 (CS002)
- **Origen:** Fase 1 - Análisis Estático
- **Severidad:** Baja
- **Prioridad:** Baja
- **Componente:** Varios
- **Descripción:** 97 instancias de `print()` en código de producción. Deberían reemplazarse por un logger estructurado.
- **Estado:** ⏳ Pendiente

### 🟢 DEF-010: Campos Privados No Finales
- **ID:** DEF-010
- **Origen:** Fase 1 - Análisis Estático
- **Severidad:** Baja
- **Prioridad:** Baja
- **Componente:** `NotificationProvider`
- **Descripción:** Campos privados que nunca se reasignan deberían ser `final`.
- **Estado:** ✅ **RESUELTO**
- **Solución:** Se agregaron modificadores `final` a los campos correspondientes en `NotificationProvider`.

---

## 🚀 Plan de Corrección (Próximos Pasos)

1. **Prioridad Inmediata:**
   - [ ] Corregir `DEF-001` agregando `flutter_local_notifications` a `pubspec.yaml`.
   
2. **Prioridad Media:**
   - [ ] Refactorizar `UserModel` para testabilidad (`DEF-005`).
   - [ ] Limpiar imports y warnings (`DEF-002`, `DEF-003`).

3. **Deuda Técnica:**
   - [ ] Reemplazar `print()` con Logger (`DEF-009`).
