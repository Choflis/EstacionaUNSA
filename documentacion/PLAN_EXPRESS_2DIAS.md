# 🚨 PLAN EXPRESS DE TESTING - 2 DÍAS (27-28 NOV)

**⚠️ ENTREGA URGENTE:** 28 de Noviembre, 2024  
**⏰ TIEMPO DISPONIBLE:** 48 horas  
**👥 EQUIPO:** Luis, Dennis, Fernando

---

## 🎯 ESTRATEGIA EXPRESS

**Objetivo:** Entregar un informe de testing **MÍNIMO VIABLE** que cumpla todos los requisitos pero con alcance reducido.

**Filosofía:** "Menos pruebas, mejor ejecutadas y documentadas"

---

## 📋 DISTRIBUCIÓN POR FASES OFICIALES

### FASE 1: Análisis del Proyecto y Detección Inicial de Errores

**Requisitos:**
- ✅ Análisis estático con herramienta (Dart Analyzer)
- ✅ Revisión de estándares de codificación
- ✅ Identificación de errores: variables sin usar, duplicación, malas prácticas
- ✅ Tabla de hallazgos clasificada por severidad (Crítico, Alto, Medio, Bajo)

**Responsable:** 💻 **Fernando** (4h - Día 1 tarde)
- Ejecutar `flutter analyze > analisis.txt`
- Revisar código manualmente (code smells)
- Crear tabla Excel de hallazgos clasificados
- Identificar 10-15 problemas principales

**Apoyo:** 👨‍💼 Luis (30 min - Día 1 mañana)
- Ejecutar análisis rápido inicial
- Consolidar hallazgos en el plan

---

### FASE 2: Diseño del Plan de Pruebas

**Requisitos:**
- ✅ Alcance y objetivos del plan
- ✅ Módulos, componentes y funciones a probar
- ✅ Tipos de pruebas (unitarias, integración, componentes, funcionales, sistema, UAT)
- ✅ Roles del equipo asignados
- ✅ Herramientas a usar (justificadas)

**Responsable:** 👨‍💼 **Luis** (3h - Día 1 mañana)
- Escribir Plan de Pruebas EXPRESS (2-3 páginas)
- Definir alcance limitado (funcionalidad core)
- Asignar roles del equipo
- Listar y justificar herramientas

**Apoyo:** 🎨 Dennis + 💻 Fernando
- Dennis: Definir módulos UI a probar
- Fernando: Definir estrategia de integración

---

### FASE 3: Diseño de Casos de Prueba

**Requisitos:**
- ✅ Formato completo: ID, Función, Resumen, Precondiciones, Pasos, Datos, Resultado esperado/obtenido, Estado
- ✅ Pruebas Unitarias (funciones críticas, validaciones, reglas de negocio)
- ✅ Pruebas de Integración (API ↔ BD, Frontend ↔ Backend, Servicios internos)
- ✅ Pruebas de Componentes (UI)
- ✅ Pruebas Funcionales (casos de uso reales)
- ✅ Pruebas de Sistema (operación completa)
- ✅ Pruebas de Aceptación UAT (Given-When-Then)

**Distribución:**

**💻 Fernando** (4h - Día 1 mañana + 4h - Día 2 mañana):
- **5 Pruebas Unitarias** (críticas):
  1. AuthService.signInWithGoogle()
  2. FirestoreService.createReservation()
  3. ParkingProvider.loadZones()
  4. ReservationProvider.validateReservation()
  5. UserModel.toMap()/fromMap()

- **3 Pruebas de Integración**:
  1. AuthProvider → AuthService → Firebase
  2. ReservationProvider → FirestoreService → Firestore
  3. UI → Provider → Service (flujo completo)

**🎨 Dennis** (4h - Día 1 mañana + 4h - Día 2 mañana):
- **5 Pruebas de Componentes UI**:
  1. LoginScreen - Validación de formulario
  2. MainNavScreen - Navegación
  3. ProfileScreen - Mostrar datos
  4. ParkingListScreen - Renderizado
  5. CustomButton - Funcionalidad

- **3 Pruebas Funcionales** (casos de uso):
  1. Validación de formulario de login
  2. Navegación entre pantallas
  3. Feedback de errores

**👨‍💼 Luis** (4h - Día 1 tarde):
- **3 Pruebas de Sistema** (end-to-end):
  1. Login → Home → Perfil
  2. Login → Ver zonas → Listar espacios
  3. Login → Crear reserva → Cancelar

