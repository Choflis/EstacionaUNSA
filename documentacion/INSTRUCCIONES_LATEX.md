# 📄 Documentos LaTeX para Overleaf

Los documentos del proyecto EstacionaUNSA han sido convertidos a formato LaTeX profesional para compilación en Overleaf.

## Archivos Generados

1. **`MANUAL_USUARIO.tex`** (44 KB)
   - Manual completo de usuario
   - 9 secciones principales
   - Tabla de contenidos automática
   - Numeración de secciones
   - 13 referencias a imágenes

2. **`INFORME_FINAL.tex`** (49 KB)
   - Informe técnico completo
   - 14 secciones principales
   - Tabla de contenidos automática
   - Numeración de secciones
   - Tablas y diagramas

## 📤 Cómo Usar en Overleaf

### Opción 1: Subir Archivos Individualmente

1. Ve a [Overleaf](https://www.overleaf.com/)
2. Crea un nuevo proyecto → "Blank Project"
3. Sube el archivo `.tex` correspondiente
4. Sube la carpeta `imagenes/` con todas las capturas
5. Compila con el botón "Recompile"

### Opción 2: Subir como ZIP

1. Crea un ZIP con el archivo `.tex` y la carpeta `imagenes/`:
   ```bash
   # Para el Manual de Usuario
   cd /home/fernando/universidad/construccionDeSoftware/EstacionaUNSA/documentacion
   zip -r MANUAL_USUARIO.zip MANUAL_USUARIO.tex imagenes/manual_usuario/
   
   # Para el Informe Final
   zip -r INFORME_FINAL.zip INFORME_FINAL.tex
   ```

2. En Overleaf: "New Project" → "Upload Project" → Selecciona el ZIP

### Opción 3: Compilar Localmente

Si tienes TeX Live instalado:

```bash
cd /home/fernando/universidad/construccionDeSoftware/EstacionaUNSA/documentacion

# Compilar Manual de Usuario
pdflatex MANUAL_USUARIO.tex
pdflatex MANUAL_USUARIO.tex  # Segunda vez para tabla de contenidos

# Compilar Informe Final
pdflatex INFORME_FINAL.tex
pdflatex INFORME_FINAL.tex  # Segunda vez para tabla de contenidos
```

**Nota:** Se compila dos veces para que la tabla de contenidos se genere correctamente.

## 🎨 Personalización en Overleaf

Una vez en Overleaf, puedes personalizar:

### Cambiar Márgenes

Agrega al inicio del documento (después de `\documentclass`):

```latex
\usepackage[margin=1in]{geometry}
```

### Cambiar Tamaño de Fuente

Modifica la línea `\documentclass`:

```latex
\documentclass[11pt]{article}  % Opciones: 10pt, 11pt, 12pt
```

### Agregar Portada

Antes de `\begin{document}`, agrega:

```latex
\title{Manual de Usuario - EstacionaUNSA}
\author{Luis Luque, Dennis Quispe, Fernando Garambel}
\date{Diciembre 2025}
```

Después de `\begin{document}`, agrega:

```latex
\maketitle
\newpage
```

### Cambiar Idioma de la Tabla de Contenidos

Si quieres que diga "Contenido" en lugar de "Contents", agrega:

```latex
\renewcommand{\contentsname}{Contenido}
```

## 📋 Estructura del Documento LaTeX

Los documentos incluyen:

- ✅ Paquetes necesarios (xcolor, amsmath, graphicx, longtable, etc.)
- ✅ Configuración de idioma español
- ✅ Tabla de contenidos automática
- ✅ Numeración de secciones
- ✅ Soporte para imágenes
- ✅ Tablas formateadas
- ✅ Enlaces internos (hyperref)

## ⚠️ Notas Importantes

### Sobre las Imágenes

Las rutas de las imágenes en el `.tex` son relativas:

```latex
\includegraphics{documentacion/imagenes/manual_usuario/01_pantalla_principal.png}
```

**En Overleaf**, necesitas:
1. Crear la estructura de carpetas: `documentacion/imagenes/manual_usuario/`
2. Subir todas las imágenes en esa ubicación

**O más simple:** Cambia las rutas en el `.tex` a rutas relativas simples:
```latex
\includegraphics{01_pantalla_principal.png}
```
Y sube las imágenes en la raíz del proyecto.

### Sobre los Emojis

Los emojis (📖, 📊, etc.) se mantienen en el `.tex`. Si dan problemas al compilar:

**Solución 1:** Usa XeLaTeX o LuaLaTeX como compilador en Overleaf (en lugar de pdfLaTeX)
- En Overleaf: Menu → Compiler → XeLaTeX

**Solución 2:** Elimina los emojis manualmente del `.tex`

## 🚀 Compilación Rápida

Para compilar rápidamente sin errores de imágenes:

1. Comenta las líneas de imágenes temporalmente:
   ```latex
   % \includegraphics{...}
   ```

2. Compila para verificar el formato

3. Descomenta y sube las imágenes cuando estés listo

## 📊 Resultado Esperado

Ambos documentos generarán PDFs profesionales con:

- Portada con información del proyecto
- Tabla de contenidos clickeable
- Secciones numeradas automáticamente
- Formato consistente y profesional
- Tablas bien formateadas
- Imágenes integradas (cuando se suban)

## 🔧 Solución de Problemas

### Error: "File not found"
- Verifica que las rutas de las imágenes sean correctas
- Asegúrate de haber subido todas las imágenes

### Error: "Unicode character not set up"
- Cambia el compilador a XeLaTeX o LuaLaTeX
- O elimina los emojis del documento

### La tabla de contenidos no aparece
- Compila el documento dos veces
- En Overleaf, haz clic en "Recompile" dos veces

### Las tablas se ven mal
- Asegúrate de tener los paquetes `longtable` y `booktabs`
- Ya están incluidos en los archivos generados

---

**¡Listo para usar en Overleaf!** 🎉

Los archivos están optimizados para compilación profesional y listos para generar PDFs de alta calidad.
