# 📋 PLAN DE DISTRIBUCIÓN DE TESTING - ESTACIONA UNSA

**Proyecto:** Sistema de Gestión de Estacionamiento UNSA  
**Fecha:** Noviembre 26, 2024  
**Equipo:**
- Luis Guillermo Luque Condori (Líder / Flutter)
- Dennis Javier Quispe Saavedra (UI/UX)
- Fernando Miguel Garambel Marín (Backend / Firebase)

---

## 🎯 DISTRIBUCIÓN DE RESPONSABILIDADES

### 👨‍💼 Luis Guillermo - Líder de QA y Testing de Sistema
**Rol Principal:** Líder de Calidad y Coordinador

**Responsabilidades:**

#### FASE 1 - Análisis del Proyecto (30% del trabajo)
- ✅ **Coordinar** análisis estático con SonarQube o Dart Analyzer
- ✅ **Consolidar** tabla de hallazgos estáticos de todo el equipo
- ✅ **Clasificar** hallazgos por severidad (Crítico, Alto, Medio, Bajo)
- ✅ **Liderar** reuniones de revisión de código

#### FASE 2 - Diseño del Plan de Pruebas (50% del trabajo)
- ✅ **Diseñar** Plan de Pruebas completo
- ✅ **Definir** alcance y objetivos
- ✅ **Asignar** roles del equipo de testing
- ✅ **Seleccionar** herramientas de testing

#### FASE 3 - Casos de Prueba (35% del trabajo)
- ✅ **Pruebas de Sistema** - Flujo completo end-to-end
  - Login → Seleccionar zona → Crear reserva → Cancelar
  - Flujo de navegación completo
  - Integración entre todos los módulos
- ✅ **Pruebas de Aceptación (UAT)**
  - Casos de uso reales
  - Criterios de aceptación (Given-When-Then)
  - Escenarios de usuario final

#### FASE 4 - Ejecución (30% del trabajo)
- ✅ **Coordinar** ejecución de todas las pruebas
- ✅ **Recopilar** evidencias de pruebas de sistema
- ✅ **Supervisar** correcciones de defectos

#### FASE 5 - Reporte Final (50% del trabajo)
- ✅ **Consolidar** informe final en PDF
- ✅ **Crear** matriz de trazabilidad
- ✅ **Redactar** conclusiones del equipo
- ✅ **Presentar** resultados

---

### 🎨 Dennis - Testing de UI/UX y Funcionalidad
**Rol Principal:** Tester de Componentes y Diseñador de Casos de Prueba

**Responsabilidades:**

#### FASE 1 - Análisis del Proyecto (30% del trabajo)
- ✅ **Revisar** estándares de diseño UI/UX
- ✅ **Identificar** inconsistencias visuales
- ✅ **Detectar** problemas de accesibilidad
- ✅ **Documentar** hallazgos de usabilidad

#### FASE 2 - Diseño del Plan de Pruebas (25% del trabajo)
- ✅ **Definir** módulos de UI a probar
- ✅ **Documentar** componentes visuales
- ✅ **Listar** pantallas y widgets

#### FASE 3 - Casos de Prueba (35% del trabajo)
- ✅ **Pruebas de Componentes UI**
  - `LoginScreen` - Validaciones de formulario
  - `ParkingListScreen` - Renderizado de listas
  - `ProfileScreen` - Actualización de datos
  - `MainNavScreen` - Navegación entre tabs
  - Widgets: `ParkingCard`, `CustomButton`, `CustomTextField`
  
- ✅ **Pruebas Funcionales**
  - Casos de uso del usuario
  - Flujos de navegación
  - Validaciones de entrada
  - Mensajes de error y feedback
  - Responsividad (diferentes tamaños de pantalla)

#### FASE 4 - Ejecución (35% del trabajo)
- ✅ **Ejecutar** pruebas de componentes
- ✅ **Capturar** screenshots de UI
- ✅ **Grabar** videos de flujos
- ✅ **Documentar** problemas visuales
- ✅ **Probar** en diferentes dispositivos

#### FASE 5 - Reporte Final (20% del trabajo)
- ✅ **Documentar** defectos de UI/UX
- ✅ **Incluir** evidencias visuales
- ✅ **Sugerir** mejoras de diseño

---

### 💻 Fernando - Testing de Backend e Integración
**Rol Principal:** Tester de Integración y Responsable de Defectos

**Responsabilidades:**

#### FASE 1 - Análisis del Proyecto (40% del trabajo)
- ✅ **Ejecutar** análisis estático con Dart Analyzer
- ✅ **Revisar** código de services y providers
- ✅ **Identificar** code smells y duplicación
- ✅ **Analizar** reglas de Firestore

#### FASE 2 - Diseño del Plan de Pruebas (25% del trabajo)
- ✅ **Definir** estrategia de pruebas de integración
- ✅ **Documentar** servicios y APIs a probar
- ✅ **Seleccionar** herramientas (Flutter Test, Mockito)

#### FASE 3 - Casos de Prueba (30% del trabajo)
- ✅ **Pruebas Unitarias** - Lógica de negocio crítica
  - `AuthService` - Login, logout, validaciones
  - `FirestoreService` - CRUD operations
  - `ParkingProvider` - Gestión de estado
  - `ReservationProvider` - Validaciones de reserva
  - `NotificationProvider` - Manejo de notificaciones
  - Modelos: validaciones, toMap/fromMap
  
- ✅ **Pruebas de Integración**
  - Providers ↔ Services
  - Services ↔ Firebase
  - AuthProvider ↔ AuthService ↔ Firebase Auth
  - ReservationProvider ↔ FirestoreService ↔ Firestore
  - Flujo completo: UI → Provider → Service → Firebase