- **2 Pruebas UAT** (Given-When-Then):
  1. Usuario reserva espacio exitosamente
  2. Usuario cancela reserva

**Total: 22 casos de prueba**

---

### FASE 4: Ejecución de Pruebas y Evidencias

**Requisitos:**
- ✅ Capturas de pantalla
- ✅ Logs de ejecución
- ✅ Extractos de consola
- ✅ Videos cortos
- ✅ Reportes automáticos (Coverage, etc.)
- ✅ Re-ejecución de pruebas fallidas (si hay tiempo)

**Distribución:**

**🎨 Dennis** (4h - Día 1 tarde):
- Ejecutar los 5 casos de componentes UI
- Capturar 5-10 screenshots
- Grabar 1 video del flujo completo (2-3 min)
- Documentar resultados en Excel

**💻 Fernando** (2h - Día 1 noche - OPCIONAL):
- Escribir código de 3-5 tests unitarios ejecutables
- Ejecutar tests y capturar output
- Generar reporte de coverage (si es posible)

**👨‍💼 Luis** (4h - Día 2 mañana):
- Ejecutar los 5 casos de Sistema/UAT
- Documentar resultados
- Capturar evidencias principales

**🎨 Dennis** (incluido en casos funcionales - Día 2):
- Ejecutar los 3 casos funcionales
- Más screenshots/evidencias

**💻 Fernando** (incluido en integración - Día 2):
- Ejecutar los 3 casos de integración
- Documentar con logs/capturas

---

### FASE 5: Gestión de Defectos y Reporte Final

**Requisitos:**

**5.1. Registro de Defectos** (para cada uno):
- ✅ ID, Descripción, Severidad, Prioridad
- ✅ Pasos para reproducir
- ✅ Evidencias
- ✅ Módulo afectado, Responsable
- ✅ Estado (Nuevo/En proceso/Resuelto/Cerrado)

**5.2. Matriz de Trazabilidad:**
- ✅ Requisitos → Casos de Prueba → Evidencia → Estado

**5.3. Informe Final PDF:**
- ✅ Plan de pruebas
- ✅ Casos de prueba
- ✅ Evidencias
- ✅ Registro de defectos
- ✅ Trazabilidad
- ✅ Mejoras aplicadas
- ✅ Conclusiones del grupo

**Distribución:**

**💻 Fernando** (4h - Día 2 tarde - CRÍTICO):
- **Registro de Defectos Backend** (10-15 defectos):
  - Hallazgos del análisis estático
  - Errores de pruebas unitarias
  - Problemas de integración
  - Code smells críticos
- Clasificar por Severidad y Prioridad
- Documentar pasos para reproducir
- **Archivo:** `REGISTRO_DEFECTOS.xlsx`

**🎨 Dennis** (4h - Día 2 tarde):
- **Registro de Defectos UI** (5-8 defectos):
  - Problemas visuales
  - Inconsistencias de diseño
  - Problemas de usabilidad
  - Errores de validación
- **Archivo:** `DEFECTOS_UI.xlsx`

**👨‍💼 Luis** (4h - Día 2 mañana + 4h - Día 2 tarde - CRÍTICO):
- **Matriz de Trazabilidad**: Tabla en Excel
- **Consolidar Informe Final PDF**:
  1. Portada
  2. Plan de Pruebas
  3. Análisis Estático (tabla de Fernando)
  4. Casos de Prueba (todos los Excel)
  5. Evidencias (screenshots, videos)
  6. Registro de Defectos (Fernando + Dennis)
  7. Matriz de Trazabilidad
  8. Mejoras aplicadas (si hubo correcciones)
  9. Conclusiones del grupo
- **Archivo:** `INFORME_TESTING_FINAL.pdf` (20-30 páginas)

**👥 Todo el equipo** (2h - Día 2 noche):
- Revisión final del PDF
- Verificar cumplimiento de TODOS los requisitos
- Ajustes finales
- **ENTREGAR**

---

## 📊 RESUMEN DE RESPONSABILIDADES POR FASE

| Fase | Luis | Dennis | Fernando |
|------|------|--------|----------|
| **FASE 1** | Análisis inicial (30min) | - | **Análisis completo (4h)** |
| **FASE 2** | **Plan completo (3h)** | Módulos UI | Estrategia integración |
| **FASE 3** | Sistema + UAT (4h) | **Componentes + Funcionales (8h)** | **Unitarias + Integración (8h)** |
| **FASE 4** | **Ejecutar Sistema/UAT (4h)** | **Ejecutar UI + Videos (4h)** | **Tests código + logs (2h)** |
| **FASE 5** | **PDF Final + Matriz (8h)** | Defectos UI (4h) | **Defectos Backend (4h)** |

