# 🚗 Estaciona UNSA

**Estaciona UNSA** es una aplicación móvil desarrollada con **Flutter** que busca optimizar la gestión de los estacionamientos dentro de la **Universidad Nacional de San Agustín de Arequipa (UNSA)**.  
La app permite a estudiantes, docentes y personal administrativo **visualizar, registrar y reservar espacios de estacionamiento** en tiempo real, ofreciendo una experiencia moderna, segura y eficiente.

---

## 🌐 Descripción General

El proyecto surge como una iniciativa tecnológica para mejorar la **movilidad interna y el control del flujo vehicular** dentro de los campus de la UNSA.  
Con un diseño intuitivo y una arquitectura robusta, **Estaciona UNSA** permite que los usuarios puedan gestionar sus vehículos desde el móvil, garantizando transparencia y comodidad en el proceso de estacionamiento.

La aplicación integra un **sistema visual dinámico**, complementado con **imágenes y recursos gráficos obtenidos de fuentes web (como Unsplash y Pexels)**, que aportan una estética moderna, limpia y representativa de la innovación universitaria.

---

## 🧩 Características Principales

- 📱 **Gestión de estacionamientos en tiempo real:** muestra los espacios disponibles y ocupados.  
- 🚙 **Registro de vehículos** y vinculación con usuarios institucionales.  
- 🔒 **Inicio de sesión seguro:** mediante autenticación con correos institucionales UNSA.  
- 🗺️ **Visualización de zonas de parqueo:** interfaz amigable basada en mapas o cuadrículas.  
- 🔔 **Notificaciones automáticas:** alertas sobre disponibilidad, horarios y reservas.  
- 🧾 **Historial de uso:** registro de entradas, salidas y tiempos de estacionamiento.  
- 💬 **Interfaz adaptable y moderna:** desarrollada con Material Design 3 y soporte multiplataforma.  

---

## 🛠️ Tecnologías Utilizadas