#### FASE 4 - Ejecución (35% del trabajo)
- ✅ **Ejecutar** pruebas unitarias
- ✅ **Ejecutar** pruebas de integración
- ✅ **Generar** reportes de coverage
- ✅ **Documentar** logs de consola
- ✅ **Verificar** reglas de Firestore

#### FASE 5 - Reporte Final (30% del trabajo)
- ✅ **Registrar** todos los defectos encontrados
- ✅ **Clasificar** defectos por severidad y prioridad
- ✅ **Asignar** responsables de corrección
- ✅ **Hacer seguimiento** de estado (Nuevo → Resuelto → Cerrado)
- ✅ **Documentar** pasos para reproducir bugs

---

## 📊 MATRIZ DE RESPONSABILIDADES

| Fase | Luis (Líder) | Dennis (UI/UX) | Fernando (Backend) |
|------|--------------|----------------|---------------------|
| **FASE 1: Análisis** | 30% - Consolidar hallazgos | 30% - Análisis UI/UX | 40% - Análisis estático código |
| **FASE 2: Plan** | 50% - Diseño del plan | 25% - Módulos UI | 25% - Estrategia integración |
| **FASE 3: Casos** | 35% - Sistema + UAT | 35% - Componentes + Funcionales | 30% - Unitarias + Integración |
| **FASE 4: Ejecución** | 30% - Coordinación | 35% - Pruebas UI | 35% - Pruebas backend |
| **FASE 5: Reporte** | 50% - Informe final | 20% - Evidencias UI | 30% - Registro defectos |

---

## 🎯 ENTREGABLES POR PERSONA

### Luis Guillermo
1. Plan de Pruebas completo (documento maestro)
2. Casos de prueba de sistema (end-to-end)
3. Casos de prueba de aceptación (UAT)
4. Matriz de trazabilidad
5. Informe final consolidado (PDF)
6. Presentación de resultados

### Dennis
1. Casos de prueba de componentes UI
2. Casos de prueba funcionales
3. Screenshots de todas las pantallas
4. Videos de flujos de usuario
5. Documentación de problemas de UI/UX
6. Evidencias visuales para el informe

### Fernando
1. Resultados de análisis estático
2. Casos de prueba unitarias (código completo)
3. Casos de prueba de integración
4. Reportes de coverage
5. Registro completo de defectos
6. Logs y evidencias técnicas

---

## 🛠️ HERRAMIENTAS ASIGNADAS

### Luis (Coordinación y Sistema)
- **Postman** (si hay API REST)
- **Manual Testing Tools**
- **Excel/Sheets** (matriz de trazabilidad)
- **Google Docs** (documentación)

### Dennis (UI/UX)
- **Flutter DevTools** (inspector de widgets)
- **Device Preview** (diferentes tamaños)
- **OBS Studio** (grabación de videos)
- **Snipping Tool** (capturas)

### Fernando (Backend)
- **Dart Analyzer** / **Flutter Test**
- **Mockito** (mocking)
- **Coverage** (cobertura de código)
- **Firebase Console** (logs y reglas)
- **Git** (gestión de defectos)

---

## 📅 CRONOGRAMA SUGERIDO

### Semana 1: Análisis y Planificación
- **Días 1-2:** FASE 1 (Análisis estático) - Todos
- **Días 3-5:** FASE 2 (Plan de pruebas) - Luis lidera

### Semana 2: Diseño de Casos
- **Días 6-8:** FASE 3 (Casos de prueba) - Todos en paralelo
- **Día 9:** Revisión cruzada de casos

### Semana 3: Ejecución
- **Días 10-13:** FASE 4 (Ejecución) - Todos en paralelo
- **Día 14:** Corrección de defectos críticos

### Semana 4: Reporte
- **Días 15-16:** FASE 5 (Registro de defectos) - Fernando
- **Días 17-18:** Consolidación de informe - Luis
- **Día 19:** Revisión final - Todos
- **Día 20:** Entrega

---

## 🎓 CRITERIOS DE ÉXITO

### Para Luis
- ✅ Plan de pruebas aprobado por el equipo
- ✅ 100% de casos de sistema ejecutados
- ✅ Informe final entregado a tiempo
- ✅ Matriz de trazabilidad completa

### Para Dennis
- ✅ Todos los componentes UI probados
- ✅ Evidencias visuales de calidad
- ✅ Al menos 3 mejoras de UI implementadas
- ✅ Videos de flujos principales

### Para Fernando
- ✅ Coverage > 70% en código crítico
- ✅ Cero defectos críticos abiertos
- ✅ Todos los servicios probados
- ✅ Registro de defectos completo

---

## 📝 NOTAS IMPORTANTES

### Comunicación
- **Reuniones diarias:** 15 minutos de standup
- **Canal de Slack/Discord:** Para dudas rápidas
- **Repositorio Git:** Branch `testing` para fixes

### Prioridades
1. **Crítico:** Defectos que impiden funcionalidad core
2. **Alto:** Problemas de seguridad o datos
3. **Medio:** Bugs funcionales menores
4. **Bajo:** Mejoras estéticas o sugerencias

### Recursos Compartidos
- **Google Drive:** Documentos colaborativos
- **Trello/Jira:** Tracking de defectos
- **GitHub Issues:** Registro técnico de bugs

---

**✨ Objetivo:** Entregar un informe de testing profesional que demuestre la calidad del proyecto EstacionaUNSA.

---

**Creado:** Noviembre 26, 2024  
**Próxima revisión:** Inicio de Semana 1
