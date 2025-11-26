import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Servicio para Firebase Cloud Messaging (notificaciones push)
/// Este servicio maneja las notificaciones push de Firebase
/// 
/// NOTA: Requiere configuración adicional en Firebase Console
/// y en la app (permisos, configuración de plataforma)
class MessagingService {
  static final MessagingService _instance = MessagingService._internal();
  factory MessagingService() => _instance;
  MessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  bool _isInitialized = false;

  String? get fcmToken => _fcmToken;
  bool get isInitialized => _isInitialized;

  // ========== INICIALIZAR FCM ==========

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Solicitar permisos (iOS principalmente)
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ Permisos de notificaciones concedidos');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('⚠️ Permisos provisionales concedidos');
      } else {
        print('❌ Permisos de notificaciones denegados');
        return;
      }

      // Obtener token FCM
      _fcmToken = await _firebaseMessaging.getToken();
      print('📱 FCM Token: $_fcmToken');

      // Configurar notificaciones locales
      await _initializeLocalNotifications();

      // Configurar listeners de mensajes
      _configureForegroundMessageHandler();
      _configureBackgroundMessageHandler();

      // Listener para refresh de token
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        print('🔄 FCM Token actualizado: $newToken');
        // TODO: Enviar nuevo token al backend
      });

      _isInitialized = true;
      print('✅ MessagingService inicializado');
    } catch (e) {
      print('❌ Error inicializando MessagingService: $e');
      rethrow;
    }
  }

  // ========== CONFIGURAR NOTIFICACIONES LOCALES ==========

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Configurar canal de notificaciones para Android
    const androidChannel = AndroidNotificationChannel(
      'estaciona_unsa_channel',
      'EstacionaUNSA Notifications',
      description: 'Notificaciones de reservas y disponibilidad',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  // ========== MENSAJES EN PRIMER PLANO ==========

  void _configureForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Mensaje recibido en primer plano: ${message.messageId}');
      
      // Mostrar notificación local cuando la app está en primer plano
      _showLocalNotification(message);
    });
  }

  // ========== MENSAJES EN SEGUNDO PLANO ==========

  void _configureBackgroundMessageHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📬 Notificación abierta: ${message.messageId}');
      _handleMessageTap(message);
    });

    // Verificar si la app se abrió desde una notificación
    _checkForInitialMessage();
  }

  // ========== VERIFICAR MENSAJE INICIAL ==========

  Future<void> _checkForInitialMessage() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('🚀 App abierta desde notificación: ${initialMessage.messageId}');
      _handleMessageTap(initialMessage);
    }
  }

  // ========== MOSTRAR NOTIFICACIÓN LOCAL ==========

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'estaciona_unsa_channel',
            'EstacionaUNSA Notifications',
            channelDescription: 'Notificaciones de reservas y disponibilidad',
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: message.data.toString(),
      );
    }
  }

  // ========== MANEJAR TAP EN NOTIFICACIÓN ==========

  void _onNotificationTapped(NotificationResponse response) {
    print('👆 Notificación tocada: ${response.payload}');
    // TODO: Navegar a pantalla específica según el payload
  }

  void _handleMessageTap(RemoteMessage message) {
    final data = message.data;
    print('📲 Datos del mensaje: $data');
    
    // TODO: Manejar navegación según el tipo de notificación
    // Ejemplo:
    // if (data['type'] == 'reservation') {
    //   navigatorKey.currentState?.pushNamed('/reservation', arguments: data['reservationId']);
    // }
  }

  // ========== SUSCRIBIRSE A TOPIC ==========

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('✅ Suscrito al topic: $topic');
    } catch (e) {
      print('❌ Error suscribiéndose al topic $topic: $e');
      rethrow;
    }
  }

  // ========== CANCELAR SUSCRIPCIÓN A TOPIC ==========

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('✅ Desuscrito del topic: $topic');
    } catch (e) {
      print('❌ Error desuscribiéndose del topic $topic: $e');
      rethrow;
    }
  }

  // ========== TOPICS ESPECÍFICOS DE LA APP ==========

  // Suscribirse a notificaciones de una zona específica
  Future<void> subscribeToZone(String zoneId) async {
    await subscribeToTopic('zone_$zoneId');
  }

  // Cancelar notificaciones de una zona
  Future<void> unsubscribeFromZone(String zoneId) async {
    await unsubscribeFromTopic('zone_$zoneId');
  }

  // Suscribirse a notificaciones generales
  Future<void> subscribeToGeneralNotifications() async {
    await subscribeToTopic('general');
  }

  // Suscribirse a notificaciones según rol
  Future<void> subscribeByRole(String role) async {
    await subscribeToTopic('role_$role');
  }

  // ========== ENVIAR TOKEN AL BACKEND ==========

  Future<void> sendTokenToServer(String userId) async {
    if (_fcmToken == null) return;

    try {
      // TODO: Implementar envío al backend
      // Ejemplo usando Firestore:
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(userId)
      //     .update({'fcmToken': _fcmToken});
      
      print('📤 Token enviado al servidor para user: $userId');
    } catch (e) {
      print('❌ Error enviando token al servidor: $e');
    }
  }

  // ========== ELIMINAR TOKEN DEL BACKEND ==========

  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      print('🗑️ Token FCM eliminado');
    } catch (e) {
      print('❌ Error eliminando token: $e');
    }
  }

  // ========== OBTENER NUEVO TOKEN ==========

  Future<String?> refreshToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      print('🔄 Token FCM refrescado: $_fcmToken');
      return _fcmToken;
    } catch (e) {
      print('❌ Error refrescando token: $e');
      return null;
    }
  }
}

// ========== HANDLER PARA MENSAJES EN BACKGROUND (TOP-LEVEL FUNCTION) ==========

/// Esta función debe estar fuera de la clase y ser top-level
/// para que Firebase pueda ejecutarla en background
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Inicializar Firebase si es necesario
  // await Firebase.initializeApp();
  
  print('🔔 Mensaje recibido en background: ${message.messageId}');
  print('Título: ${message.notification?.title}');
  print('Cuerpo: ${message.notification?.body}');
  print('Datos: ${message.data}');
}

/*
========== CONFIGURACIÓN REQUERIDA ==========

1. Agregar dependencias en pubspec.yaml:
   dependencies:
     firebase_messaging: ^14.0.0
     flutter_local_notifications: ^16.0.0

2. Android - Agregar en AndroidManifest.xml:
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   <uses-permission android:name="android.permission.VIBRATE" />
   
   <meta-data
       android:name="com.google.firebase.messaging.default_notification_channel_id"
       android:value="estaciona_unsa_channel" />

3. iOS - Agregar en Info.plist:
   <key>UIBackgroundModes</key>
   <array>
       <string>remote-notification</string>
   </array>

4. En main.dart, inicializar antes de runApp:
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     
     // Configurar handler de background
     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
     
     // Inicializar servicio de mensajería
     await MessagingService().initialize();
     
     runApp(MyApp());
   }

5. Firebase Console:
   - Habilitar Cloud Messaging
   - Configurar APNs para iOS
   - Agregar SHA-256 para Android

========== USO EN LA APP ==========

// En cualquier parte de la app:
final messagingService = MessagingService();

// Obtener token
final token = messagingService.fcmToken;

// Suscribirse a topics
await messagingService.subscribeToZone('zona_a');
await messagingService.subscribeByRole('student');

// Enviar token al servidor
await messagingService.sendTokenToServer(userId);

*/
