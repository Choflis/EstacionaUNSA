# 🔐 Guía Detallada: Configurar Google Sign-In

## ⚠️ Problema Actual

El archivo `google-services.json` tiene `oauth_client: []` **VACÍO**, por lo que Google Sign-In **NO FUNCIONA**.

**SHA-1 detectado en tu máquina:**
```
BA:CA:6B:53:A6:8D:15:25:D6:5A:9A:1C:12:53:5F:19:25:E3:80:D3
```

---

## 🎯 Solución Paso a Paso

### Paso 1: Verificar tu SHA-1 (10 minutos)

Cada desarrollador tiene un SHA-1 único para su máquina de desarrollo. Necesitas obtenerlo y agregarlo a Firebase.

#### En Windows (PowerShell o CMD):
```bash
cd "C:\Users\luisg\OneDrive\Documentos\unsa\6TO SEMESTRE\CS\EstacionaUNSA\estaciona_unsa\android"

.\gradlew signingReport
```

#### Buscar la salida:
```
Variant: debug
Config: debug
Store: C:\Users\TU_USUARIO\.android\debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA1: BA:CA:6B:53:A6:8D:15:25:D6:5A:9A:1C:12:53:5F:19:25:E3:80:D3  ← ESTE ES TU SHA-1
SHA-256: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
Valid until: ...
```

**📋 Copia el valor del SHA1 (con los dos puntos)**

---

### Paso 2: Ir a Firebase Console (5 minutos)

1. **Abrir navegador**: https://console.firebase.google.com
2. **Iniciar sesión** con la cuenta de Google que tiene acceso al proyecto
3. **Seleccionar proyecto**: `estacionaunsa`

---

### Paso 3: Agregar tu SHA-1 (3 minutos)

#### 3.1 Ir a Project Settings
- Clic en el ícono de engranaje ⚙️ al lado de "Project Overview"
- Seleccionar **"Project settings"**

#### 3.2 Seleccionar la App Android
- Scroll hacia abajo hasta la sección **"Your apps"**
- Deberías ver una app Android con el package name: `com.example.estaciona_unsa`
- Si no hay app Android, primero debes registrar una

#### 3.3 Agregar SHA-1
- Scroll hacia abajo hasta la sección **"SHA certificate fingerprints"**
- Clic en **"Add fingerprint"**
- Pegar tu SHA-1: `BA:CA:6B:53:A6:8D:15:25:D6:5A:9A:1C:12:53:5F:19:25:E3:80:D3`
- Clic en **"Save"**

**📸 Captura de pantalla recomendada para el equipo:**
Haz screenshot de esta configuración para que otros miembros sepan dónde agregar su SHA-1.

---

### Paso 4: Habilitar Google Authentication (5 minutos)

#### 4.1 Ir a Authentication
- En el menú lateral izquierdo de Firebase Console
- Clic en **"Authentication"** (icono de llave 🔑)

#### 4.2 Pestaña Sign-in method
- Clic en la pestaña **"Sign-in method"**
- Buscar **"Google"** en la lista de proveedores

#### 4.3 Habilitar Google
- Clic en **"Google"**
- Activar el toggle para **"Enable"**
- En **"Project support email"**: Seleccionar tu email o agregar uno del dominio `@unsa.edu.pe`
- Clic en **"Save"**

#### 4.4 (Opcional) Configurar dominio autorizado
- Si solo quieres permitir correos `@unsa.edu.pe`:
  - Scroll hacia abajo en Authentication
  - En "Authorized domains", agregar: `unsa.edu.pe`

---

### Paso 5: Descargar nuevo google-services.json (2 minutos)

#### 5.1 Volver a Project Settings
- ⚙️ > Project settings > Your apps > Android app

#### 5.2 Descargar archivo
- Clic en **"google-services.json"** (botón de descarga)
- Se descargará un archivo `google-services.json`

#### 5.3 Reemplazar archivo existente
```bash
# Ruta del archivo a reemplazar:
EstacionaUNSA/estaciona_unsa/android/app/google-services.json
```

**⚠️ IMPORTANTE:** No eliminar el archivo viejo, solo reemplázalo con el nuevo.

---

### Paso 6: Verificar el archivo (2 minutos)

