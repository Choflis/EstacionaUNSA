import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase/firestore_service.dart';
import '../models/reservation_model.dart';

class ManualTestUnit002 {
  static Future<void> runTests() async {
    print('\n========================================');
    print('UNIT-002: FirestoreService.createReservation()');
    print('========================================\n');

    final service = FirestoreService();
    final currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser == null) {
      print('ERROR: No hay usuario autenticado');
      print('Por favor inicia sesion primero\n');
      return;
    }

    print('Usuario autenticado: ${currentUser.email}');
    print('UID: ${currentUser.uid}\n');

    int testsPasados = 0;
    int testsFallados = 0;

    // TEST 1
    try {
      print('TEST 1: Crear reserva con datos validos retorna ID');
      print('----------------------------------------');
      
      final now = DateTime.now();
      final reservation = ReservationModel(
        reservationId: '',
        userId: currentUser.uid, // CORREGIDO: Usar UID real
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
      
      print('\nCreando reserva en Firestore...');
      final reservationId = await service.createReservation(reservation);

      print('Reserva creada exitosamente');
      print('  reservationId: $reservationId');

      if (reservationId.isEmpty || reservationId.length < 10) {
        throw Exception('ID invalido');
      }

      print('\nVerificando que existe en Firestore...');
      final retrieved = await service.getReservation(reservationId);
      
      if (retrieved == null) {
        throw Exception('No se pudo recuperar la reserva');
      }

      if (retrieved.userId != reservation.userId ||
          retrieved.spotId != reservation.spotId ||
          retrieved.status != 'active') {
        throw Exception('Datos no coinciden');
      }

      print('Verificacion exitosa');
      print('  userId: ${retrieved.userId}');
      print('  spotId: ${retrieved.spotId}');
      print('  status: ${retrieved.status}');
      
      print('\nRESULTADO: PASADO\n');
      testsPasados++;
    } catch (e) {
      print('\nRESULTADO: FALLADO');
      print('ERROR: $e\n');
      testsFallados++;
    }

    // TEST 2
    try {
      print('TEST 2: Campos correctamente guardados en Firestore');
      print('----------------------------------------');

      final now = DateTime.now();
      
      final reservation = ReservationModel(
        reservationId: '',
        userId: currentUser.uid, // CORREGIDO: Usar UID real
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

      if (!doc.exists) {
        throw Exception('Documento no existe');
      }
      
      final data = doc.data()!;
      print('\nCampos verificados:');
      print('  userId: ${data['userId']} == ${currentUser.uid}');
      print('  spotId: ${data['spotId']} == spot_B-015');
      print('  zoneId: ${data['zoneId']} == ing_zone_b');
      print('  status: ${data['status']} == active');
      
      if (data['userId'] != currentUser.uid ||
          data['spotId'] != 'spot_B-015' ||
          data['zoneId'] != 'ing_zone_b' ||
          data['status'] != 'active') {
        throw Exception('Campos no coinciden');
      }

      print('\nRESULTADO: PASADO\n');
      testsPasados++;
    } catch (e) {
      print('\nRESULTADO: FALLADO');
      print('ERROR: $e\n');
      testsFallados++;
    }

    // TEST 3
    try {
      print('TEST 3: Timestamps se generan correctamente');
      print('----------------------------------------');

      final now = DateTime.now();
      final reservation = ReservationModel(
        reservationId: '',
        userId: currentUser.uid, // CORREGIDO: Usar UID real
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

      if (retrieved == null) {
        throw Exception('No se pudo recuperar la reserva');
      }

      if (!retrieved.createdAt.isBefore(afterCreate) ||
          !retrieved.createdAt.isAfter(beforeCreate.subtract(Duration(seconds: 5)))) {
        throw Exception('Timestamps fuera de rango');
      }

      print('Timestamp createdAt: ${retrieved.createdAt}');
      print('Timestamp updatedAt: ${retrieved.updatedAt}');
      print('Dentro del rango esperado: SI');
      
      print('\nRESULTADO: PASADO\n');
      testsPasados++;
    } catch (e) {
      print('\nRESULTADO: FALLADO');
      print('ERROR: $e\n');
      testsFallados++;
    }

    // RESUMEN
    print('\n========================================');
    print('RESUMEN UNIT-002');
    print('========================================');
    print('Tests ejecutados: ${testsPasados + testsFallados}');
    print('Tests pasados: $testsPasados');
    print('Tests fallados: $testsFallados');
    print('========================================\n');
  }
}
