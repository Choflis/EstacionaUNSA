# 🅿️ Sistema EstacionaUNSA — Casos de Uso y Descripción Funcional

## 1. Descripción general

El sistema **EstacionaUNSA** busca optimizar el control de acceso, disponibilidad y administración del estacionamiento universitario.  
El **diagrama general de casos de uso** representa la interacción de los diferentes actores con las funcionalidades del sistema, dividiendo las operaciones en tres zonas principales:

- **Administración:** gestión de usuarios, estacionamientos y reportes.  
- **Operaciones:** registro de entradas y salidas de vehículos.  
- **Consulta y experiencia de usuario:** visualización de disponibilidad y notificaciones.

---

## 2. Actores del sistema

| Actor | Descripción |
|--------|--------------|
| **Administrador** | Supervisa y gestiona usuarios, reportes, notificaciones y parámetros del estacionamiento. |
| **Vigilante** | Encargado de registrar entradas y salidas de vehículos en tiempo real. |
| **Usuario (Estudiante/Docente/Visitante)** | Consulta disponibilidad de espacios, recibe notificaciones y accede a su cuenta. |
| **Sistema de Sensores (Futuro)** | Actor externo que actualiza automáticamente el estado de los espacios mediante sensores físicos. |

---

## 3. Casos de Uso del Sistema

| Código | Nombre del Caso de Uso | Actor Principal |
|--------|------------------------|----------------|
| CU01 | Iniciar sesión | Todos |
| CU02 | Consultar disponibilidad | Usuario |
| CU03 | Visualizar mapa del campus | Usuario |
| CU04 | Registrar entrada de vehículo | Vigilante |
| CU05 | Registrar salida de vehículo | Vigilante |
| CU06 | Recibir notificaciones | Usuario |
| CU07 | Gestionar usuarios | Administrador |
| CU08 | Gestionar estacionamientos | Administrador |
| CU09 | Consultar / Generar reportes | Administrador |
| CU10 | Reportar incidencia | Vigilante |
| CU11 | Integrar sensores / visión computacional (futuro) | Sistema de Sensores |

---

## 4. Relaciones entre casos de uso

### Asociaciones
- Usuario ↔ (CU02, CU03, CU06, CU01)  
- Vigilante ↔ (CU04, CU05, CU10, CU01)  
- Administrador ↔ (CU07, CU08, CU09, CU01)  
- Sistema de Sensores ↔ (CU11)

### Relaciones `<<include>>`
- CU04 **Registrar entrada** `<<include>>` CU01 **Iniciar sesión**  
- CU05 **Registrar salida** `<<include>>` CU01 **Iniciar sesión**

### Relaciones `<<extend>>`
- CU04 **Registrar entrada** `<<extend>>` CU06 **Notificar usuario**  
- CU05 **Registrar salida** `<<extend>>` CU09 **Generar cobro / reporte**  
- CU10 **Reportar incidencia** `<<extend>>` CU04 / CU05

---

## 5. Estructura visual del Diagrama (recomendación para draw.io)

- Rectángulo central: `Sistema EstacionaUNSA`
- Lado izquierdo: **Administrador** (arriba) y **Vigilante** (medio)
- Lado derecho: **Usuario** (centro) y **Sistema de Sensores** (arriba)
- Dentro del sistema:
  - Zona superior izquierda → Casos administrativos (CU07–CU09)
  - Zona media izquierda → Casos operativos (CU04–CU05–CU10)
  - Zona derecha → Casos de usuario (CU02–CU03–CU06)
  - Parte superior centro → CU01 Iniciar sesión
  - Extremo inferior → CU11 Integrar sensores (futuro)

---

## 6. Descripción detallada de casos de uso

A continuación se describen los casos de uso del sistema (CU01–CU11).  
Cada uno está documentado con la estructura recomendada para Ingeniería de Requisitos.

---

### CU01 – Iniciar sesión

| Campo | Descripción |
|--------|--------------|
| **Actor principal:** | Todos los actores |
| **Descripción:** | Permite al usuario autenticarse en el sistema mediante credenciales válidas. |
| **Precondición:** | El usuario debe tener una cuenta registrada. |
| **Flujo principal:** | 1. El usuario ingresa usuario y contraseña.<br>2. El sistema valida credenciales.<br>3. Se muestra la interfaz principal según el rol. |
| **Flujos alternativos:** | A1: Contraseña incorrecta → Mensaje de error.<br>A2: Cuenta bloqueada → Solicitar restablecimiento. |
| **Postcondición:** | El usuario accede al sistema. |
| **Criterio de aceptación:** | Acceso válido habilita funciones del rol correspondiente. |
| **Requisitos relacionados:** | RNF03 (Seguridad), RF01 (Gestión de acceso) |