---

## ⚡ DÍA 1 (27 NOV) - 8-10 HORAS

### 🌅 MAÑANA (8:00 AM - 12:00 PM) - 4 HORAS

#### 👨‍💼 Luis (4h)
**FASE 1-2: Análisis Rápido + Plan Básico**
- ✅ Ejecutar `flutter analyze` (30 min)
- ✅ Consolidar hallazgos en tabla simple (30 min)
- ✅ Escribir Plan de Pruebas BÁSICO (3h)
  - Alcance limitado (solo funcionalidad core)
  - Tipos de prueba (lista simple)
  - Roles del equipo (tabla)
  - Herramientas (lista)

**📝 ENTREGABLE:** `PLAN_PRUEBAS_EXPRESS.md` (2-3 páginas)

---

#### 🎨 Dennis (4h)
**FASE 3: Casos de Prueba UI (los más críticos)**
- ✅ **5 casos** de prueba de componentes:
  1. LoginScreen - Validación de formulario
  2. MainNavScreen - Navegación
  3. ProfileScreen - Mostrar datos
  4. ParkingListScreen - Renderizado
  5. CustomButton - Funcionalidad
  
**📝 ENTREGABLE:** `CASOS_PRUEBA_UI.xlsx` (5 casos completos)

---

#### 💻 Fernando (4h)
**FASE 3: Casos de Prueba Backend (críticos)**
- ✅ **5 casos** de prueba unitarias:
  1. AuthService.signInWithGoogle()
  2. FirestoreService.createReservation()
  3. ParkingProvider.loadZones()
  4. ReservationProvider.validateReservation()
  5. UserModel.toMap()/fromMap()

**📝 ENTREGABLE:** `CASOS_PRUEBA_BACKEND.xlsx` (5 casos completos)

---

### 🌆 TARDE (2:00 PM - 6:00 PM) - 4 HORAS

#### 👨‍💼 Luis (4h)
**FASE 3: Casos de Prueba de Sistema**
- ✅ **3 flujos** end-to-end críticos:
  1. Login → Home → Perfil
  2. Login → Ver zonas → Listar espacios
  3. Login → Crear reserva → Cancelar

**FASE 3: Casos UAT (Given-When-Then)**
- ✅ **2 escenarios** de aceptación:
  1. Usuario reserva espacio exitosamente
  2. Usuario cancela reserva

**📝 ENTREGABLE:** `CASOS_SISTEMA_UAT.xlsx` (5 casos)

---

#### 🎨 Dennis (4h)
**FASE 4: Ejecución + Evidencias UI**
- ✅ Ejecutar los 5 casos de prueba
- ✅ Capturar screenshots (5-10 capturas)
- ✅ Grabar 1 video corto (2-3 min) del flujo completo
- ✅ Documentar resultados en Excel

**📝 ENTREGABLE:** Screenshots + Video + Resultados

---

#### 💻 Fernando (4h)
**FASE 1: Análisis Estático Detallado**
- ✅ Ejecutar `flutter analyze > analisis.txt`
- ✅ Revisar código manualmente (code smells)
- ✅ Crear tabla de hallazgos clasificados
- ✅ Identificar 10-15 problemas principales

**📝 ENTREGABLE:** `ANALISIS_ESTATICO.xlsx` (tabla completa)

---

### 🌙 NOCHE OPCIONAL (8:00 PM - 10:00 PM) - 2 HORAS

#### 💻 Fernando (2h)
**FASE 4: Escribir pruebas unitarias básicas**
- ✅ Crear archivo `test/unit_test.dart`
- ✅ Escribir 3-5 tests reales ejecutables
- ✅ Ejecutar y capturar output
- ✅ Generar coverage básico (si es posible)

**📝 ENTREGABLE:** Código de tests + Output

---

## ⚡ DÍA 2 (28 NOV) - 8-10 HORAS

### 🌅 MAÑANA (8:00 AM - 12:00 PM) - 4 HORAS

#### 👨‍💼 Luis (4h)
**FASE 4: Ejecutar casos de Sistema/UAT**
- ✅ Ejecutar los 5 casos de sistema/UAT
- ✅ Documentar resultados
- ✅ Capturar evidencias (screenshots principales)

