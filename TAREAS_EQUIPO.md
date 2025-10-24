# 🎯 Tareas Inmediatas - Checklist para el Equipo

## 🚨 PRIORIDAD 1: Configurar Google Sign-In (BLOQUEANTE)

### Responsable Sugerido: Luis (o quien configure primero)

**Tiempo estimado:** 30 minutos

#### Pasos:
1. [ ] Ejecutar `cd android && gradlew signingReport` para obtener SHA-1
2. [ ] Ir a Firebase Console: https://console.firebase.google.com
3. [ ] Seleccionar proyecto "estacionaunsa"
4. [ ] Agregar SHA-1 en Project Settings > Your apps > Android app
5. [ ] Habilitar Google en Authentication > Sign-in method
6. [ ] Descargar nuevo `google-services.json`
7. [ ] Reemplazar archivo en `android/app/google-services.json`
8. [ ] Ejecutar `flutter clean && flutter pub get && flutter run`
9. [ ] Probar login con Google
10. [ ] ✅ Confirmar que funciona antes de continuar

**Documentación:** Ver `CONFIGURAR_GOOGLE_SIGNIN.md`

---

## 📋 PRIORIDAD 2: Setup del Equipo (CADA MIEMBRO)

### Todos los miembros del equipo deben:

#### A. Configuración Inicial (1 hora primera vez)
1. [ ] Instalar Flutter SDK
2. [ ] Instalar Android Studio + Android SDK
3. [ ] Instalar Git
4. [ ] Ejecutar `flutter doctor` y resolver issues
5. [ ] Ejecutar `flutter doctor --android-licenses` (aceptar todo)
6. [ ] Clonar repositorio: `git clone https://github.com/Choflis/EstacionaUNSA.git`
7. [ ] Entrar a carpeta: `cd EstacionaUNSA/estaciona_unsa`
8. [ ] Ejecutar `flutter pub get`

**Documentación:** Ver `SETUP_EQUIPO.md`

#### B. Configurar su SHA-1 Personal (15 min)
1. [ ] Obtener su propio SHA-1: `cd android && gradlew signingReport`
2. [ ] Enviarlo al admin del proyecto Firebase (Luis)
3. [ ] Esperar que el admin lo agregue a Firebase
4. [ ] Hacer `git pull` para obtener el `google-services.json` actualizado
5. [ ] Probar que Google Sign-In funciona en su máquina

---

## 🎨 PRIORIDAD 3: Definir Tareas del Sprint 1

### Reunión de Planning (1-2 horas)

#### Agenda:
1. [ ] Definir el MVP (Producto Mínimo Viable)
2. [ ] Dividir tareas entre el equipo
3. [ ] Estimar tiempos
4. [ ] Crear issues en GitHub para cada tarea
5. [ ] Asignar responsables

#### Decisiones a tomar:
- [ ] ¿Qué pantallas son prioritarias?
- [ ] ¿Qué campos tiene un espacio de estacionamiento?
- [ ] ¿Cómo funciona el sistema de reservas?
- [ ] ¿Hay roles de usuario (admin, usuario normal)?
- [ ] ¿Necesitamos sistema de pagos?

---

## 💼 DISTRIBUCIÓN SUGERIDA DE TAREAS

### Luis (Líder / Flutter Dev)
**Sprint 1 (Semana 1-2):**
- [ ] Configurar Google Sign-In ← URGENTE
- [ ] Crear modelo `User` en `lib/models/user_model.dart`
- [ ] Implementar `AuthService` completo en `lib/services/firebase/auth_service.dart`
- [ ] Crear `AuthProvider` en `lib/providers/auth_provider.dart`
- [ ] Mejorar `HomeScreen` con datos reales
- [ ] Code reviews de PRs del equipo

### Dennis (UI/UX)
**Sprint 1 (Semana 1-2):**
- [ ] Diseñar mockups/prototipos en Figma/Adobe XD
- [ ] Definir paleta de colores en `lib/config/theme.dart`
- [ ] Crear componentes reutilizables:
  - [ ] `CustomButton` en `lib/widgets/common/custom_button.dart`
  - [ ] `CustomTextField` en `lib/widgets/common/custom_text_field.dart`
  - [ ] `LoadingIndicator` en `lib/widgets/common/loading_indicator.dart`
- [ ] Diseñar `ParkingCard` en `lib/widgets/parking/parking_card.dart`

### Fernando (Backend / Firebase)
**Sprint 1 (Semana 1-2):**
- [ ] Diseñar esquema de Firestore (colecciones y documentos)
- [ ] Crear modelos de datos:
  - [ ] `ParkingSpot` en `lib/models/parking_spot_model.dart`
  - [ ] `Reservation` en `lib/models/reservation_model.dart`
- [ ] Implementar `FirestoreService` en `lib/services/firebase/firestore_service.dart`
- [ ] Configurar reglas de seguridad de Firestore
- [ ] Poblar datos de prueba en Firestore

---

## 📁 ESTRUCTURA DE ARCHIVOS A CREAR

### Sprint 1 - Archivos Prioritarios:

