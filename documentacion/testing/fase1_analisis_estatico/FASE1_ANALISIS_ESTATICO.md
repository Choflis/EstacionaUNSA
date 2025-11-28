# FASE 1 - Análisis Estático del Proyecto EstacionaUNSA

**Responsable:** Fernando  
**Fecha:** 27 de Noviembre, 2024  
**Herramienta:** Dart Analyzer (Flutter)

---

## 📋 Objetivo

Realizar análisis estático del código para identificar:
- Variables sin usar
- Código duplicado
- Malas prácticas
- Code smells
- Violaciones de estándares de codificación

---

## 🔧 Herramienta Utilizada

**Dart Analyzer** - Herramienta oficial de análisis estático para proyectos Flutter/Dart

**Justificación:**
- Integrada nativamente con Flutter
- Detecta errores de sintaxis, tipos y lógica
- Identifica código no utilizado
- Valida cumplimiento de estándares Dart
- Genera reportes detallados con severidad

---

## 📊 Comando Ejecutado

```bash
flutter analyze > analisis_estatico.txt
```

---

## 📸 EVIDENCIAS REQUERIDAS

> **⚠️ IMPORTANTE - Fernando, debes tomar estas capturas:**

### ✅ Captura 1: Ejecución del comando
**Archivo:** `evidencia_01_comando_flutter_analyze.png`  
**Qué capturar:** Terminal mostrando el comando `/home/fernando/flutter/bin/flutter analyze`

### ✅ Captura 2: Resultados del análisis
**Archivo:** `evidencia_02_resultados_analisis.png`  
**Qué capturar:** Output completo mostrando "123 issues found"

### ✅ Captura 3: Archivo de salida
**Archivo:** `evidencia_03_archivo_txt.png`  
**Qué capturar:** Archivo `analisis_estatico.txt` abierto en editor
d
### ✅ Captura 4: Tabla CSV
**Archivo:** `evidencia_04_tabla_csv.png`  
**Qué capturar:** Archivo `ANALISIS_ESTATICO.csv` abierto (mostrando clasificación)

---

## 📊 Resumen Estadístico

- **Total de hallazgos:** 123
- **Críticos (error):** 19
- **Altos (warning):** 1
- **Medios (info - deprecaciones):** 6
- **Bajos (info - prints y otros):** 97

### Distribución por Archivo

| Archivo | Críticos | Altos | Medios | Bajos | Total |
|---------|----------|-------|--------|-------|-------|
| messaging_service.dart | 19 | 0 | 0 | 22 | 41 |
| firestore_service.dart | 0 | 0 | 0 | 26 | 26 |
| firestore_seed.dart | 0 | 0 | 0 | 15 | 15 |
| login_screen.dart | 0 | 0 | 6 | 0 | 6 |
| reservation_provider.dart | 0 | 0 | 0 | 7 | 7 |
| parking_provider.dart | 0 | 0 | 0 | 5 | 5 |
| auth_service.dart | 0 | 0 | 0 | 6 | 6 |
| notification_provider.dart | 0 | 0 | 3 | 0 | 3 |
| home_screen.dart | 0 | 1 | 0 | 0 | 1 |
| auth_provider.dart | 0 | 0 | 0 | 1 | 1 |
| Otros | 0 | 0 | 0 | 12 | 12 |

---

## 🔍 Hallazgos Clasificados

Ver archivo completo: [`ANALISIS_ESTATICO.csv`](./evidencias/ANALISIS_ESTATICO.csv)

### Top 15 Problemas Críticos

