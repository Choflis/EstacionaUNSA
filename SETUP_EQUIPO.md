# 🚀 Guía de Configuración para el Equipo - EstacionaUNSA

Esta guía te ayudará a configurar el entorno de desarrollo para trabajar en el proyecto EstacionaUNSA.

---

## 📋 Requisitos Previos

### Software Necesario:
1. **Flutter SDK** (versión estable más reciente)
   - Descargar: https://docs.flutter.dev/get-started/install/windows
   
2. **Android Studio** (incluye Android SDK)
   - Descargar: https://developer.android.com/studio
   
3. **Git**
   - Descargar: https://git-scm.com/download/win
   
4. **VS Code** (recomendado) o Android Studio como IDE
   - Descargar VS Code: https://code.visualstudio.com/
   - Extensiones necesarias para VS Code:
     - Flutter
     - Dart
     - Firebase Tools (opcional)

---

## 🔧 Configuración Inicial (Primera vez)

### Paso 1: Verificar Flutter
```bash
flutter doctor
```

Si aparecen errores:
- **Android licenses**: Ejecutar `flutter doctor --android-licenses` y aceptar todo con `y`
- **Visual Studio** (Windows apps): Solo necesario si vas a desarrollar para Windows
- **Chrome**: Para desarrollo web

### Paso 2: Clonar el Repositorio
```bash
# Navegar a tu carpeta de proyectos
cd "ruta/a/tu/carpeta"

# Clonar el repositorio
git clone https://github.com/Choflis/EstacionaUNSA.git

# Entrar a la carpeta del proyecto
cd EstacionaUNSA/estaciona_unsa
```

### Paso 3: Instalar Dependencias
```bash
flutter pub get
```

### Paso 4: Verificar Configuración
```bash
# Ver si Flutter detecta tu dispositivo/emulador
flutter devices

# Analizar el código (debe dar 0 errores)
flutter analyze
```

---

## 🔥 Configuración de Firebase (IMPORTANTE)

### Problema Actual: Google Sign-In NO está configurado

El archivo `google-services.json` actual **NO tiene OAuth configurado**, por lo que Google Sign-In **NO funcionará**.

### Solución - Configurar OAuth:

#### 1. Obtener tu SHA-1 (cada desarrollador tiene uno diferente)
```bash
cd android
./gradlew signingReport
```
O en Windows:
```bash
cd android
gradlew signingReport
```

Busca la línea que dice `SHA1:` en la sección de `debug`. Copia ese valor.

**Ejemplo:**
```
SHA1: BA:CA:6B:53:A6:8D:15:25:D6:5A:9A:1C:12:53:5F:19:25:E3:80:D3
```

#### 2. Ir a Firebase Console
1. Ve a: https://console.firebase.google.com
2. Selecciona el proyecto **"estacionaunsa"**
3. Ve a **"Project Settings"** (⚙️)
4. En la sección **"Your apps"**, selecciona la app Android
5. Haz clic en **"Add fingerprint"**
6. Pega tu SHA-1 y guarda

#### 3. Habilitar Google Sign-In
1. En Firebase Console, ve a **"Authentication"**
2. Pestaña **"Sign-in method"**
3. Habilitar **"Google"**
4. Configurar email de soporte: `tu-email@unsa.edu.pe`

#### 4. Descargar nuevo google-services.json
1. En "Project Settings" > "Your apps" > Android app
2. Clic en **"Download google-services.json"**
3. Reemplazar el archivo en: `android/app/google-services.json`

#### 5. IMPORTANTE para el equipo
**Cada miembro del equipo debe:**
- Obtener su propio SHA-1
- Agregarlo a Firebase Console
- Todos pueden usar el **mismo** `google-services.json` después de agregar sus SHA-1

---

## 🏃‍♂️ Ejecutar el Proyecto

### Opción 1: Emulador Android
```bash
# Iniciar emulador desde Android Studio o con:
flutter emulators --launch <emulator-id>

# Correr la app
flutter run
```

### Opción 2: Dispositivo Físico
1. Habilitar "Modo Desarrollador" en tu teléfono Android
2. Habilitar "Depuración USB"
3. Conectar por USB
4. Ejecutar:
```bash
flutter run
```

### Opción 3: Chrome (Web)
```bash
flutter run -d chrome
```

---

## 📁 Estructura del Proyecto