```
lib/
├── config/
│   ├── theme.dart           ← Dennis
│   ├── routes.dart          ← Luis
│   └── constants.dart       ← Todos
│
├── models/
│   ├── user_model.dart      ← Luis
│   ├── parking_spot_model.dart  ← Fernando
│   └── reservation_model.dart   ← Fernando
│
├── providers/
│   ├── auth_provider.dart   ← Luis
│   └── parking_provider.dart    ← Fernando
│
├── services/
│   └── firebase/
│       ├── auth_service.dart    ← Luis
│       └── firestore_service.dart   ← Fernando
│
├── screens/
│   ├── login_screen.dart    ✅ Ya existe
│   ├── home_screen.dart     ✅ Ya existe (mejorar)
│   └── parking/
│       └── parking_list_screen.dart  ← Todos
│
└── widgets/
    ├── common/
    │   ├── custom_button.dart   ← Dennis
    │   ├── custom_text_field.dart   ← Dennis
    │   └── loading_indicator.dart   ← Dennis
    └── parking/
        └── parking_card.dart    ← Dennis
```

---

## 🔄 WORKFLOW DIARIO SUGERIDO

### Para cada tarea:
1. [ ] Actualizar rama main: `git pull origin main`
2. [ ] Crear rama nueva: `git checkout -b feature/nombre-descriptivo`
3. [ ] Desarrollar la funcionalidad
4. [ ] Probar que funciona: `flutter run`
5. [ ] Commit: `git commit -m "feat: descripción clara"`
6. [ ] Push: `git push origin feature/nombre-descriptivo`
7. [ ] Crear Pull Request en GitHub
8. [ ] Esperar code review
9. [ ] Merge después de aprobación

### Daily Standup (15 min diarios):
- ¿Qué hice ayer?
- ¿Qué haré hoy?
- ¿Tengo algún bloqueador?

---

## 📊 MÉTRICAS DE ÉXITO - SPRINT 1

### Objetivos:
- [ ] Google Sign-In funcionando en todas las máquinas
- [ ] Al menos 3 pantallas completas
- [ ] Modelos de datos definidos
- [ ] Servicios Firebase implementados
- [ ] Datos de prueba en Firestore
- [ ] App corre sin errores en modo debug

### Definition of Done (DoD):
Una tarea está "Done" cuando:
- [ ] El código compila sin errores
- [ ] `flutter analyze` da 0 issues
- [ ] La funcionalidad está probada manualmente
- [ ] Hay código review aprobado
- [ ] Está mergeado a `main`

---

## 🗓️ CRONOGRAMA SUGERIDO (4 SEMANAS)

### Semana 1: Setup y Modelos
- Día 1-2: Configurar entornos y Google Sign-In
- Día 3-4: Crear modelos de datos
- Día 5-7: Implementar servicios básicos

### Semana 2: UI Básica
- Día 8-10: Pantalla de lista de estacionamientos
- Día 11-13: Pantalla de detalle
- Día 14: Integración y testing

### Semana 3: Funcionalidad Core
- Día 15-17: Sistema de reservas
- Día 18-20: Disponibilidad en tiempo real
- Día 21: Testing y fixes

### Semana 4: Pulido
- Día 22-24: Manejo de errores y validaciones
- Día 25-27: UI/UX refinamiento
- Día 28: Testing final y demo

---

## 🎓 RECURSOS ÚTILES

### Comunicación:
- **GitHub Issues:** Para reportar bugs y proponer features
- **Pull Requests:** Para code reviews
- **WhatsApp/Discord:** Para coordinación rápida

### Aprendizaje:
- **Flutter Docs:** https://docs.flutter.dev/
- **Firebase Docs:** https://firebase.google.com/docs
- **Dart Pad:** https://dartpad.dev/ (para probar código rápido)

### Herramientas:
- **Figma:** Para diseño UI/UX
- **Postman:** Para probar APIs si es necesario
- **DevTools:** `flutter pub global activate devtools` y luego `flutter pub global run devtools`

---

## 🚫 QUÉ NO HACER

- ❌ **NO** hacer `git push --force` a la rama `main`
- ❌ **NO** commitear archivos grandes (imágenes > 5MB)
- ❌ **NO** commitear credenciales o API keys
- ❌ **NO** trabajar directamente en `main`, usar branches
- ❌ **NO** ignorar los code reviews
- ❌ **NO** dejar código comentado (usar Git para historial)
- ❌ **NO** agregar dependencias sin consultar al equipo

---

## ✅ QUÉ SÍ HACER

- ✅ Hacer commits frecuentes y pequeños
- ✅ Escribir mensajes de commit descriptivos
- ✅ Pedir ayuda cuando estés bloqueado
- ✅ Hacer code reviews constructivos
- ✅ Documentar funciones complejas
- ✅ Probar antes de hacer push
- ✅ Comunicar cambios importantes

---

## 📞 CONTACTOS DEL EQUIPO

**Luis Guillermo Luque Condori**
- Rol: Líder / Flutter Dev
- Responsabilidades: Configuración, servicios, coordinación
- GitHub: @Choflis (?)

**Dennis Javier Quispe Saavedra**
- Rol: UI/UX Designer
- Responsabilidades: Diseño, widgets, tema

**Fernando Miguel Garambel Marín**
- Rol: Backend & Firebase
- Responsabilidades: Modelos, Firestore, Cloud Functions

---

## 🎯 ACCIÓN INMEDIATA (HOY)

1. **Luis:** Configurar Google Sign-In (30 min)
2. **Todos:** Leer `SETUP_EQUIPO.md` (15 min)
3. **Todos:** Configurar entorno local (1 hora)
4. **Todos:** Reunión de planning (1 hora)
5. **Todos:** Crear sus primeras branches y empezar a trabajar

---

**¿Preguntas? ¡Comunícalas al equipo!**

**¡Vamos a hacer un gran proyecto! 🚀**