| ID | Archivo | Línea | Descripción | Severidad |
|----|---------|-------|-------------|-----------|
| E001 | messaging_service.dart | 2 | URI no existe: flutter_local_notifications | Crítico |
| E002 | messaging_service.dart | 15 | Clase no definida: FlutterLocalNotificationsPlugin | Crítico |
| E003 | messaging_service.dart | 16 | Método no definido: FlutterLocalNotificationsPlugin | Crítico |
| E004 | messaging_service.dart | 79 | Const con valor no constante (AndroidInitializationSettings) | Crítico |
| E005 | messaging_service.dart | 80 | Const con valor no constante (DarwinInitializationSettings) | Crítico |
| E006 | messaging_service.dart | 86 | Const con valor no constante (InitializationSettings) | Crítico |
| E007 | messaging_service.dart | 88 | Método no definido: AndroidInitializationSettings | Crítico |
| E008 | messaging_service.dart | 90 | Método no definido: DarwinInitializationSettings | Crítico |
| E009 | messaging_service.dart | 92 | Método no definido: InitializationSettings | Crítico |
| E010 | messaging_service.dart | 94 | Método no definido: AndroidNotificationChannel | Crítico |
| E011 | messaging_service.dart | 95 | Identificador no definido: Importance | Crítico |
| E012 | messaging_service.dart | 96 | Tipo incorrecto: AndroidFlutterLocalNotificationsPlugin | Crítico |
| E013 | messaging_service.dart | 100 | Método no definido: NotificationDetails | Crítico |
| E014 | messaging_service.dart | 101 | Método no definido: AndroidNotificationDetails | Crítico |
| E015 | messaging_service.dart | 102 | Identificador no definido: Importance | Crítico |

---

## 📝 Revisión Manual de Código

### Code Smells Identificados

#### 1. **Dependencia faltante crítica**
- **Archivo:** `lib/services/firebase/messaging_service.dart`
- **Descripción:** El paquete `flutter_local_notifications` no está declarado en `pubspec.yaml` pero se intenta importar
- **Impacto:** 19 errores en cascada, funcionalidad de notificaciones completamente rota
- **Solución:** Agregar dependencia en pubspec.yaml

#### 2. **Uso excesivo de print() en producción**
- **Archivos afectados:** 10 archivos (providers, services, utils)
- **Descripción:** 97 instancias de `print()` en código de producción
- **Impacto:** Logs no controlados, posible filtración de información sensible
- **Solución:** Reemplazar con logger apropiado (ej: `logger` package)

#### 3. **Uso de API deprecada (withOpacity)**
- **Archivo:** `lib/screens/login_screen.dart`
- **Descripción:** 6 usos de `.withOpacity()` que está deprecado
- **Impacto:** Código obsoleto, posibles problemas en futuras versiones de Flutter
- **Solución:** Migrar a `.withValues()`

#### 4. **Import sin usar**
- **Archivo:** `lib/screens/home_screen.dart`
- **Descripción:** Import de `firebase_auth` no utilizado
- **Impacto:** Código muerto, aumenta tamaño del bundle
- **Solución:** Eliminar import

#### 5. **Campos que podrían ser final**
- **Archivo:** `lib/providers/notification_provider.dart`
- **Descripción:** 3 campos privados que nunca se reasignan
- **Impacto:** Menor optimización del compilador
- **Solución:** Marcar como `final`

---

## 🎯 Top 15 Problemas Principales (Priorizados)

1. **[CRÍTICO]** Dependencia faltante: flutter_local_notifications (causa 19 errores)
2. **[CRÍTICO]** MessagingService completamente roto por dependencia faltante
3. **[ALTO]** Import sin usar en home_screen.dart
4. **[MEDIO]** 6 usos de API deprecada withOpacity en login_screen
5. **[BAJO]** 97 prints en código de producción
6. **[BAJO]** 26 prints en firestore_service.dart
7. **[BAJO]** 22 prints en messaging_service.dart
8. **[BAJO]** 15 prints en firestore_seed.dart
9. **[BAJO]** 7 prints en reservation_provider.dart
10. **[BAJO]** 6 prints en auth_service.dart
11. **[BAJO]** 5 prints en parking_provider.dart
12. **[BAJO]** 3 campos que podrían ser final en notification_provider
13. **[BAJO]** 1 print en auth_provider.dart
14. **[INFO]** 12 packages con versiones más nuevas disponibles
15. **[INFO]** Tiempo de análisis: 7.0 segundos 

---

## ✅ Próximos Pasos

- [ ] Exportar tabla a Excel (`ANALISIS_ESTATICO.xlsx`)
- [ ] Adjuntar capturas de pantalla
- [ ] Priorizar defectos para corrección
- [ ] Documentar en registro de defectos (FASE 5)

---

**Nota:** Este documento será la base para el Registro de Defectos en FASE 5.