**FASE 5: Empezar Matriz de Trazabilidad**
- ✅ Crear tabla básica: Requisito → Caso → Estado

**📝 ENTREGABLE:** Resultados + Matriz inicial

---

#### 🎨 Dennis (4h)
**FASE 3+4: Pruebas Funcionales**
- ✅ **3 casos** de prueba funcionales:
  1. Validación de formulario de login
  2. Navegación entre pantallas
  3. Feedback de errores
  
- ✅ Ejecutar y documentar
- ✅ Más screenshots/evidencias

**📝 ENTREGABLE:** 3 casos + evidencias

---

#### 💻 Fernando (4h)
**FASE 3+4: Pruebas de Integración**
- ✅ **3 casos** de integración:
  1. AuthProvider → AuthService → Firebase
  2. ReservationProvider → FirestoreService → Firestore
  3. UI → Provider → Service (flujo completo)
  
- ✅ Ejecutar manualmente
- ✅ Documentar con logs/capturas

**📝 ENTREGABLE:** 3 casos + logs

---

### 🌆 TARDE (2:00 PM - 6:00 PM) - 4 HORAS

#### 👨‍💼 Luis (4h - CRÍTICO)
**FASE 5: Consolidar TODO en PDF**
- ✅ Reunir todos los documentos del equipo
- ✅ Estructurar el PDF final:
  1. Portada
  2. Plan de Pruebas (lo de Luis mañana)
  3. Análisis Estático (tabla de Fernando)
  4. Casos de Prueba (todos los Excel)
  5. Evidencias (screenshots, videos)
  6. Registro de Defectos (lo de Fernando)
  7. Matriz de Trazabilidad
  8. Conclusiones (1 página)
  
**📝 ENTREGABLE:** `INFORME_TESTING_FINAL.pdf`

---

#### 🎨 Dennis (4h)
**FASE 5: Registro de Defectos UI**
- ✅ Documentar **5-8 defectos** encontrados en UI:
  - Problemas visuales
  - Inconsistencias de diseño
  - Problemas de usabilidad
  - Errores de validación
  
- ✅ Formato: ID, Descripción, Severidad, Evidencia

**📝 ENTREGABLE:** `DEFECTOS_UI.xlsx`

---

#### 💻 Fernando (4h - CRÍTICO)
**FASE 5: Registro de Defectos Backend**
- ✅ Documentar **10-15 defectos** encontrados:
  - Hallazgos del análisis estático
  - Errores de pruebas unitarias
  - Problemas de integración
  - Code smells críticos
  
- ✅ Clasificar por Severidad (Crítico/Alto/Medio/Bajo)
- ✅ Asignar prioridad
- ✅ Documentar pasos para reproducir

**📝 ENTREGABLE:** `REGISTRO_DEFECTOS.xlsx` (COMPLETO)

---

### 🌙 ÚLTIMA HORA (6:00 PM - 8:00 PM) - 2 HORAS

#### 👥 TODO EL EQUIPO (2h)
**REVISIÓN FINAL Y AJUSTES**
- ✅ Luis: Revisar PDF final
- ✅ Dennis: Asegurar que todas las evidencias estén
- ✅ Fernando: Verificar registro de defectos
- ✅ Agregar conclusiones del equipo
- ✅ Verificar que se cumplan TODOS los requisitos
- ✅ **ENTREGAR**

---

## 📊 RESUMEN DE ENTREGABLES MÍNIMOS

### Documentos (Excel/Word):
1. ✅ Plan de Pruebas EXPRESS (2-3 páginas)
2. ✅ Análisis Estático (tabla de hallazgos)
3. ✅ Casos de Prueba UI (5 casos)
4. ✅ Casos de Prueba Backend (5 casos unitarias + 3 integración)
5. ✅ Casos de Prueba Sistema (3 flujos)
6. ✅ Casos UAT (2 escenarios)
7. ✅ Casos Funcionales (3 casos)
8. ✅ Registro de Defectos (15-20 defectos totales)
9. ✅ Matriz de Trazabilidad (tabla básica)

### Evidencias:
10. ✅ Screenshots (15-20 capturas)
11. ✅ Video demo (1 video de 2-3 min)
12. ✅ Logs de consola (output de tests)
13. ✅ Coverage report (si es posible)

### Informe Final:
14. ✅ **PDF CONSOLIDADO** (20-30 páginas)

---