Abre el nuevo `google-services.json` y verifica que ahora tenga contenido en `oauth_client`:

```json
{
  "client": [
    {
      "client_info": { ... },
      "oauth_client": [
        {
          "client_id": "XXXXXX.apps.googleusercontent.com",
          "client_type": 3
        }
      ],
      ...
    }
  ]
}
```

**✅ Si ves contenido en `oauth_client`, ¡está correcto!**

---

### Paso 7: Limpiar y Recompilar (3 minutos)

```bash
# Limpiar cache de Flutter
flutter clean

# Re-instalar dependencias
flutter pub get

# Recompilar la app
flutter run
```

---

### Paso 8: Probar Google Sign-In (5 minutos)

1. **Iniciar la app**
2. En la pantalla de login, clic en **"Continuar con Google"**
3. Debería aparecer el selector de cuentas de Google
4. Seleccionar tu cuenta `@unsa.edu.pe` (o cualquier cuenta para pruebas)
5. **Verificar que la autenticación funcione**

#### Qué esperar:
- ✅ **Funciona**: Te lleva a la `HomeScreen` con tu nombre/email
- ❌ **No funciona**: Error como "API not enabled" o "Invalid client ID"

---

## 🧑‍🤝‍🧑 Para Miembros del Equipo

**Cada miembro del equipo debe:**

### 1. Obtener su SHA-1
```bash
cd ruta/al/proyecto/android
./gradlew signingReport
# Copiar el SHA1 de la sección "debug"
```

### 2. Enviarlo al administrador del proyecto Firebase
- El admin debe agregar cada SHA-1 en Firebase Console
- Cada vez que se agrega uno nuevo, descargar el `google-services.json` actualizado

### 3. Actualizar el archivo
- Hacer `git pull` para obtener el `google-services.json` actualizado
- O recibirlo por otro medio y reemplazarlo en `android/app/`

### 4. Recompilar
```bash
flutter clean && flutter pub get && flutter run
```

---

## 🏢 Configuración para Release (Producción)

Cuando quieras publicar la app en Google Play Store, necesitarás:

### 1. Crear un Keystore de Release
```bash
keytool -genkey -v -keystore ~/estaciona-release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias estaciona
```

### 2. Obtener SHA-1 del Keystore de Release
```bash
keytool -list -v -keystore ~/estaciona-release.keystore -alias estaciona
```

### 3. Agregar SHA-1 de Release a Firebase
- Mismo proceso que el debug
- Descargar nuevo `google-services.json`

### 4. Configurar Gradle para usar el keystore
Editar `android/key.properties` y `android/app/build.gradle`.

---

## 🐛 Solución de Problemas

### Error: "API not enabled for project"
**Solución:**
1. Ve a: https://console.cloud.google.com/
2. Selecciona el proyecto `estacionaunsa`
3. Ve a "APIs & Services" > "Library"
4. Buscar "Google Sign-In API" y habilitarlo

### Error: "Developer console is not set up correctly"
**Solución:**
- Verificar que el SHA-1 esté agregado en Firebase
- Descargar nuevo `google-services.json`
- `flutter clean && flutter run`

### Error: "Invalid client ID"
**Solución:**
- El `google-services.json` está desactualizado
- Descargar uno nuevo desde Firebase Console

### No aparece selector de cuentas de Google
**Solución:**
```bash
# Limpiar cache de Google Sign-In
flutter clean
cd android
./gradlew clean
cd ..
flutter run --no-sound-null-safety
```

---

## 📊 Verificación Final

### Checklist:
- [ ] SHA-1 agregado a Firebase Console
- [ ] Google Sign-In habilitado en Authentication
- [ ] `google-services.json` actualizado con `oauth_client` lleno
- [ ] `flutter clean && flutter pub get` ejecutado
- [ ] App recompilada y probada
- [ ] Autenticación funciona correctamente

---

## 📞 Contacto

Si después de seguir esta guía aún tienes problemas:
1. Revisa los logs de error: `flutter run -v`
2. Busca el error específico en Google
3. Pregunta en el grupo del equipo
4. Crea un Issue en GitHub con los logs

---

**¡Listo! Ahora Google Sign-In debería funcionar correctamente. 🎉**
