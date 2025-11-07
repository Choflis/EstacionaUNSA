# 📚 Documentación - EstacionaUNSA

Índice completo de la documentación técnica del proyecto.

---

## 🚀 Guías Principales

### [SETUP.md](SETUP.md)
**Guía de Configuración Completa**
- Instalación de Flutter y Firebase
- Configuración de Google Sign-In
- Setup de Firestore
- Configuración para el equipo de desarrollo
- Solución de problemas comunes

**Para:** Todos los desarrolladores (configuración inicial)

---

### [DATABASE.md](DATABASE.md)
**Documentación de Base de Datos**
- Diagrama entidad-relación
- Estructura de colecciones
- Modelos de datos detallados
- Flujo de datos del sistema
- Reglas de seguridad
- Índices recomendados

**Para:** Backend developers, diseño de base de datos

---

### [DESARROLLO.md](DESARROLLO.md)
**Guía de Desarrollo**
- Arquitectura del proyecto (Clean Architecture + Provider)
- Convenciones de código
- Implementación de servicios (AuthService, FirestoreService)
- Implementación de providers
- Ejemplos de UI
- Testing

**Para:** Desarrolladores Flutter, implementación de features

---

## 📖 Documentación de Diseño

### [casosDeUso.md](casosDeUso.md)
**Casos de Uso del Sistema**
- Descripción general del sistema
- Actores (Usuario, Vigilante, Admin)
- Casos de uso detallados (CU01-CU11)
- Mapeo con requisitos funcionales
- Diagramas UML

**Para:** Análisis de requisitos, diseño de sistema

---

### [DATABASE_DESIGN.md](DATABASE_DESIGN.md)
**Diseño Detallado de Base de Datos**
- Versión extendida de la documentación de BD
- Diagramas ER detallados
- Especificaciones completas de campos
- Restricciones y validaciones
- Casos de uso de la BD

**Para:** Referencia técnica completa

---

### [DATABASE_SUMMARY.md](DATABASE_SUMMARY.md)
**Resumen Visual de Base de Datos**
- Vista general del sistema
- Resumen de colecciones
- Flujo principal de uso
- Guía rápida de consulta

**Para:** Referencia rápida, nuevos miembros del equipo

---

## 🗺️ Orden de Lectura Recomendado

### Para Nuevos Desarrolladores:

1. **[SETUP.md](SETUP.md)** - Configurar tu entorno
2. **[DATABASE_SUMMARY.md](DATABASE_SUMMARY.md)** - Entender el sistema
3. **[casosDeUso.md](casosDeUso.md)** - Conocer funcionalidades
4. **[DESARROLLO.md](DESARROLLO.md)** - Empezar a codear
5. **[DATABASE.md](DATABASE.md)** - Referencia mientras desarrollas

### Para Backend/Database:

1. **[casosDeUso.md](casosDeUso.md)** - Requisitos del sistema
2. **[DATABASE_DESIGN.md](DATABASE_DESIGN.md)** - Diseño completo
3. **[DATABASE.md](DATABASE.md)** - Implementación
4. **[SETUP.md](SETUP.md)** - Configurar Firestore

### Para Frontend/UI:

1. **[casosDeUso.md](casosDeUso.md)** - Entender funcionalidades
2. **[DESARROLLO.md](DESARROLLO.md)** - Arquitectura y código
3. **[DATABASE_SUMMARY.md](DATABASE_SUMMARY.md)** - Datos que consumirás
4. **[SETUP.md](SETUP.md)** - Configuración

---

## 📊 Resumen de Contenidos

| Archivo | Líneas | Temas Principales |
|---------|--------|-------------------|
| SETUP.md | ~250 | Firebase, Google Sign-In, Instalación |
| DATABASE.md | ~500 | Firestore, Modelos, Reglas |
| DESARROLLO.md | ~700 | Arquitectura, Providers, Servicios |
| casosDeUso.md | ~280 | Requisitos, Casos de uso |
| DATABASE_DESIGN.md | ~1500 | Diseño BD completo |
| DATABASE_SUMMARY.md | ~400 | Resumen visual |

---

## 🔗 Links Útiles

**Proyecto:**
- [README Principal](../README.md)
- [Roadmap](../ROADMAP.md)

**Recursos Externos:**
- [Flutter Docs](https://docs.flutter.dev/)
- [Firebase Docs](https://firebase.google.com/docs)
- [Firestore Docs](https://firebase.google.com/docs/firestore)
- [Provider Package](https://pub.dev/packages/provider)

---

## 🆘 ¿Necesitas Ayuda?

**Si tienes dudas sobre:**
- ⚙️ Configuración → Ver [SETUP.md](SETUP.md)
- 🗄️ Base de datos → Ver [DATABASE.md](DATABASE.md)
- 💻 Código → Ver [DESARROLLO.md](DESARROLLO.md)
- 📋 Funcionalidades → Ver [casosDeUso.md](casosDeUso.md)

**Contacto del equipo:**
- Luis - Líder / Flutter Dev
- Dennis - UI/UX
- Fernando - Backend / Firebase

---

**Última actualización:** Noviembre 2024
