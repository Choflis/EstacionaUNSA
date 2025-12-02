import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:estaciona_unsa/services/firebase/firestore_service.dart';
import 'package:estaciona_unsa/models/reservation_model.dart';
import 'package:estaciona_unsa/firebase_options.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    print('\n========================================');
    print('Inicializando Firebase para tests...');
    print('========================================');
    
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase inicializado correctamente');
    } catch (e) {
      print('Error inicializando Firebase: $e');
      print('NOTA: Este test requiere Firebase configurado');
      rethrow;
    }
  });

  group('FirestoreService.createReservation()', () {
    late FirestoreService service;

    setUp(() {
      service = FirestoreService();
    });

    test('Crear reserva con datos validos retorna ID', () async {
      print('\n========================================');
      print('TEST: Crear reserva con datos validos');
      print('========================================');

      final now = DateTime.now();
      final reservation = ReservationModel(
        reservationId: '', // Se generara por Firestore
        userId: 'test_user_${now.millisecondsSinceEpoch}',
        spotId: 'spot_A-001',
        zoneId: 'ing_zone_a',
        time: ReservationTime(
          startedAt: now,
          expiresAt: now.add(Duration(minutes: 15)),
          durationMinutes: 15,
        ),
        status: 'active',
        location: UserLocation(
          latitude: -16.4090,
          longitude: -71.5375,
          distanceToZone: 50.0,
        ),
        createdAt: now,
        updatedAt: now,
      );

      print('Datos de prueba:');
      print('  userId: ${reservation.userId}');
      print('  spotId: ${reservation.spotId}');
      print('  zoneId: ${reservation.zoneId}');
      print('  durationMinutes: ${reservation.time.durationMinutes}');
      print('  status: ${reservation.status}');
      
      print('\nCreando reserva en Firestore...');
      final reservationId = await service.createReservation(reservation);

      print('Reserva creada exitosamente');
      print('  reservationId: $reservationId');

      expect(reservationId, isNotEmpty);
      expect(reservationId.length, greaterThan(10));

      print('\nVerificando que existe en Firestore...');
      final retrieved = await service.getReservation(reservationId);
      
      expect(retrieved, isNotNull);
      expect(retrieved!.userId, reservation.userId);
      expect(retrieved.spotId, reservation.spotId);
      expect(retrieved.zoneId, reservation.zoneId);
      expect(retrieved.status, 'active');

      print('Verificacion exitosa');
      print('  userId: ${retrieved.userId}');
      print('  spotId: ${retrieved.spotId}');
      print('  status: ${retrieved.status}');
      print('\nTEST PASADO\n');
    });

    test('Campos correctamente guardados en Firestore', () async {
      print('\n========================================');
      print('TEST: Verificar campos guardados');
      print('========================================');

      final now = DateTime.now();
      final testUserId = 'test_fields_${now.millisecondsSinceEpoch}';
      
      final reservation = ReservationModel(
        reservationId: '',
        userId: testUserId,
        spotId: 'spot_B-015',
        zoneId: 'ing_zone_b',
        time: ReservationTime(
          startedAt: now,
          expiresAt: now.add(Duration(minutes: 15)),
          durationMinutes: 15,
        ),
        status: 'active',
        location: UserLocation(
          latitude: -16.4095,
          longitude: -71.5380,
          distanceToZone: 75.5,
        ),
        createdAt: now,
        updatedAt: now,
      );

      print('Creando reserva...');
      final id = await service.createReservation(reservation);

      print('Recuperando documento desde Firestore...');
      final doc = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(id)
          .get();

      expect(doc.exists, true);
      
      final data = doc.data()!;
      print('\nCampos verificados:');
      print('  userId: ${data['userId']} == $testUserId');
      print('  spotId: ${data['spotId']} == spot_B-015');
      print('  zoneId: ${data['zoneId']} == ing_zone_b');
      print('  status: ${data['status']} == active');
      
      expect(data['userId'], testUserId);
      expect(data['spotId'], 'spot_B-015');
      expect(data['zoneId'], 'ing_zone_b');
      expect(data['status'], 'active');
      expect(data['time'], isA<Map>());
      expect(data['location'], isA<Map>());
      expect(data['createdAt'], isA<Timestamp>());

      print('\nTEST PASADO\n');
    });

    test('Timestamps se generan correctamente', () async {
      print('\n========================================');
      print('TEST: Verificar timestamps');
      print('========================================');

      final now = DateTime.now();
      final reservation = ReservationModel(
        reservationId: '',
        userId: 'test_timestamp_${now.millisecondsSinceEpoch}',
        spotId: 'spot_C-020',
        zoneId: 'ing_zone_c',
        time: ReservationTime(
          startedAt: now,
          expiresAt: now.add(Duration(minutes: 15)),
          durationMinutes: 15,
        ),
        status: 'active',
        location: UserLocation(latitude: -16.4100, longitude: -71.5385),
        createdAt: now,
        updatedAt: now,
      );

      print('Creando reserva...');
      final beforeCreate = DateTime.now();
      final id = await service.createReservation(reservation);
      final afterCreate = DateTime.now();

      print('Verificando timestamps...');
      final retrieved = await service.getReservation(id);

      expect(retrieved, isNotNull);
      expect(retrieved!.createdAt.isBefore(afterCreate), true);
      expect(retrieved.createdAt.isAfter(beforeCreate.subtract(Duration(seconds: 5))), true);

      print('Timestamp createdAt: ${retrieved.createdAt}');
      print('Timestamp updatedAt: ${retrieved.updatedAt}');
      print('Dentro del rango esperado: SI');
      
      print('\nTEST PASADO\n');
    });
  });

  print('\n========================================');
  print('TODOS LOS TESTS DE UNIT-002 COMPLETADOS');
  print('========================================\n');
}
