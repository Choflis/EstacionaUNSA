# 🚀 Guía de Configuración - EstacionaUNSA

Guía completa para configurar el entorno de desarrollo del proyecto EstacionaUNSA.

---

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- ✅ Flutter SDK (>=3.0.0)
- ✅ Dart SDK
- ✅ Android Studio o VS Code
- ✅ Git
- ✅ Cuenta de Google (Gmail)
- ✅ Firebase CLI (opcional pero recomendado)

---

## 🔥 Configuración de Firebase

### Paso 1: Crear Proyecto en Firebase Console

1. Ve a https://console.firebase.google.com
2. Inicia sesión con tu cuenta de Google
3. Click en **"Agregar proyecto"**
4. Nombre del proyecto: **"EstacionaUNSA"**
5. Habilitar Google Analytics: **SÍ** (recomendado)
6. Click en **"Crear proyecto"**
7. Esperar 30-60 segundos

### Paso 2: Configurar App Android

1. En el panel de Firebase, click en el ícono de **Android**
2. Nombre del paquete: `com.example.estaciona_unsa`
   - Verifica en: `android/app/build.gradle.kts`
   - Busca: `namespace = "com.example.estaciona_unsa"`
3. Apodo de la app: **EstacionaUNSA Android**
4. Certificado SHA-1: **Dejar en blanco por ahora** (lo agregarás después)
5. Click **"Registrar app"**
6. **Descargar** `google-services.json`
7. Colocar en: `android/app/google-services.json`

### Paso 3: Configurar Firebase en Flutter

#### Opción A: FlutterFire CLI (Recomendado - Automático)

```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase automáticamente
flutterfire configure

# Seleccionar el proyecto "EstacionaUNSA"
# Seleccionar plataformas: Android, iOS, Web
```

Esto generará automáticamente:
- `lib/firebase_options.dart`
- Configuración para todas las plataformas

#### Opción B: Manual

1. Agregar dependencias en `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^4.2.0
  firebase_auth: ^6.1.1
  cloud_firestore: ^6.0.3
  firebase_messaging: ^16.0.3
```

2. Ejecutar:

```bash
flutter pub get
```

3. Inicializar Firebase en `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

---

## 🔐 Configurar Google Sign-In

### Paso 1: Obtener tu SHA-1

Cada desarrollador necesita agregar su SHA-1 de debug.

**En Windows (PowerShell o CMD):**

```bash
cd android
gradlew signingReport
```

**En Linux/Mac:**

```bash
cd android
./gradlew signingReport
```

Busca en la salida:

```
Variant: debug
Config: debug
SHA1: BA:CA:6B:53:A6:8D:15:25:D6:5A:9A:1C:12:53:5F:19:25:E3:80:D3
```

**📋 Copia el valor del SHA1**

### Paso 2: Agregar SHA-1 a Firebase

1. Ve a Firebase Console → ⚙️ **Project Settings**
2. Scroll a la sección **"Your apps"**
3. Selecciona la app Android
4. Scroll a **"SHA certificate fingerprints"**
5. Click **"Add fingerprint"**
6. Pega tu SHA-1
7. Click **"Save"**

### Paso 3: Habilitar Google Authentication

1. Firebase Console → **Authentication**
2. Pestaña **"Sign-in method"**
3. Click en **Google**
4. Habilitar el switch
5. Configurar email de soporte del proyecto
6. Click **"Save"**

### Paso 4: Descargar nuevo google-services.json

1. Firebase Console → ⚙️ **Project Settings**
2. Scroll a **"Your apps"** → App Android
3. Click **"google-services.json"** (ícono de descarga)
4. **Reemplazar** el archivo en `android/app/google-services.json`

### Paso 5: Configurar dependencias

Agregar en `pubspec.yaml`:

```yaml
dependencies:
  google_sign_in: ^6.1.4