```
estaciona_unsa/
├── lib/
│   ├── config/          # Configuraciones (rutas, temas, constantes)
│   ├── models/          # Modelos de datos
│   ├── providers/       # Estado global (Provider)
│   ├── screens/         # Pantallas de la app
│   │   ├── login_screen.dart
│   │   └── home_screen.dart
│   ├── services/        # Lógica de negocio y Firebase
│   ├── widgets/         # Componentes reutilizables
│   ├── utils/           # Utilidades y helpers
│   ├── main.dart        # Punto de entrada
│   └── firebase_options.dart
├── android/             # Configuración Android
├── ios/                 # Configuración iOS
└── pubspec.yaml         # Dependencias
```

---

## 🎨 Workflow de Desarrollo

### Antes de Empezar a Trabajar
```bash
# Actualizar tu rama local
git pull origin main

# Crear una rama para tu feature
git checkout -b feature/nombre-de-tu-feature
```

### Mientras Trabajas
```bash
# Ver cambios
git status

# Agregar archivos modificados
git add .

# Hacer commit
git commit -m "feat: descripción clara de lo que hiciste"

# Subir tu rama
git push origin feature/nombre-de-tu-feature
```

### Buenas Prácticas de Commits
- `feat:` - Nueva funcionalidad
- `fix:` - Corrección de bug
- `docs:` - Documentación
- `style:` - Formato (no afecta funcionalidad)
- `refactor:` - Refactorización de código
- `test:` - Agregar tests

### Pull Requests
1. Subir tu rama a GitHub
2. Crear Pull Request desde GitHub
3. Esperar revisión del equipo
4. Merge a `main` después de aprobación

---

## 🐛 Problemas Comunes

### 1. "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### 2. "Google Sign-In no funciona"
- Verificar que agregaste tu SHA-1 a Firebase
- Descargar el nuevo `google-services.json`
- Hacer `flutter clean` y volver a compilar

### 3. "Firebase not initialized"
- Verificar que existe `lib/firebase_options.dart`
- Si no existe, ejecutar: `flutterfire configure`

### 4. "Hot Reload no funciona"
- Presionar `R` en la consola para hot reload
- Presionar `r` para hot restart
- Si no funciona, detener la app y volver a ejecutar `flutter run`

### 5. Conflictos de Git
```bash
# Guardar cambios locales
git stash

# Actualizar rama
git pull origin main

# Restaurar cambios
git stash pop

# Resolver conflictos manualmente si existen
```

---

## 📚 Recursos Útiles

- **Documentación Flutter**: https://docs.flutter.dev/
- **Firebase Flutter**: https://firebase.google.com/docs/flutter/setup
- **Dart Language**: https://dart.dev/guides
- **Material Design 3**: https://m3.material.io/
- **Provider State Management**: https://pub.dev/packages/provider

---

## 👥 Equipo

- Luis Guillermo Luque Condori — Líder de proyecto / Desarrollador Flutter
- Dennis Javier Quispe Saavedra — Diseño UI/UX
- Fernando Miguel Garambel Marín — Backend & Firebase

---

## 💬 Comunicación

- **Issues**: Reportar bugs o proponer features en GitHub Issues
- **Pull Requests**: Para revisión de código
- **Reuniones**: Coordinar en grupo

---

## ✅ Checklist Antes de Hacer Push

- [ ] El código compila sin errores: `flutter analyze`
- [ ] La app corre correctamente: `flutter run`
- [ ] Agregaste comentarios si el código es complejo
- [ ] Actualizaste README.md si agregaste funcionalidad importante
- [ ] Hiciste commit con mensaje descriptivo
- [ ] La app sigue las convenciones del proyecto

---

## 🚨 Emergencias

Si algo no funciona y estás bloqueado:
1. Revisar esta guía primero
2. Buscar el error en Google/Stack Overflow
3. Preguntar en el grupo
4. Crear un Issue en GitHub describiendo el problema

**¡Nunca hagas `git push --force` a la rama `main`!**

---

## 🎯 Próximos Pasos

1. ✅ Configurar entorno local
2. ✅ Agregar tu SHA-1 a Firebase
3. 🔄 Crear tu primera rama
4. 📝 Empezar a desarrollar siguiendo la arquitectura del proyecto
5. 🔍 Hacer Pull Request para revisión

---

**¿Listo para empezar? ¡Vamos a construir algo increíble! 🚀**
