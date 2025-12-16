# 📖 Manual de Usuario - EstacionaUNSA

**Sistema de Gestión de Estacionamientos Universitarios**

---

**Universidad Nacional de San Agustín de Arequipa**  
**Escuela Profesional de Ingeniería de Sistemas**  
**Curso:** Construcción de Software  

**Equipo de Desarrollo:**
- Luis Guillermo Luque Condori
- Dennis Javier Quispe Saavedra
- Fernando Miguel Garambel Marín

**Versión:** 1.0  
**Fecha:** Diciembre 2025

---

## 📑 Índice

1. [Introducción](#1-introducción)
   - 1.1 [¿Qué es EstacionaUNSA?](#11-qué-es-estacionaunsa)
   - 1.2 [Características Principales](#12-características-principales)
   - 1.3 [Requisitos del Sistema](#13-requisitos-del-sistema)
   - 1.4 [Instalación de la Aplicación](#14-instalación-de-la-aplicación)

2. [Primeros Pasos](#2-primeros-pasos)
   - 2.1 [Registro de Cuenta](#21-registro-de-cuenta)
   - 2.2 [Inicio de Sesión](#22-inicio-de-sesión)
   - 2.3 [Recuperación de Contraseña](#23-recuperación-de-contraseña)

3. [Gestión de Perfil](#3-gestión-de-perfil)
   - 3.1 [Ver y Editar Perfil](#31-ver-y-editar-perfil)
   - 3.2 [Agregar Vehículos](#32-agregar-vehículos)
   - 3.3 [Editar y Eliminar Vehículos](#33-editar-y-eliminar-vehículos)

4. [Sistema de Estacionamiento](#4-sistema-de-estacionamiento)
   - 4.1 [Visualizar Zonas Disponibles](#41-visualizar-zonas-disponibles)
   - 4.2 [Mapa de Estacionamiento](#42-mapa-de-estacionamiento)
   - 4.3 [Estados de los Espacios](#43-estados-de-los-espacios)

5. [Realizar Reservas](#5-realizar-reservas)
   - 5.1 [Cómo Hacer una Reserva](#51-cómo-hacer-una-reserva)
   - 5.2 [Restricciones de Reserva](#52-restricciones-de-reserva)
   - 5.3 [Cancelar una Reserva](#53-cancelar-una-reserva)
   - 5.4 [Qué Hacer al Llegar](#54-qué-hacer-al-llegar)

6. [Historial y Notificaciones](#6-historial-y-notificaciones)
   - 6.1 [Ver Historial de Uso](#61-ver-historial-de-uso)
   - 6.2 [Gestionar Notificaciones](#62-gestionar-notificaciones)
   - 6.3 [Sistema de Penalizaciones](#63-sistema-de-penalizaciones)

7. [Preguntas Frecuentes (FAQ)](#7-preguntas-frecuentes-faq)

8. [Solución de Problemas](#8-solución-de-problemas)

9. [Contacto y Soporte](#9-contacto-y-soporte)

---

## 1. Introducción

### 1.1 ¿Qué es EstacionaUNSA?

EstacionaUNSA es una aplicación móvil diseñada para optimizar la gestión de estacionamientos en la Universidad Nacional de San Agustín de Arequipa (UNSA). La aplicación permite a estudiantes, docentes y personal administrativo visualizar la disponibilidad de espacios de estacionamiento en tiempo real, realizar reservas y consultar su historial de uso.

**Beneficios principales:**
- ✅ Ahorro de tiempo al buscar estacionamiento
- ✅ Visualización en tiempo real de espacios disponibles
- ✅ Sistema de reservas para garantizar tu espacio
- ✅ Notificaciones automáticas
- ✅ Control de acceso institucional

![Pantalla principal de EstacionaUNSA](documentacion/imagenes/manual_usuario/01_pantalla_principal.png)

---

### 1.2 Características Principales

EstacionaUNSA ofrece las siguientes funcionalidades:

| Característica | Descripción |
|----------------|-------------|
| **Autenticación Segura** | Acceso exclusivo con correos institucionales @unsa.edu.pe |
| **Gestión de Vehículos** | Registra y administra múltiples vehículos (autos y motocicletas) |
| **Visualización en Tiempo Real** | Consulta la disponibilidad de espacios al instante |
| **Sistema de Reservas** | Reserva un espacio por hasta 15 minutos |
| **Mapa Interactivo** | Visualiza las zonas de estacionamiento en un mapa |
| **Historial Completo** | Revisa todas tus entradas y salidas |
| **Notificaciones Push** | Recibe alertas sobre tus reservas y espacios disponibles |
| **Sistema de Penalizaciones** | Control automático de no-shows para uso justo |

---

### 1.3 Requisitos del Sistema

#### Requisitos Mínimos

**Para Android:**
- Sistema operativo: Android 6.0 (Marshmallow) o superior
- Espacio de almacenamiento: 50 MB libres
- Conexión a Internet: WiFi o datos móviles
- GPS activado (para funciones de ubicación)

**Para iOS:**
- Sistema operativo: iOS 11.0 o superior
- Espacio de almacenamiento: 50 MB libres
- Conexión a Internet: WiFi o datos móviles
- Servicios de ubicación activados

#### Requisitos de Cuenta

- Correo electrónico institucional válido (@unsa.edu.pe)
- Ser miembro activo de la comunidad UNSA (estudiante, docente o personal administrativo)
- Tener al menos un vehículo registrado para usar el sistema de reservas

---

### 1.4 Instalación de la Aplicación

#### Instalación en Android

1. **Descarga el archivo APK:**
   - Accede al enlace proporcionado por la universidad
   - Descarga el archivo `estaciona-unsa.apk`

2. **Habilita instalación de fuentes desconocidas:**
   - Ve a **Configuración** > **Seguridad**
   - Activa **Fuentes desconocidas** o **Instalar aplicaciones desconocidas**

3. **Instala la aplicación:**
   - Abre el archivo APK descargado
   - Toca **Instalar**
   - Espera a que finalice la instalación
   - Toca **Abrir** para iniciar la aplicación

4. **Concede permisos necesarios:**
   - Ubicación (para detectar proximidad a las zonas)
   - Notificaciones (para recibir alertas)
   - Almacenamiento (para guardar fotos de vehículos)

![Instalación en Android](documentacion/imagenes/manual_usuario/02_instalacion_android.png)

#### Instalación en iOS

La aplicación estará disponible próximamente en la App Store. Por ahora, la versión está disponible solo para Android.

---

## 2. Primeros Pasos

### 2.1 Registro de Cuenta

Para usar EstacionaUNSA, primero debes crear una cuenta con tu correo institucional.

**Pasos para Ingresar:**

1. **Abre la aplicación** EstacionaUNSA en tu dispositivo

2. **En la pantalla de inicio**, toca el botón **"Iniciar cuenta con Google"**

3. **¡Listo!** Tu cuenta ha sido creada exitosamente

> **⚠️ Importante:** Solo se permiten correos con dominio @unsa.edu.pe. Si intentas iniciar sesión con otro correo, el sistema mostrará un error.

![Registro de cuenta](documentacion/imagenes/manual_usuario/03_registro_cuenta.png)

---

### 2.2 Inicio de Sesión

Una vez que hayas creado tu cuenta, puedes iniciar sesión en cualquier momento.

**Pasos para iniciar sesión:**

1. **Abre la aplicación** EstacionaUNSA

2. **En la pantalla de inicio**, ingresa:
   - **Correo electrónico:** Tu correo institucional
   - **Contraseña:** La contraseña que creaste

3. **Toca el botón "Iniciar Sesión"**

4. **La aplicación te llevará a la pantalla principal** donde podrás ver las zonas de estacionamiento disponibles

**Opciones adicionales:**
- ✅ **Recordar sesión:** Marca esta opción para no tener que iniciar sesión cada vez
- 🔐 **Modo seguro:** Si usas un dispositivo compartido, no marques "Recordar sesión"

![Inicio de sesión](documentacion/imagenes/manual_usuario/04_inicio_sesion.png)

---

### 2.3 Recuperación de Contraseña

Si olvidaste tu contraseña, puedes recuperarla fácilmente.

**Pasos para recuperar tu contraseña:**

1. **En la pantalla de inicio de sesión**, toca **"¿Olvidaste tu contraseña?"**

2. **Ingresa tu correo electrónico** institucional

3. **Toca "Enviar enlace de recuperación"**

4. **Revisa tu correo electrónico:**
   - Abre el correo de recuperación
   - Haz clic en el enlace proporcionado

5. **Crea una nueva contraseña:**
   - Ingresa tu nueva contraseña
   - Confírmala
   - Guarda los cambios

6. **Inicia sesión** con tu nueva contraseña

> **💡 Consejo:** Usa una contraseña segura que incluya letras mayúsculas, minúsculas, números y símbolos.

---

## 3. Gestión de Perfil

### 3.1 Ver y Editar Perfil

Tu perfil contiene tu información personal y estadísticas de uso del sistema.

**Acceder a tu perfil:**

1. **Desde la pantalla principal**, toca el ícono de **perfil** (👤) en la barra de navegación inferior

2. **Visualiza tu información:**
   - Foto de perfil
   - Nombre completo
   - Correo electrónico
   - Estadísticas de uso (reservas totales, completadas, etc.)
   - Lista de vehículos registrados

**Editar tu perfil:**

1. **En la pantalla de perfil**, toca el botón **"Editar perfil"** o el ícono de lápiz (✏️)

2. **Modifica la información que desees:**
   - Cambiar foto de perfil (toca la foto actual)
   - Actualizar nombre
   - Cambiar contraseña

3. **Toca "Guardar cambios"** para aplicar las modificaciones

![Perfil de usuario](documentacion/imagenes/manual_usuario/05_perfil_usuario.png)

---

### 3.2 Agregar Vehículos

Para poder hacer reservas, necesitas tener al menos un vehículo registrado en tu cuenta.

**Pasos para agregar un vehículo:**

1. **Ve a tu perfil** tocando el ícono de perfil (👤)

2. **En la sección "Mis Vehículos"**, toca el botón **"Agregar vehículo"** o el ícono de más (+)

3. **Completa la información del vehículo:**
   - **Placa:** Número de matrícula del vehículo (obligatorio)
   - **Tipo:** Selecciona Auto o Motocicleta
   - **Modelo:** Marca y modelo del vehículo (opcional)
   - **Color:** Color del vehículo (opcional)
   - **Foto:** Toma o selecciona una foto del vehículo (opcional pero recomendado)

4. **Toca "Guardar vehículo"**

5. **El vehículo aparecerá en tu lista** de vehículos registrados

> **⚠️ Importante:** La placa debe ser válida y estar asociada a un vehículo real. El personal de vigilancia verificará esta información al momento de tu ingreso.

![Agregar vehículo](documentacion/imagenes/manual_usuario/06_agregar_vehiculo.png)

---

### 3.3 Editar y Eliminar Vehículos

Puedes modificar o eliminar vehículos registrados en cualquier momento.

**Editar un vehículo:**

1. **En la sección "Mis Vehículos"** de tu perfil, toca el vehículo que deseas editar

2. **Modifica la información** que necesites cambiar

3. **Toca "Guardar cambios"**

**Eliminar un vehículo:**

1. **En la lista de vehículos**, desliza el vehículo hacia la izquierda o toca el ícono de opciones (⋮)

2. **Selecciona "Eliminar"**

3. **Confirma la eliminación** en el diálogo que aparece

> **⚠️ Nota:** No puedes eliminar un vehículo si tiene una reserva activa. Primero debes cancelar la reserva.

---

## 4. Sistema de Estacionamiento

### 4.1 Visualizar Zonas Disponibles

EstacionaUNSA gestiona tres zonas principales de estacionamiento en el campus de la UNSA.

**Las tres zonas son:**

| Zona | Nombre | Ubicación | Capacidad |
|------|--------|-----------|-----------|
| **Zona A** | Entrada Principal | Puerta principal de la UNSA | 50 espacios |
| **Zona B** | Biblioteca Central | Junto a la biblioteca | 30 espacios |
| **Zona C** | Ingenierías | Facultad de Ingeniería | 40 espacios |

**Ver zonas disponibles:**

1. **En la pantalla principal**, verás tarjetas con información de cada zona:
   - Nombre de la zona
   - Espacios disponibles / Total de espacios
   - Distancia desde tu ubicación actual
   - Estado (Abierta / Cerrada)

2. **Los colores indican disponibilidad:**
   - 🟢 **Verde:** Muchos espacios disponibles (>30%)
   - 🟡 **Amarillo:** Disponibilidad media (10-30%)
   - 🔴 **Rojo:** Pocos espacios disponibles (<10%)
   - ⚫ **Gris:** Zona cerrada o sin espacios

3. **Toca una zona** para ver más detalles y espacios específicos

![Zonas disponibles](documentacion/imagenes/manual_usuario/07_zonas_disponibles.png)

---

### 4.2 Mapa de Estacionamiento

El mapa interactivo te permite visualizar la ubicación exacta de cada zona y tu distancia a ellas.

**Usar el mapa:**

1. **Desde la pantalla principal**, toca el ícono de **mapa** (🗺️) en la barra de navegación

2. **El mapa mostrará:**
   - Tu ubicación actual (punto azul)
   - Las tres zonas de estacionamiento (marcadores)
   - Círculo de 500m de radio (área de reserva permitida)

3. **Interactúa con el mapa:**
   - **Zoom:** Pellizca para acercar o alejar
   - **Desplazar:** Arrastra para mover el mapa
   - **Toca un marcador:** Ver información de la zona

4. **Toca "Ver detalles"** en la información de la zona para acceder a los espacios disponibles

> **💡 Consejo:** El mapa se actualiza automáticamente con tu ubicación. Asegúrate de tener el GPS activado.

![Mapa de estacionamiento](documentacion/imagenes/manual_usuario/08_mapa_estacionamiento.png)

---

### 4.3 Estados de los Espacios

Cada espacio de estacionamiento puede tener uno de los siguientes estados:

| Estado | Color | Descripción | Acción Disponible |
|--------|-------|-------------|-------------------|
| **Disponible** | 🟢 Verde | El espacio está libre y puede ser reservado | Reservar |
| **Reservado** | 🟡 Amarillo | Alguien ha reservado este espacio | No disponible |
| **Ocupado** | 🔴 Rojo | Hay un vehículo estacionado actualmente | No disponible |
| **Inactivo** | ⚫ Gris | El espacio está fuera de servicio | No disponible |

**Ver espacios de una zona:**

1. **Toca una zona** desde la pantalla principal o el mapa

2. **Verás una cuadrícula o lista** con todos los espacios de esa zona

3. **Cada espacio muestra:**
   - Número del espacio (ej: A-001, B-015)
   - Estado actual (color)
   - Tipo (Auto / Motocicleta)
   - Características especiales (techado, para discapacitados, etc.)

4. **Toca un espacio disponible** para ver la opción de reservar

![Estados de los espacios](documentacion/imagenes/manual_usuario/09_estados_espacios.png)

---

## 5. Realizar Reservas

### 5.1 Cómo Hacer una Reserva

El sistema de reservas te permite asegurar un espacio antes de llegar a la universidad.

**Pasos para hacer una reserva:**

1. **Asegúrate de estar dentro del rango permitido:**
   - Debes estar a 500 metros o menos de la zona que deseas reservar
   - La aplicación mostrará tu distancia actual

2. **Selecciona una zona** desde la pantalla principal

3. **Elige un espacio disponible** (marcado en verde)

4. **Toca el botón "Reservar"**

5. **Confirma tu reserva:**
   - Verifica el espacio seleccionado
   - Selecciona el vehículo que usarás
   - Lee las condiciones de la reserva
   - Toca "Confirmar reserva"

6. **¡Reserva confirmada!**
   - Recibirás una notificación de confirmación
   - El espacio se marcará como reservado
   - Tienes **15 minutos** para llegar

7. **Dirígete al espacio reservado:**
   - El vigilante verificará tu reserva
   - Muestra la aplicación con tu reserva activa
   - Estaciona en el espacio asignado

> **⏱️ Importante:** Tienes exactamente 15 minutos desde que haces la reserva para llegar. Si no llegas a tiempo, la reserva expirará y se contará como "no-show".

![Proceso de reserva](documentacion/imagenes/manual_usuario/10_hacer_reserva.png)

---

### 5.2 Restricciones de Reserva

Para garantizar un uso justo del sistema, existen las siguientes restricciones:

#### Restricción de Distancia
- ✅ **Permitido:** Estar a 500 metros o menos de la zona
- ❌ **No permitido:** Reservar desde casa o lugares lejanos

**¿Por qué?** Para evitar reservas anticipadas que bloqueen espacios innecesariamente.

#### Restricción de Tiempo
- ⏱️ **Duración máxima:** 15 minutos
- ⏱️ **No renovable:** No puedes extender una reserva activa

**¿Por qué?** Para mantener la rotación de espacios y dar oportunidad a todos.

#### Restricción de Cantidad
- 1️⃣ **Máximo:** 1 reserva activa por usuario
- ❌ **No permitido:** Reservar múltiples espacios simultáneamente

**¿Por qué?** Para evitar acaparamiento de espacios.

#### Restricción de Horario
- 🕐 **Horario de operación:** Lunes a Viernes, 6:00 AM - 10:00 PM
- 🕐 **Sábados:** 6:00 AM - 2:00 PM
- ❌ **Domingos y feriados:** Cerrado

#### Restricción por Penalizaciones
- ⚠️ **3 no-shows:** Advertencia
- 🚫 **5 no-shows:** Suspensión de 7 días
- 🔒 **10 no-shows:** Suspensión permanente

> **💡 Consejo:** Sé responsable con tus reservas. Solo reserva cuando estés seguro de que llegarás a tiempo.

---

### 5.3 Cancelar una Reserva

Si por alguna razón no puedes llegar, es importante que canceles tu reserva para liberar el espacio.

**Pasos para cancelar una reserva:**

1. **Ve a la sección "Mis Reservas"** tocando el ícono de reservas (📋) en la barra de navegación

2. **Verás tu reserva activa** con:
   - Espacio reservado
   - Tiempo restante
   - Zona y ubicación

3. **Toca el botón "Cancelar reserva"**

4. **Confirma la cancelación** en el diálogo que aparece

5. **La reserva se cancelará inmediatamente:**
   - El espacio quedará disponible para otros
   - No se contará como no-show
   - Recibirás una notificación de confirmación

> **✅ Buena práctica:** Si sabes que no llegarás, cancela tu reserva lo antes posible. Esto ayuda a otros usuarios y evita penalizaciones en tu cuenta.

![Cancelar reserva](documentacion/imagenes/manual_usuario/11_cancelar_reserva.png)

---

### 5.4 Qué Hacer al Llegar

Una vez que llegues a la universidad con una reserva activa:

**Proceso de entrada:**

1. **Dirígete a la zona reservada** (Zona A, B o C)

2. **Muestra tu reserva al vigilante:**
   - Abre la aplicación
   - Ve a "Mis Reservas"
   - Muestra la pantalla con tu reserva activa

3. **El vigilante verificará:**
   - Tu identidad (CUI o carnet universitario)
   - La placa de tu vehículo coincide con la registrada
   - La reserva está activa y no ha expirado

4. **Estaciona en el espacio asignado:**
   - Busca el número de espacio (ej: A-015)
   - Estaciona correctamente dentro de las líneas

5. **El vigilante registrará tu entrada:**
   - Tu reserva cambiará a estado "Completada"
   - El espacio se marcará como "Ocupado"
   - Se iniciará el registro de tu tiempo de estacionamiento

**Proceso de salida:**

1. **Cuando vayas a salir**, dirígete a la caseta de vigilancia

2. **El vigilante registrará tu salida:**
   - Verificará tu placa
   - Registrará la hora de salida
   - Liberará el espacio

3. **El espacio quedará disponible** para otros usuarios

> **⚠️ Importante:** Siempre estaciona en el espacio exacto que reservaste. Estacionar en otro espacio puede resultar en una incidencia.

---

## 6. Historial y Notificaciones

### 6.1 Ver Historial de Uso

El historial te permite revisar todas tus reservas y usos del estacionamiento.

**Acceder al historial:**

1. **Toca el ícono de historial** (📜) en la barra de navegación

2. **Verás una lista de todas tus reservas:**
   - Reservas completadas
   - Reservas canceladas
   - Reservas expiradas (no-shows)

3. **Cada entrada muestra:**
   - Fecha y hora
   - Zona y espacio utilizado
   - Duración del estacionamiento
   - Estado final (Completada, Cancelada, Expirada)

4. **Toca una entrada** para ver detalles completos:
   - Hora de reserva
   - Hora de entrada (si aplica)
   - Hora de salida (si aplica)
   - Tiempo total estacionado
   - Vehículo utilizado

**Filtrar el historial:**

- **Por fecha:** Selecciona un rango de fechas
- **Por estado:** Filtra por completadas, canceladas o expiradas
- **Por zona:** Muestra solo una zona específica

![Historial de reservas](documentacion/imagenes/manual_usuario/12_historial.png)

---

### 6.2 Gestionar Notificaciones

EstacionaUNSA envía notificaciones para mantenerte informado sobre tus reservas.

**Tipos de notificaciones:**

| Tipo | Cuándo se envía | Ejemplo |
|------|-----------------|---------|
| **Confirmación de reserva** | Al hacer una reserva | "Reserva confirmada en Zona A, espacio A-015" |
| **Recordatorio** | 5 minutos antes de expirar | "Tu reserva expira en 5 minutos" |
| **Expiración** | Cuando la reserva expira | "Tu reserva ha expirado" |
| **Espacio disponible** | Cuando se libera un espacio en tu zona favorita | "Espacio disponible en Zona B" |
| **Incidencia** | Cuando se reporta una incidencia | "Se ha reportado una incidencia en tu cuenta" |
| **Sistema** | Mensajes importantes del sistema | "Mantenimiento programado el sábado" |

**Configurar notificaciones:**

1. **Ve a tu perfil** y toca **"Configuración"** o el ícono de engranaje (⚙️)

2. **En la sección "Notificaciones"**, activa o desactiva:
   - Notificaciones push
   - Notificaciones de recordatorio
   - Notificaciones de espacios disponibles
   - Notificaciones de sistema

3. **Guarda los cambios**

> **💡 Recomendación:** Mantén activadas al menos las notificaciones de recordatorio para evitar no-shows.

---

### 6.3 Sistema de Penalizaciones

Para garantizar el uso responsable del sistema, existe un sistema de penalizaciones por no-shows.

**¿Qué es un no-show?**

Un "no-show" ocurre cuando:
- Haces una reserva
- No cancelas la reserva
- No llegas al espacio reservado en 15 minutos

**Niveles de penalización:**

| No-shows | Consecuencia | Duración |
|----------|--------------|----------|
| **1-2** | Sin penalización | - |
| **3** | ⚠️ Advertencia oficial | Permanente en tu historial |
| **5** | 🚫 Suspensión temporal | 7 días sin poder reservar |
| **10** | 🔒 Suspensión permanente | Cuenta bloqueada |

**Ver tus penalizaciones:**

1. **En tu perfil**, revisa la sección **"Estadísticas"**

2. **Verás:**
   - Total de reservas realizadas
   - Reservas completadas
   - Reservas canceladas
   - **No-shows acumulados**
   - Estado de tu cuenta (Activa, Advertencia, Suspendida)

**Cómo evitar penalizaciones:**

✅ **Haz reservas solo cuando estés cerca** de la universidad  
✅ **Cancela tu reserva** si no puedes llegar  
✅ **Llega a tiempo** dentro de los 15 minutos  
✅ **Verifica tu ubicación** antes de reservar  

> **⚠️ Importante:** Las penalizaciones son automáticas y no se pueden eliminar. Sé responsable con tus reservas.

![Penalizaciones](documentacion/imagenes/manual_usuario/13_penalizaciones.png)

---

## 7. Preguntas Frecuentes (FAQ)

### General

**P: ¿Quién puede usar EstacionaUNSA?**  
R: Cualquier miembro de la comunidad UNSA (estudiantes, docentes, personal administrativo) con un correo institucional @unsa.edu.pe.

**P: ¿La aplicación es gratuita?**  
R: Sí, EstacionaUNSA es completamente gratuita para toda la comunidad UNSA.

**P: ¿Necesito internet para usar la aplicación?**  
R: Sí, necesitas conexión a internet (WiFi o datos móviles) para ver la disponibilidad en tiempo real y hacer reservas.

### Registro y Cuenta

**P: ¿Puedo usar un correo personal?**  
R: No, solo se permiten correos institucionales con dominio @unsa.edu.pe.

**P: ¿Qué hago si no recibo el correo de verificación?**  
R: Revisa tu carpeta de spam. Si no lo encuentras, intenta registrarte nuevamente o contacta al soporte.

**P: ¿Puedo tener múltiples cuentas?**  
R: No, cada persona debe tener solo una cuenta asociada a su correo institucional.

### Vehículos

**P: ¿Cuántos vehículos puedo registrar?**  
R: Puedes registrar múltiples vehículos en tu cuenta.

**P: ¿Puedo usar el vehículo de otra persona?**  
R: Sí, pero debes registrar ese vehículo en tu cuenta antes de hacer una reserva.

**P: ¿Qué pasa si cambio de vehículo?**  
R: Puedes editar o eliminar vehículos en cualquier momento desde tu perfil.

### Reservas

**P: ¿Puedo reservar con anticipación desde mi casa?**  
R: No, debes estar a 500 metros o menos de la zona para poder reservar.

**P: ¿Puedo extender mi reserva de 15 minutos?**  
R: No, las reservas no son renovables. Tienes 15 minutos para llegar.

**P: ¿Qué pasa si llego tarde?**  
R: Si no llegas en 15 minutos, la reserva expirará y se contará como no-show.

**P: ¿Puedo reservar para otra persona?**  
R: No, las reservas son personales y deben coincidir con el vehículo registrado en tu cuenta.

**P: ¿Cuánto tiempo puedo estar estacionado?**  
R: No hay límite de tiempo una vez que ingresas. El límite de 15 minutos es solo para la reserva.

### Problemas Técnicos

**P: La aplicación no detecta mi ubicación**  
R: Asegúrate de tener el GPS activado y haber concedido permisos de ubicación a la aplicación.

**P: No puedo hacer una reserva**  
R: Verifica que:
- Estés a 500m o menos de la zona
- No tengas otra reserva activa
- Tu cuenta no esté suspendida
- Haya espacios disponibles

**P: Mi reserva no aparece**  
R: Cierra y vuelve a abrir la aplicación. Si el problema persiste, contacta al soporte.

---

## 8. Solución de Problemas

### Problema: No puedo iniciar sesión

**Posibles causas y soluciones:**

1. **Contraseña incorrecta**
   - Verifica que estás escribiendo correctamente
   - Usa la opción "Olvidé mi contraseña"

2. **Cuenta no verificada**
   - Revisa tu correo y verifica tu cuenta
   - Solicita un nuevo correo de verificación

3. **Correo no institucional**
   - Asegúrate de usar tu correo @unsa.edu.pe

### Problema: No puedo hacer una reserva

**Posibles causas y soluciones:**

1. **Fuera del rango de 500m**
   - Acércate más a la universidad
   - Verifica que tu GPS esté activado

2. **Ya tienes una reserva activa**
   - Cancela tu reserva actual primero
   - Espera a que expire tu reserva actual

3. **Cuenta suspendida**
   - Revisa tus penalizaciones en el perfil
   - Espera a que termine el período de suspensión

4. **No hay espacios disponibles**
   - Intenta en otra zona
   - Espera a que se libere un espacio

### Problema: La aplicación se cierra inesperadamente

**Soluciones:**

1. **Actualiza la aplicación** a la última versión
2. **Limpia la caché** de la aplicación en configuración del sistema
3. **Reinicia tu dispositivo**
4. **Reinstala la aplicación** si el problema persiste

### Problema: No recibo notificaciones

**Soluciones:**

1. **Verifica los permisos:**
   - Ve a Configuración del sistema
   - Busca EstacionaUNSA
   - Asegúrate de que las notificaciones estén activadas

2. **Revisa la configuración de la app:**
   - Abre EstacionaUNSA
   - Ve a Configuración
   - Activa las notificaciones

3. **Verifica tu conexión a internet**

### Problema: El mapa no carga

**Soluciones:**

1. **Verifica tu conexión a internet**
2. **Activa los servicios de ubicación**
3. **Concede permisos de ubicación** a la aplicación
4. **Reinicia la aplicación**

---

## 9. Contacto y Soporte

### Canales de Soporte

Si tienes problemas técnicos o preguntas que no están cubiertas en este manual:

**📧 Correo Electrónico:**  
soporte.estacionaunsa@unsa.edu.pe

---

## Información del Proyecto

**Repositorio GitHub:**  
https://github.com/Choflis/EstacionaUNSA.git

**Descarga de la aplicación:**  
El enlace de descarga del APK y el video demostrativo estarán disponibles en Google Drive.

**Equipo de Desarrollo:**
- Luis Guillermo Luque Condori - Líder de Proyecto / Desarrollador Flutter
- Dennis Javier Quispe Saavedra - Diseño UI/UX
- Fernando Miguel Garambel Marín - Backend & Firebase

---

## Licencia y Términos de Uso

EstacionaUNSA es un proyecto académico desarrollado en la Universidad Nacional de San Agustín de Arequipa con fines educativos. El uso de esta aplicación está sujeto a las políticas y reglamentos de la UNSA.
