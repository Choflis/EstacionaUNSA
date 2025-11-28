# 📋 DOCUMENTACIÓN DE TESTING - EstacionaUNSA

**Proyecto:** Sistema de Estacionamiento UNSA  
**Equipo:** Luis, Dennis, Fernando  
**Fecha:** 27-28 Noviembre, 2024

---

## 📁 ESTRUCTURA DE DOCUMENTACIÓN

Esta carpeta contiene toda la documentación del proceso de testing organizada por fases según los requisitos oficiales.

```
testing/
├── README.md (este archivo)
├── fase1_analisis_estatico/
│   ├── FASE1_ANALISIS_ESTATICO.md
│   ├── FASE1_RESUMEN.md
│   ├── CORRECCIONES_APLICADAS.md
│   └── evidencias/
│       ├── analisis_estatico.txt
│       ├── analisis_post_correccion.txt
│       ├── ANALISIS_ESTATICO.csv
│       ├── evidencia_01_comando_flutter_analyze.png
│       ├── evidencia_02_resultados_analisis.png
│       ├── evidencia_03_archivo_txt.png
│       └── evidencia_04_tabla_csv.png
├── fase2_plan_pruebas/
│   └── PLAN_PRUEBAS_EXPRESS.md
├── fase3_casos_prueba/
│   ├── CASOS_PRUEBA_BACKEND.xlsx
│   ├── CASOS_PRUEBA_UI.xlsx
│   ├── CASOS_SISTEMA_UAT.xlsx
│   └── CASOS_FUNCIONALES.xlsx
├── fase4_ejecucion/
│   ├── resultados/
│   ├── capturas/
│   ├── videos/
│   └── logs/
└── fase5_defectos_reporte/
    ├── REGISTRO_DEFECTOS.xlsx
    ├── MATRIZ_TRAZABILIDAD.xlsx
    └── INFORME_TESTING_FINAL.pdf
```

---

## 🔄 FASES DEL PROCESO

### ✅ FASE 1: Análisis Estático (COMPLETADA)
**Responsable:** Fernando  
**Carpeta:** `fase1_analisis_estatico/`

**Contenido:**
- Análisis con Dart Analyzer (Flutter)
- Tabla de hallazgos clasificados por severidad
- Correcciones aplicadas (30 errores resueltos)
- Evidencias: archivos TXT, CSV, capturas

**Hallazgos:**
- Inicial: 123 issues
- Final: 93 issues
- Correcciones: 30 (19 críticos, 1 alto, 3 medios, 6 deprecaciones)

---

### 🔄 FASE 2: Plan de Pruebas (EN PROGRESO)
**Responsable:** Luis  
**Carpeta:** `fase2_plan_pruebas/`

**Debe incluir:**
- Alcance y objetivos
- Módulos a probar
- Tipos de pruebas
- Roles del equipo
- Herramientas justificadas

---

### 📝 FASE 3: Casos de Prueba (PENDIENTE)
**Responsables:** Fernando, Dennis, Luis  
**Carpeta:** `fase3_casos_prueba/`

**Casos a diseñar:**
- **Fernando:** 5 unitarias + 3 integración
- **Dennis:** 5 componentes UI + 3 funcionales
- **Luis:** 3 sistema + 2 UAT

**Total:** 22 casos de prueba

---

### ▶️ FASE 4: Ejecución y Evidencias (PENDIENTE)
**Responsables:** Todo el equipo  
**Carpeta:** `fase4_ejecucion/`

**Evidencias requeridas:**
- Capturas de pantalla
- Logs de ejecución
- Videos cortos
- Reportes automáticos
- Re-ejecución de pruebas corregidas

---

### 📊 FASE 5: Defectos y Reporte Final (PENDIENTE)
**Responsables:** Fernando (defectos), Luis (reporte)  
**Carpeta:** `fase5_defectos_reporte/`

**Entregables:**
- Registro de defectos (15-20 defectos)
- Matriz de trazabilidad
- Informe final PDF (20-30 páginas)

---

## 📋 CHECKLIST DE PROGRESO

### FASE 1 ✅
- [x] Ejecutar análisis estático
- [x] Clasificar hallazgos
- [x] Aplicar correcciones
- [x] Documentar evidencias

### FASE 2 🔄
- [ ] Escribir plan de pruebas
- [ ] Definir alcance
- [ ] Asignar roles
- [ ] Justificar herramientas

### FASE 3 📝
- [ ] Casos unitarios (Fernando)
- [ ] Casos integración (Fernando)
- [ ] Casos UI (Dennis)
- [ ] Casos funcionales (Dennis)
- [ ] Casos sistema (Luis)
- [ ] Casos UAT (Luis)

### FASE 4 ▶️
- [ ] Ejecutar pruebas
- [ ] Capturar evidencias
- [ ] Re-ejecutar correcciones
- [ ] Documentar resultados

### FASE 5 📊
- [ ] Registrar defectos
- [ ] Crear matriz trazabilidad
- [ ] Consolidar informe PDF
- [ ] Conclusiones del equipo

---

## 🎯 ENTREGA FINAL

**Fecha límite:** 28 de Noviembre, 2024 - 20:00  
**Formato:** PDF consolidado  
**Páginas:** 20-30 páginas

**El PDF debe incluir:**
1. Plan de pruebas
2. Análisis estático
3. Casos de prueba
4. Evidencias de ejecución
5. Registro de defectos
6. Matriz de trazabilidad
7. Mejoras aplicadas
8. Conclusiones del grupo

---

## 📞 CONTACTO DEL EQUIPO

- **Luis:** Líder QA, Plan de pruebas, Informe final
- **Dennis:** Testing UI, Componentes, Funcionales
- **Fernando:** Testing Backend, Análisis estático, Defectos

---

**Última actualización:** 27 de Noviembre, 2024 - 23:00