## 🎯 TOTAL DE CASOS DE PRUEBA

| Tipo | Cantidad | Responsable |
|------|----------|-------------|
| Análisis Estático | 1 tabla | Fernando |
| Unitarias | 5 casos | Fernando |
| Integración | 3 casos | Fernando |
| Componentes UI | 5 casos | Dennis |
| Funcionales | 3 casos | Dennis |
| Sistema | 3 casos | Luis |
| UAT | 2 casos | Luis |
| **TOTAL** | **22 casos** | **Equipo** |

---

## ⚠️ REGLAS DE ORO (2 DÍAS)

### 1. NO PERFECCIONAR
- Lo suficientemente bueno > perfecto
- Documentar rápido, mejorar después (si hay tiempo)

### 2. REUSAR EVIDENCIAS
- 1 screenshot puede servir para 3 casos
- 1 video muestra varios flujos

### 3. FOCUS EN LO CRÍTICO
- Login/Auth (CRÍTICO)
- Reservas (CORE del negocio)
- UI básica (pantallas principales)

### 4. PARALELIZAR TODO
- Cada uno trabaja independiente
- Sincronizar solo 2-3 veces al día

### 5. TEMPLATES SIMPLES
- Copiar/pegar formato de casos
- No reinventar la rueda

---

## 📋 CHECKLIST DE REQUISITOS

### FASE 1: Análisis Estático ✅
- [x] Tabla de hallazgos
- [x] Clasificación por severidad
- [x] Herramienta usada (Dart Analyzer)

### FASE 2: Plan de Pruebas ✅
- [x] Alcance y objetivos
- [x] Módulos a probar
- [x] Tipos de prueba
- [x] Roles del equipo
- [x] Herramientas

### FASE 3: Casos de Prueba ✅
- [x] Unitarias (5)
- [x] Integración (3)
- [x] Componentes (5)
- [x] Funcionales (3)
- [x] Sistema (3)
- [x] UAT (2)

### FASE 4: Evidencias ✅
- [x] Screenshots
- [x] Logs
- [x] Videos
- [x] Resultados documentados

### FASE 5: Reporte Final ✅
- [x] Registro de defectos (15-20)
- [x] Matriz de trazabilidad
- [x] PDF consolidado
- [x] Conclusiones

---

## 💡 TIPS PARA ACELERAR

### Luis:
- Usar plantilla de plan de pruebas (buscar en internet)
- Matriz de trazabilidad en Excel (simple)
- No escribir mucho, ir al grano

### Dennis:
- Usar Snipping Tool (Windows + Shift + S)
- Grabar con OBS o Windows Game Bar (Win + G)
- Nombrar capturas: `01_login.png`, `02_home.png`

### Fernando:
- `flutter analyze > analisis.txt` (automático)
- Tests mínimos pero ejecutables
- Copiar formato de tabla de defectos

---

## ⏰ HORAS TOTALES

| Persona | Día 1 | Día 2 | Total |
|---------|-------|-------|-------|
| Luis | 8-10h | 8-10h | 16-20h |
| Dennis | 8-10h | 8h | 16-18h |
| Fernando | 10h | 8h | 18h |

**TOTAL EQUIPO:** 50-56 horas en 2 días

---

## ✅ FACTIBILIDAD: SÍ, ES POSIBLE

**PERO requiere:**
- ✅ Trabajo intenso y enfocado
- ✅ Cero distracciones
- ✅ Comunicación rápida (WhatsApp/Discord)
- ✅ Sacrificar perfección por cumplimiento
- ✅ TODO el equipo comprometido

---

## 🚨 RIESGOS

1. **Tiempo insuficiente para correcciones** → No corregir, solo documentar
2. **Falta de evidencias** → Reusar capturas
3. **Casos muy complejos** → Simplificar
4. **PDF muy largo** → 20-30 páginas es suficiente

---

## 📞 COMUNICACIÓN

- **Grupo de WhatsApp:** Updates cada 3-4 horas
- **Reuniones cortas:** 15 min al inicio y fin de cada día
- **Compartir archivos:** Google Drive en tiempo real

---

**🎯 OBJETIVO:** Entregar el 28 de noviembre a las 8 PM

**✨ MOTIVACIÓN:** ¡Ustedes pueden! El equipo ya tiene experiencia y el proyecto está bien estructurado.

---

**Creado:** Noviembre 26, 2024  
**Entrega:** Noviembre 28, 2024 (20:00)