```

Ejecutar:

```bash
flutter pub get
```

---

## 🗄️ Configurar Firestore

### Paso 1: Habilitar Firestore

1. Firebase Console → **Firestore Database**
2. Click **"Crear base de datos"**
3. Modo: **"Comenzar en modo de prueba"** (30 días)
4. Ubicación: **southamerica-east1 (São Paulo)**
5. Click **"Habilitar"**
6. Esperar 1-2 minutos

### Paso 2: Desplegar Reglas de Seguridad

**Opción A: Firebase CLI**

```bash
firebase login
firebase deploy --only firestore:rules
```

**Opción B: Manual en Firebase Console**

1. Firestore Database → **Reglas**
2. Copiar contenido de `firestore.rules`
3. Pegar en el editor
4. Click **"Publicar"**

### Paso 3: Inicializar con Datos de Prueba

Edita temporalmente `lib/main.dart`:

```dart
import 'utils/firestore_seed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Ejecutar solo UNA VEZ
  await runFirestoreSeed();
  
  runApp(const MyApp());
}
```

Esto crea:
- 3 Zonas de estacionamiento (A, B, C)
- 120 Espacios distribuidos
- Configuración inicial del sistema

> ⚠️ **IMPORTANTE:** Después de ejecutar una vez, comenta la línea `await runFirestoreSeed();`

---

## 💻 Configuración del Equipo

### Para cada Desarrollador

1. **Clonar el repositorio:**

```bash
git clone [url-del-repositorio]
cd EstacionaUNSA/estaciona_unsa
```

2. **Instalar dependencias:**

```bash
flutter pub get
cd functions
npm install
cd ..
```

3. **Agregar tu SHA-1 a Firebase** (ver sección anterior)

4. **Verificar instalación:**

```bash
flutter doctor
```

Todos los checks deben estar en ✅

5. **Ejecutar la app:**

```bash
flutter run
```

---

## 🔧 Comandos Útiles

```bash
# Limpiar proyecto
flutter clean && flutter pub get

# Analizar código
flutter analyze

# Ver dispositivos disponibles
flutter devices

# Ejecutar en modo debug
flutter run

# Ejecutar en modo release
flutter run --release

# Ver logs detallados
flutter run -v

# Hot reload (en la consola)
# Presionar 'r'

# Hot restart (en la consola)
# Presionar 'R'
```

---

## 🆘 Solución de Problemas

### Error: "Firebase not initialized"

```bash
flutter clean
flutter pub get
flutterfire configure
```

### Error: "PERMISSION_DENIED" en Firestore

```bash
firebase deploy --only firestore:rules
```

O verifica manualmente en Firebase Console → Firestore → Reglas

### Error: Google Sign-In no funciona

1. Verifica que agregaste tu SHA-1 a Firebase
2. Descarga el nuevo `google-services.json`
3. Limpia el proyecto: `flutter clean && flutter pub get`
4. Desinstala la app del dispositivo y vuelve a ejecutar

### Web no carga

- Verifica scripts de Firebase en `web/index.html`
- Abre consola del navegador (F12) para ver errores
- Revisa `firebase_options.dart`

### Error de licencias Android

```bash
flutter doctor --android-licenses
```

Acepta todas las licencias presionando 'y'

---

## 🎓 Recursos Útiles

**Documentación:**
- [Flutter](https://docs.flutter.dev/)
- [Firebase para Flutter](https://firebase.google.com/docs/flutter/setup)
- [FlutterFire](https://firebase.flutter.dev/)
- [Firestore](https://firebase.google.com/docs/firestore)

**Tutoriales:**
- [Flutter Codelabs](https://docs.flutter.dev/codelabs)
- [Firebase Quickstart](https://github.com/firebase/quickstart-flutter)

---

## ✅ Checklist de Configuración

- [ ] Flutter y Android Studio instalados
- [ ] Proyecto Firebase creado
- [ ] App Android registrada en Firebase
- [ ] `google-services.json` descargado y colocado
- [ ] FlutterFire CLI configurado
- [ ] SHA-1 agregado a Firebase
- [ ] Google Sign-In habilitado
- [ ] Firestore creado y reglas desplegadas
- [ ] Dependencias instaladas (`flutter pub get`)
- [ ] App ejecuta sin errores
- [ ] Autenticación funciona
- [ ] Conexión a Firestore funciona

---

**¡Listo para desarrollar! 🚀**
