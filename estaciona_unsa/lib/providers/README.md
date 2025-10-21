# Providers

Gestión de estado global usando el patrón Provider.

## Archivos que irán aquí:
- `auth_provider.dart` - Estado de autenticación y usuario actual
- `parking_provider.dart` - Estado de espacios de estacionamiento
- `reservation_provider.dart` - Estado de reservas
- `notification_provider.dart` - Estado de notificaciones

Cada provider:
- Extiende de `ChangeNotifier`
- Maneja el estado de una funcionalidad específica
- Expone métodos para modificar el estado
- Llama a `notifyListeners()` cuando hay cambios
- Usa services para comunicarse con Firebase
