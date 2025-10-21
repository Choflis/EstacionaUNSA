# Services - Firebase

Servicios que interactúan directamente con Firebase.

## Archivos que irán aquí:
- `auth_service.dart` - Autenticación (login, registro, logout)
- `firestore_service.dart` - CRUD a Cloud Firestore
- `messaging_service.dart` - Firebase Cloud Messaging (notificaciones push)
- `storage_service.dart` - Firebase Storage (si se necesita subir archivos)

Estos servicios:
- Encapsulan la lógica de Firebase
- NO manejan estado (solo operaciones)
- Retornan Futures o Streams
- Manejan errores y los propagan
