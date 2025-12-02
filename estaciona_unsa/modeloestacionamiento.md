

## 1. 📝 Propósito

Este documento describe las características visuales y funcionales del estacionamiento **Alpha** (basado en la imagen aérea) para guiar su implementación como un activo o vista en la aplicación móvil.

## 2. 🎨 Elementos de Diseño Requeridos

| Elemento | Descripción para el Diseño | Notas |
| :--- | :--- | :--- |
| **Fondo/Superficie** | Textura de **grava/tierra compactada** de color gris claro/marrón claro. | Debe verse rústico, no como asfalto nuevo. |
| **Demarcación de Cajones** | **Líneas blancas sólidas** (finas) que delimitan los cajones. | Los cajones deben permitir la representación de vehículos en paralelo. |
| **Vegetación (Árboles)** | Íconos o modelos de **árboles frondosos de copa redonda** (verdes). | Se deben colocar dentro del lote, **interfiriendo** con la rejilla de estacionamiento para reflejar la imagen original (ofreciendo sombra). |
| **Marcador P** | Ícono de una **'P' blanca sobre un círculo azul** o punto de interés. | Ubicarlo en la zona central/superior del lote. |
| **Vehículos** | Íconos/modelos de vehículos (pocos) para mostrar ocupación parcial. | Usar colores neutros (blanco, gris). |

## 3. 🗺️ Especificaciones de Layout

* **Forma del Lote:** Irregular y orgánica, con bordes que no son perfectamente rectangulares.
* **Disposición:** Un **carril central** para la circulación y espacios de estacionamiento a ambos lados.
* **Capacidad Estimada:** Aprox. 10 a 14 vehículos en total.
* **Perspectiva:** El diseño debe mantener una **perspectiva ligeramente inclinada (isométrica o vista de pájaro 3D)** para dar sensación de profundidad.

## 4. ⚙️ Requerimientos de UX/UI Adicionales

* **Estado de Disponibilidad:** La aplicación debe reflejar el estado operativo.
    * **Requerimiento Actual:** Incluir una etiqueta de advertencia: **"Cerrado temporalmente"** cerca del ícono de la 'P'.
    * **Lógica:** Si el estado es "Cerrado", se debe deshabilitar o mostrar como inactivo cualquier botón de reserva o interacción principal.
* **Interactividad:** Los cajones individuales deben ser elementos táctiles (`tappable`) para futuras funcionalidades (ej. ver detalles del espacio o reservar).

## 5. 🔔 Próximos Pasos

Confirmar el estilo de renderizado (2D plano o 3D isométrico) con el equipo de arte antes de la creación final de activos.