| Categoría | Tecnología |
|------------|------------|
| **Framework principal** | [Flutter](https://flutter.dev/) |
| **Lenguaje** | Dart |
| **Base de datos** | Firebase Firestore |
| **Autenticación** | Firebase Auth (solo correos institucionales) |
| **Notificaciones** | Firebase Cloud Messaging |
| **Diseño UI/UX** | Material Design 3 + Assets Web |
| **Control de versiones** | Git + GitHub |
| **Entorno de desarrollo** | VS Code / Android Studio |

---

## 🧱 Arquitectura del Proyecto

```mermaid
graph TD
    A[Flutter Frontend] --> B[Firebase Auth]
    A --> C[Firestore Database]
    A --> D[Cloud Storage]
    C --> E[Gestión de Reservas y Vehículos]
    D --> F[Imágenes y Recursos Visuales]
    B --> G[Usuarios Institucionales UNSA]
🚀 Instalación y Ejecución
Clona el repositorio:

bash
Copiar código
git clone https://github.com/tuusuario/estaciona-unsa.git
cd estaciona-unsa
Instala las dependencias:

bash
Copiar código
flutter pub get
Configura tu entorno Firebase:

Ejecuta:

bash
Copiar código
flutterfire configure
Selecciona tu proyecto Firebase.

Revisa que el archivo firebase_options.dart se haya generado correctamente.

Ejecuta la app:

bash
Copiar código
flutter run
⚠️ Importante (Windows):
Flutter necesita soporte para symlinks.
Activa el modo desarrollador ejecutando:

bash
Copiar código
start ms-settings:developers
Luego reinicia tu PC o tu terminal.

💡 Objetivos del Proyecto
Mejorar la eficiencia y organización del estacionamiento en los campus universitarios.

Promover la digitalización de procesos administrativos dentro de la UNSA.

Ofrecer una experiencia de usuario moderna y confiable mediante Flutter.

Servir como base para futuras integraciones con IoT o cámaras de detección automática.

🧠 Impacto Esperado
El sistema reduce los tiempos de búsqueda de estacionamiento, evita congestiones internas y mejora la seguridad del campus.
Además, contribuye a la gestión sostenible de espacios y promueve la cultura de movilidad inteligente dentro de la universidad.

🎨 Inspiración Visual
El diseño del proyecto se apoya en una línea estética clara y tecnológica, utilizando imágenes de estacionamientos modernos, automóviles y entornos universitarios, obtenidas de bancos de imágenes web como Unsplash y Pexels.
Estas imágenes permiten contextualizar el proyecto y reforzar su enfoque visual





markdown
Copiar código
# 🚗 Estaciona UNSA

**Estaciona UNSA** es una aplicación móvil desarrollada con **Flutter** que busca optimizar la gestión de los estacionamientos dentro de la **Universidad Nacional de San Agustín de Arequipa (UNSA)**.  
La app permite a estudiantes, docentes y personal administrativo **visualizar, registrar y reservar espacios de estacionamiento** en tiempo real, ofreciendo una experiencia moderna, segura y eficiente.

---

## 🌐 Descripción General

El proyecto surge como una iniciativa tecnológica para mejorar la **movilidad interna y el control del flujo vehicular** dentro de los campus de la UNSA.  
Con un diseño intuitivo y una arquitectura robusta, **Estaciona UNSA** permite que los usuarios puedan gestionar sus vehículos desde el móvil, garantizando transparencia y comodidad en el proceso de estacionamiento.

La aplicación integra un **sistema visual dinámico**, complementado con **imágenes y recursos gráficos obtenidos de fuentes web (como Unsplash y Pexels)**, que aportan una estética moderna, limpia y representativa de la innovación universitaria.

---

## 🧩 Características Principales

- 📱 **Gestión de estacionamientos en tiempo real:** muestra los espacios disponibles y ocupados.  
- 🚙 **Registro de vehículos** y vinculación con usuarios institucionales.  
- 🔒 **Inicio de sesión seguro:** mediante autenticación con correos institucionales UNSA.  
- 🗺️ **Visualización de zonas de parqueo:** interfaz amigable basada en mapas o cuadrículas.  
- 🔔 **Notificaciones automáticas:** alertas sobre disponibilidad, horarios y reservas.  
- 🧾 **Historial de uso:** registro de entradas, salidas y tiempos de estacionamiento.  
- 💬 **Interfaz adaptable y moderna:** desarrollada con Material Design 3 y soporte multiplataforma.  

---

## 🛠️ Tecnologías Utilizadas

| Categoría | Tecnología |
|------------|------------|
| **Framework principal** | [Flutter](https://flutter.dev/) |
| **Lenguaje** | Dart |
| **Base de datos** | Firebase Firestore |
| **Autenticación** | Firebase Auth (solo correos institucionales) |
| **Notificaciones** | Firebase Cloud Messaging |
| **Diseño UI/UX** | Material Design 3 + Assets Web |
| **Control de versiones** | Git + GitHub |
| **Entorno de desarrollo** | VS Code / Android Studio |

---

## 🧱 Arquitectura del Proyecto

```mermaid
graph TD
    A[Flutter Frontend] --> B[Firebase Auth]
    A --> C[Firestore Database]
    A --> D[Cloud Storage]
    C --> E[Gestión de Reservas y Vehículos]
    D --> F[Imágenes y Recursos Visuales]
    B --> G[Usuarios Institucionales UNSA]
🚀 Instalación y Ejecución
Clona el repositorio:

bash
Copiar código
git clone https://github.com/tuusuario/estaciona-unsa.git
cd estaciona-unsa
Instala las dependencias:

bash
Copiar código
flutter pub get
Configura tu entorno Firebase:

Ejecuta:

bash
Copiar código
flutterfire configure
Selecciona tu proyecto Firebase.

Revisa que el archivo firebase_options.dart se haya generado correctamente.

Ejecuta la app:

bash
Copiar código
flutter run
⚠️ Importante (Windows):
Flutter necesita soporte para symlinks.
Activa el modo desarrollador ejecutando:

bash
Copiar código
start ms-settings:developers
Luego reinicia tu PC o tu terminal.

💡 Objetivos del Proyecto
Mejorar la eficiencia y organización del estacionamiento en los campus universitarios.

Promover la digitalización de procesos administrativos dentro de la UNSA.

Ofrecer una experiencia de usuario moderna y confiable mediante Flutter.

Servir como base para futuras integraciones con IoT o cámaras de detección automática.

🧠 Impacto Esperado
El sistema reduce los tiempos de búsqueda de estacionamiento, evita congestiones internas y mejora la seguridad del campus.
Además, contribuye a la gestión sostenible de espacios y promueve la cultura de movilidad inteligente dentro de la universidad.

🎨 Inspiración Visual
El diseño del proyecto se apoya en una línea estética clara y tecnológica, utilizando imágenes de estacionamientos modernos, automóviles y entornos universitarios, obtenidas de bancos de imágenes web como Unsplash y Pexels.
Estas imágenes permiten contextualizar el proyecto y reforzar su enfoque visual.

<p align="center"> <img src="https://images.unsplash.com/photo-1506521781263-d8422e82f27a" width="70%" alt="Parking visualization example"> </p>
👥 Equipo de Desarrollo
Nombre	Rol	Descripción
Luis Guillermo Luque Condori	🧠 Líder de Proyecto / Dev Flutter	Encargado de la arquitectura y despliegue.
[Integrante 2]	🎨 UI/UX Designer	Diseña la experiencia visual del usuario.
[Integrante 3]	🔧 Backend & Firebase	Configuración de base de datos y seguridad.

📚 Licencia
Este proyecto es de carácter académico y educativo, desarrollado en el marco de la Universidad Nacional de San Agustín de Arequipa.
El código fuente puede ser utilizado con fines de aprendizaje y mejora tecnológica.