---

### CU02 – Consultar disponibilidad

| Campo | Descripción |
|--------|--------------|
| **Actor principal:** | Usuario |
| **Descripción:** | Permite visualizar la cantidad de espacios disponibles en tiempo real. |
| **Precondición:** | El usuario ha iniciado sesión. |
| **Flujo principal:** | 1. Usuario selecciona “Consultar disponibilidad”.<br>2. El sistema obtiene datos de ocupación.<br>3. Se muestra lista de espacios libres y ocupados. |
| **Flujos alternativos:** | A1: Error de conexión → Mostrar último valor almacenado. |
| **Postcondición:** | Información mostrada correctamente. |
| **Criterio de aceptación:** | Datos actualizados cada 5 segundos o por evento. |
| **Requisitos relacionados:** | RF01, RNF01 |

---

### CU03 – Visualizar mapa del campus

| Campo | Descripción |
|--------|--------------|
| **Actor principal:** | Usuario |
| **Descripción:** | Permite al usuario ver gráficamente la ubicación de los estacionamientos. |
| **Precondición:** | El sistema posee mapa georreferenciado. |
| **Flujo principal:** | 1. Usuario abre mapa.<br>2. El sistema carga ubicación de zonas y estado de cada una.<br>3. Se muestran íconos con colores según disponibilidad. |
| **Postcondición:** | El usuario puede identificar áreas con espacios libres. |
| **Requisitos relacionados:** | RF01, RF04 |

---

### CU04 – Registrar entrada de vehículo

| Campo | Descripción |
|--------|--------------|
| **Actor principal:** | Vigilante |
| **Descripción:** | Registra la llegada de un vehículo y actualiza la disponibilidad. |
| **Precondición:** | Vigilante autenticado; espacio disponible. |
| **Flujo principal:** | 1. Vigilante selecciona “Registrar entrada”.<br>2. Ingresa placa, tipo de usuario, zona.<br>3. Sistema valida disponibilidad.<br>4. Si hay cupo, se registra entrada y se actualiza contador. |
| **Flujos alternativos:** | A1: Sin cupos → Mostrar mensaje.<br>A2: Placa inválida → Solicitar corrección. |
| **Postcondición:** | Entrada registrada; espacio decrementado. |
| **Criterio de aceptación:** | Registro aparece en reportes y disponibilidad se actualiza. |
| **Requisitos relacionados:** | RF07, RF05 |

---

### CU05 – Registrar salida de vehículo

| Campo | Descripción |
|--------|--------------|
| **Actor principal:** | Vigilante |
| **Descripción:** | Registra la salida de un vehículo y actualiza la disponibilidad. |
| **Precondición:** | Vehículo registrado en el sistema. |
| **Flujo principal:** | 1. Vigilante selecciona “Registrar salida”.<br>2. Ingresa placa.<br>3. Sistema busca registro y lo cierra.<br>4. Actualiza disponibilidad. |
| **Flujos alternativos:** | A1: Placa no encontrada → Mostrar error.<br>A2: Registro ya cerrado → Ignorar duplicado. |
| **Postcondición:** | Registro actualizado; espacio liberado. |
| **Criterio de aceptación:** | Espacio reflejado como disponible inmediatamente. |
| **Requisitos relacionados:** | RF07, RF05 |

---

### CU06 – Recibir notificaciones

| Campo | Descripción |
|--------|--------------|
| **Actor principal:** | Usuario |
| **Descripción:** | Envía alertas al usuario sobre disponibilidad, incidencias o mantenimiento. |
| **Precondición:** | Usuario suscrito a notificaciones. |
| **Flujo principal:** | 1. Sistema detecta evento (cupo lleno o nuevo espacio).<br>2. Envía notificación al usuario. |
| **Postcondición:** | Usuario informado oportunamente. |
| **Requisitos relacionados:** | RF03 |

---

### CU07 – Gestionar usuarios

| Campo | Descripción |
|--------|--------------|
| **Actor principal:** | Administrador |
| **Descripción:** | Permite crear, modificar, eliminar o inactivar cuentas de usuarios. |
| **Precondición:** | Administrador autenticado. |
| **Flujo principal:** | 1. Admin abre módulo de usuarios.<br>2. Selecciona acción (crear/editar/eliminar).<br>3. Confirma operación.<br>4. Sistema actualiza base de datos. |
| **Postcondición:** | Usuarios gestionados correctamente. |
| **Requisitos relacionados:** | RF04, RNF03 |

