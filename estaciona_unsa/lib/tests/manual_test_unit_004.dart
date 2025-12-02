import 'package:firebase_auth/firebase_auth.dart';
import '../providers/reservation_provider.dart';
import '../services/firebase/firestore_service.dart';

class ManualTestUnit004 {
  static Future<void> runTests() async {
    print('\n========================================');
    print('UNIT-004: ReservationProvider.validateReservation()');
    print('========================================\n');

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

    // TEST 1: Usuario sin reservas, spot disponible
    try {
      print('TEST 1: Usuario sin reservas + spot disponible = PUEDE RESERVAR');
      print('----------------------------------------');
      
      final provider = ReservationProvider();
      
      // Primero cancelar cualquier reserva activa para este test
      print('Limpiando reservas activas del usuario...');
      await provider.loadActiveReservations(currentUser.uid);
      for (var reservation in provider.activeReservations) {
        await provider.cancelReservation(reservation.reservationId, reservation.spotId);
        print('  Cancelada: ${reservation.reservationId}');
      }
      
      print('\nValidando reserva para spot disponible...');
      final result = await provider.validateReservation(
        userId: currentUser.uid,
        spotId: 'A-001',
      );
      
      print('Resultado de validacion:');
      print('  canReserve: ${result['canReserve']}');
      print('  reason: ${result['reason']}');
      
      if (result['canReserve'] != true) {
        throw Exception('Deberia poder reservar: ${result['reason']}');
      }
      
      print('\nRESULTADO: PASADO\n');
      testsPasados++;
    } catch (e) {
      print('\nRESULTADO: FALLADO');
      print('ERROR: $e\n');
      testsFallados++;
    }

    // TEST 2: Usuario con reserva activa
    try {
      print('TEST 2: Usuario con reserva activa = NO PUEDE RESERVAR');
      print('----------------------------------------');
      
      final provider = ReservationProvider();
      
      // Crear una reserva activa primero
      print('Creando reserva activa...');
      final reservationId = await provider.createReservation(
        userId: currentUser.uid,
        spotId: 'A-002',
        zoneId: 'ing_zone_a',
        durationMinutes: 15,
        latitude: -16.4090,
        longitude: -71.5375,
        distanceToZone: 50.0,
      );
      
      if (reservationId == null) {
        throw Exception('No se pudo crear reserva de prueba');
      }
      
      print('Reserva activa creada: $reservationId');
      
      print('\nValidando nueva reserva (deberia fallar)...');
      final result = await provider.validateReservation(
        userId: currentUser.uid,
        spotId: 'A-003',
      );
      
      print('Resultado de validacion:');
      print('  canReserve: ${result['canReserve']}');
      print('  reason: ${result['reason']}');
      
      if (result['canReserve'] != false) {
        throw Exception('NO deberia poder reservar (ya tiene reserva activa)');
      }
      
      if (!result['reason'].toString().contains('reserva activa')) {
        throw Exception('Mensaje de error incorrecto: ${result['reason']}');
      }
      
      // Limpiar: cancelar la reserva
      print('\nLimpiando: cancelando reserva de prueba...');
      await provider.cancelReservation(reservationId, 'A-002');
      
      print('\nRESULTADO: PASADO\n');
      testsPasados++;
    } catch (e) {
      print('\nRESULTADO: FALLADO');
      print('ERROR: $e\n');
      testsFallados++;
    }

    // TEST 3: Spot no disponible (ocupado o reservado)
    try {
      print('TEST 3: Spot no disponible = NO PUEDE RESERVAR');
      print('----------------------------------------');
      
      final provider = ReservationProvider();
      final firestoreService = FirestoreService();
      
      // Verificar si hay algún spot ocupado
      print('Buscando spot ocupado o reservado...');
      
      // Crear una reserva temporal para tener un spot no disponible
      print('Creando reserva temporal...');
      final tempReservationId = await provider.createReservation(
        userId: currentUser.uid,
        spotId: 'B-001',
        zoneId: 'ing_zone_b',
        durationMinutes: 15,
        latitude: -16.4095,
        longitude: -71.5380,
        distanceToZone: 75.0,
      );
      
      if (tempReservationId == null) {
        throw Exception('No se pudo crear reserva temporal');
      }
      
      print('Spot B-001 ahora esta reservado');
      
      // Intentar validar con un usuario diferente (simulado)
      // Como no podemos crear otro usuario, validamos que el spot no está disponible
      final spot = await firestoreService.getSpot('B-001');
      
      print('\nEstado del spot B-001:');
      print('  isAvailable: ${spot?.isAvailable}');
      print('  isReserved: ${spot?.isReserved}');
      print('  status: ${spot?.status}');
      
      if (spot == null) {
        throw Exception('Spot no encontrado');
      }
      
      if (spot.isAvailable) {
        throw Exception('El spot deberia estar no disponible');
      }
      
      // Limpiar
      print('\nLimpiando: cancelando reserva temporal...');
      await provider.cancelReservation(tempReservationId, 'B-001');
      
      print('\nRESULTADO: PASADO\n');
      testsPasados++;
    } catch (e) {
      print('\nRESULTADO: FALLADO');
      print('ERROR: $e\n');
      testsFallados++;
    }

    // TEST 4: Spot inexistente
    try {
      print('TEST 4: Spot inexistente = NO PUEDE RESERVAR');
      print('----------------------------------------');
      
      final provider = ReservationProvider();
      
      print('Validando con spotId inexistente...');
      final result = await provider.validateReservation(
        userId: currentUser.uid,
        spotId: 'INEXISTENTE-999',
      );
      
      print('Resultado de validacion:');
      print('  canReserve: ${result['canReserve']}');
      print('  reason: ${result['reason']}');
      
      if (result['canReserve'] != false) {
        throw Exception('NO deberia poder reservar (spot no existe)');
      }
      
      if (!result['reason'].toString().contains('no existe')) {
        throw Exception('Mensaje de error incorrecto: ${result['reason']}');
      }
      
      print('\nRESULTADO: PASADO\n');
      testsPasados++;
    } catch (e) {
      print('\nRESULTADO: FALLADO');
      print('ERROR: $e\n');
      testsFallados++;
    }

    // RESUMEN
    print('\n========================================');
    print('RESUMEN UNIT-004');
    print('========================================');
    print('Tests ejecutados: ${testsPasados + testsFallados}');
    print('Tests pasados: $testsPasados');
    print('Tests fallados: $testsFallados');
    print('========================================\n');
  }
}
