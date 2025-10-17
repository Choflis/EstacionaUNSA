# 🚗 Estaciona UNSA

Estaciona UNSA es una aplicación móvil multiplataforma desarrollada con Flutter para optimizar la gestión de estacionamientos en la Universidad Nacional de San Agustín de Arequipa (UNSA). Permite a estudiantes, docentes y personal administrativo visualizar, registrar y reservar espacios en tiempo real, con autenticación institucional y registro de historial de uso.

---

## Índice
- [Descripción](#descripción)
- [Características principales](#características-principales)
- [Tecnologías](#tecnologías)
- [Arquitectura](#arquitectura)
- [Instalación y ejecución](#instalación-y-ejecución)
- [Configuración de Firebase](#configuración-de-firebase)
- [Uso](#uso)
- [Contribución](#contribución)
- [Equipo](#equipo)
- [Licencia](#licencia)
- [Créditos y recursos visuales](#créditos-y-recursos-visuales)

---

## Descripción

El objetivo de Estaciona UNSA es mejorar la movilidad interna y el control del flujo vehicular dentro de los campus universitarios, proporcionando una interfaz intuitiva y funciones de gestión en tiempo real. La solución está pensada como prototipo académico con posibilidades de extensión (IoT, integración con cámaras, reservas programadas, etc.).

---

## Características principales

- Gestión en tiempo real de ocupación de espacios (disponible / ocupado).
- Registro y asociación de vehículos a usuarios institucionales.
- Autenticación segura con correos institucionales UNSA.
- Visualización de zonas de parqueo mediante mapa o cuadrícula.
- Sistema de reservas y notificaciones (Firebase Cloud Messaging).
- Historial de entradas/salidas y tiempos de uso.
- UI moderna basada en Material Design 3, responsive y multiplataforma.

---

## Tecnologías

| Categoría | Tecnología |
|-----------:|-----------|
| Framework  | Flutter |
| Lenguaje   | Dart |
| BBDD       | Firebase Firestore |
| Auth       | Firebase Authentication |
| Mensajería | Firebase Cloud Messaging |
| Almacenamiento | Firebase Cloud Storage |
| UI/UX      | Material Design 3 |
| Control de versiones | Git / GitHub |

---

## Arquitectura

```mermaid
flowchart TD
  Flutter_Frontend[Flutter Frontend] --> Firebase_Auth[Firebase Auth]
  Flutter_Frontend --> Firestore[Firestore Database]
  Flutter_Frontend --> Cloud_Storage[Cloud Storage]
  Firestore --> Reservas[Gestión de reservas y vehículos]
  Cloud_Storage --> Assets[Imágenes y recursos visuales]
  Firebase_Auth --> Usuarios[Usuarios institucionales UNSA]
```

---

## Instalación y ejecución

### Requisitos previos
- Flutter (última versión estable)
- Android Studio o VS Code con extensiones Flutter/Dart
- Cuenta de Firebase y proyecto creado

### Pasos
1. Clona el repositorio:
   ```bash
   git clone https://github.com/Choflis/EstacionaUNSA.git
   cd EstacionaUNSA
   ```

2. Instala dependencias:
   ```bash
   flutter pub get
   ```

3. Configura Firebase para tu proyecto local:
   - Ejecuta:
     ```bash
     flutterfire configure
     ```
   - Selecciona el proyecto Firebase que corresponda.
   - Verifica que se haya generado `lib/firebase_options.dart` (o el path que use el proyecto).

4. Corre la app:
   ```bash
   flutter run
   ```

Nota (Windows): Flutter requiere soporte para symlinks en algunos entornos. Habilita el modo desarrollador ejecutando:
```bash
start ms-settings:developers
```
Luego reinicia tu PC o terminal si es necesario.

---

## Configuración de Firebase (recomendaciones)

- Authentication:
  - Habilita el proveedor de correo electrónico (`Email/Password`) o el flujo que uses para las cuentas institucionales.
  - Implementa control por dominio (ej. permitir solo correos con dominio `@unsa.edu.pe`). Esto puede hacerse a nivel de la aplicación (validación al registrar/iniciar sesión) y reforzarse en el backend (Cloud Functions / reglas de seguridad).

- Firestore:
  - Diseña reglas de seguridad que restrinjan lecturas/escrituras según la autenticación del usuario y su rol.
  - Ejemplo conceptual (no aplicar sin pruebas):
    ```
    service cloud.firestore {
      match /databases/{database}/documents {
        match /usuarios/{userId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
        match /reservas/{reservaId} {
          allow create: if request.auth != null;
          allow read: if request.auth != null;
          allow update, delete: if request.auth != null && resource.data.propietario == request.auth.uid;
        }
      }
    }
    ```

- Cloud Storage:
  - Restringe el acceso a archivos por usuario y uso previsto.
  - Firma URLs o usa reglas para controlar subida/lectura.

- Notificaciones:
  - Configura Firebase Cloud Messaging y añade la implementación en la app para recibir notificaciones push.

---

## Uso (breve)

- Registro / Inicio de sesión: usa una cuenta institucional UNSA.
- Registrar vehículo: desde el perfil puedes añadir matrícula, modelo y foto (opcional).
- Reservar espacio: selecciona zona y franja horaria en la interfaz de mapas o cuadrículas.
- Historial: revisa entradas/salidas y tiempos en la sección de historial.

---

## Contribución

Si quieres contribuir:
1. Haz fork del repositorio.
2. Crea una rama con la funcionalidad: `git checkout -b feat/nombre-funcion`
3. Realiza tus cambios y pruebas locales.
4. Abre un Pull Request describiendo el cambio y los pasos para testearlo.

Por favor, abre issues describiendo bugs o propuestas de mejora antes de PR grandes. Añade pruebas y documentación cuando sea posible.

---

## Equipo

- Luis Guillermo Luque Condori — Líder de proyecto / Desarrollador Flutter  
- Dennis Javier Quispe Saavedra — Diseño UI/UX  
- Fernando Miguel Garambel Marín — Backend & Firebase

(Actualiza los nombres y roles según corresponda.)

---

## Licencia

Proyecto con fines académicos y educativos, desarrollado en la Universidad Nacional de San Agustín de Arequipa. El código puede usarse para aprendizaje y mejora tecnológica; para otros usos, solicita permiso a los autores.

---

## Créditos y recursos visuales

- Recursos de imágenes: Unsplash, Pexels y otros bancos libres (respecta las licencias y atribuciones cuando apliquen).
- Iconografía y diseño: Material Design 3.

<p align="center">
  <img src="https://images.unsplash.com/photo-1506521781263-d8422e82f27a" alt="Ejemplo visual de parking" width="70%">
</p>

---

Si quieres, puedo:
- Preparar un archivo CONTRIBUTING.md y un ISSUE_TEMPLATE.md para estandarizar contribuciones.
- Ajustar el README para incluir badges (build, license) si conectas CI o licencias concretas.
- Hacer cambios directamente en el repositorio (crear PR) si me indicas que lo haga y confirmas la rama destino.