---

### CU08 – Gestionar estacionamientos

| Campo | Descripción |
|--------|--------------|
| **Actor principal:** | Administrador |
| **Descripción:** | Permite administrar los espacios, zonas y horarios del estacionamiento. |
| **Precondición:** | Administrador autenticado. |
| **Flujo principal:** | 1. Admin selecciona zona.<br>2. Modifica parámetros (capacidad, horario).<br>3. Sistema actualiza configuración. |
| **Postcondición:** | Cambios reflejados en disponibilidad. |
| **Requisitos relacionados:** | RF04, RF06 |

---

### CU09 – Consultar / Generar reportes

| Campo | Descripción |
|--------|--------------|
| **Actor principal:** | Administrador |
| **Descripción:** | Genera reportes de uso, picos de demanda y estadísticas. |
| **Precondición:** | Datos existentes en la base de datos. |
| **Flujo principal:** | 1. Admin elige tipo de reporte.<br>2. Sistema filtra información.<br>3. Genera reporte en PDF/Excel. |
| **Postcondición:** | Reporte generado y descargable. |
| **Requisitos relacionados:** | RF06 |

---

### CU10 – Reportar incidencia

| Campo | Descripción |
|--------|--------------|
| **Actor principal:** | Vigilante |
| **Descripción:** | Reporta fallos, accidentes o incidencias en el estacionamiento. |
| **Precondición:** | Vigilante autenticado. |
| **Flujo principal:** | 1. Selecciona “Reportar incidencia”.<br>2. Ingresa descripción y evidencia (opcional).<br>3. Sistema envía alerta al administrador. |
| **Postcondición:** | Incidencia registrada para revisión. |
| **Requisitos relacionados:** | RF04, RF05 |

---

### CU11 – Integrar sensores / visión computacional (futuro)

| Campo | Descripción |
|--------|--------------|
| **Actor principal:** | Sistema de Sensores |
| **Descripción:** | Actualiza automáticamente la disponibilidad según detección física. |
| **Precondición:** | Hardware conectado. |
| **Flujo principal:** | 1. Sensor detecta vehículo.<br>2. Envía evento al sistema.<br>3. Se actualiza base de datos. |
| **Postcondición:** | Disponibilidad reflejada en tiempo real. |
| **Requisitos relacionados:** | RF08 (evolutivo) |

---

## 7. Mapeo de Casos de Uso ↔ Requisitos Funcionales

| Caso de Uso | Requisitos Funcionales Asociados |
|--------------|----------------------------------|
| CU01 | RNF03, RF01 |
| CU02 | RF01, RNF01 |
| CU03 | RF01, RF04 |
| CU04 | RF07, RF05 |
| CU05 | RF07, RF05 |
| CU06 | RF03 |
| CU07 | RF04, RNF03 |
| CU08 | RF04, RF06 |
| CU09 | RF06 |
| CU10 | RF04, RF05 |
| CU11 | RF08 |

---

## 8. Recomendaciones finales

- Mantener **consistencia entre casos de uso y requerimientos**.  
- Cada CU debe reflejar una **entidad clave** o **acción del sistema** (base para las tablas).  
- Usar herramientas UML estándar como **draw.io**, **Visual Paradigm** o **StarUML**.  
- Estas tablas sirven de **base directa para modelar la base de datos relacional**, identificando:
  - Actores → roles (tabla `usuarios`)
  - Casos de uso → módulos o entidades (`entradas`, `salidas`, `reportes`, `zonas`, `incidencias`)
  - Relaciones → claves foráneas (ej. vehículo → usuario)

---

## 9. Referencias (APA 7)

- Sommerville, I. (2016). *Software Engineering* (10th ed.). Pearson Education.  
- Pressman, R. S., & Maxim, B. R. (2020). *Software Engineering: A Practitioner’s Approach* (9th ed.). McGraw-Hill.  
- Object Management Group (OMG). (2017). *Unified Modeling Language (UML) Specification*, Version 2.5.1.  
- Jacobson, I. (1992). *Object-Oriented Software Engineering: A Use Case Driven Approach*. Addison-Wesley.  
- Pohl, K. (2010). *Requirements Engineering: Fundamentals, Principles, and Techniques*. Springer-Verlag.  

---

> 📘 **Nota:**  
> Este documento `.md` se puede integrar en GitHub, Notion, o en la documentación técnica del proyecto para conectar directamente los **casos de uso con los módulos de la base de datos**.

