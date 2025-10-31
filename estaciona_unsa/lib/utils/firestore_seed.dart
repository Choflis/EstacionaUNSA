import 'package:cloud_firestore/cloud_firestore.dart';

/// Script para inicializar la base de datos con datos de prueba
/// IMPORTANTE: Ejecutar solo UNA VEZ después de crear el proyecto en Firebase
class FirestoreSeed {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Ejecutar todos los seeds
  Future<void> runAll() async {
    print('\n🌱 ========== INICIANDO SEED DE BASE DE DATOS ==========\n');
    
    try {
      await seedParkingZones();
      await seedParkingSpots();
      await seedAppSettings();
      
      print('\n🎉 ========== SEED COMPLETADO EXITOSAMENTE! ==========\n');
      print('✅ Verifica los datos en Firebase Console: https://console.firebase.google.com\n');
    } catch (e) {
      print('\n❌ ERROR EN SEED: $e\n');
      rethrow;
    }
  }

  /// Crear las 3 zonas de estacionamiento principales
  Future<void> seedParkingZones() async {
    print('📍 Creando zonas de estacionamiento...\n');

    final zones = [
      {
        'name': 'Zona A - Entrada Principal',
        'location': {
          'latitude': -16.4055,
          'longitude': -71.5375,
          'address': 'Av. Independencia - Entrada Principal UNSA',
          'building': 'Zona A',
          'floor': 'Exterior',
        },
        'capacity': {
          'totalSpots': 50,
          'availableSpots': 50,
          'occupiedSpots': 0,
          'reservedSpots': 0,
          'maintenanceSpots': 0,
        },
        'schedule': {
          'monday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'tuesday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'wednesday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'thursday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'friday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'saturday': {'isOpen': true, 'openTime': '08:00', 'closeTime': '14:00'},
          'sunday': {'isOpen': false, 'openTime': null, 'closeTime': null},
        },
        'isActive': true,
      },
      {
        'name': 'Zona B - Biblioteca Central',
        'location': {
          'latitude': -16.4060,
          'longitude': -71.5370,
          'address': 'Av. Venezuela - Biblioteca Central UNSA',
          'building': 'Zona B',
          'floor': 'Exterior',
        },
        'capacity': {
          'totalSpots': 30,
          'availableSpots': 30,
          'occupiedSpots': 0,
          'reservedSpots': 0,
          'maintenanceSpots': 0,
        },
        'schedule': {
          'monday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'tuesday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'wednesday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'thursday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'friday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'saturday': {'isOpen': true, 'openTime': '08:00', 'closeTime': '14:00'},
          'sunday': {'isOpen': false, 'openTime': null, 'closeTime': null},
        },
        'isActive': true,
      },
      {
        'name': 'Zona C - Ingenierías',
        'location': {
          'latitude': -16.4065,
          'longitude': -71.5380,
          'address': 'Av. Ejército - Pabellón de Ingenierías UNSA',
          'building': 'Zona C',
          'floor': 'Exterior',
        },
        'capacity': {
          'totalSpots': 40,
          'availableSpots': 40,
          'occupiedSpots': 0,
          'reservedSpots': 0,
          'maintenanceSpots': 0,
        },
        'schedule': {
          'monday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'tuesday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'wednesday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'thursday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'friday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
          'saturday': {'isOpen': true, 'openTime': '08:00', 'closeTime': '14:00'},
          'sunday': {'isOpen': false, 'openTime': null, 'closeTime': null},
        },
        'isActive': true,
      },
    ];

    for (int i = 0; i < zones.length; i++) {
      final zoneId = 'zone_${String.fromCharCode(65 + i).toLowerCase()}'; // zone_a, zone_b, zone_c
      await _firestore.collection('parking_zones').doc(zoneId).set({
        ...zones[i],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('  ✅ ${zones[i]['name']} creada (ID: $zoneId)');
    }
    print('\n✅ Total zonas creadas: ${zones.length}\n');
  }

  /// Crear espacios de estacionamiento en cada zona
  Future<void> seedParkingSpots() async {
    print('🚗 Creando espacios de estacionamiento...\n');

    // Zona A: 50 espacios
    await _createSpotsForZone('zone_a', 'A', 50);
    
    // Zona B: 30 espacios
    await _createSpotsForZone('zone_b', 'B', 30);
    
    // Zona C: 40 espacios
    await _createSpotsForZone('zone_c', 'C', 40);

    print('\n✅ Total espacios creados: 120\n');
  }

  /// Helper para crear espacios de una zona específica
  Future<void> _createSpotsForZone(String zoneId, String zoneLetter, int count) async {
    final batch = _firestore.batch();
    int batchCount = 0;

    for (int i = 1; i <= count; i++) {
      final spotNumber = i.toString().padLeft(3, '0');
      final spotId = '$zoneLetter-$spotNumber';
      
      // Determinar tipo de espacio (cada 10 espacios, 1 es para motocicleta)
      final type = (i % 10 == 0) ? 'motorcycle' : 'regular';
      
      final spotRef = _firestore.collection('parking_spots').doc(spotId);
      
      batch.set(spotRef, {
        'zoneId': zoneId,
        'status': 'available',
        'type': type,
        'currentOccupancy': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      batchCount++;

      // Firestore permite máximo 500 operaciones por batch
      if (batchCount >= 500) {
        await batch.commit();
        batchCount = 0;
      }
    }

    // Commit del último batch si quedaron operaciones pendientes
    if (batchCount > 0) {
      await batch.commit();
    }

    print('  ✅ Zona $zoneLetter: $count espacios creados');
  }

  /// Crear configuración global de la aplicación
  Future<void> seedAppSettings() async {
    print('⚙️  Creando configuración de la app...\n');

    await _firestore.collection('app_settings').doc('config').set({
      'reservationSettings': {
        'maxDurationMinutes': 15,
        'maxDistanceMeters': 500,
        'autoExpireEnabled': true,
        'allowMultipleReservations': false,
      },
      'incidentSettings': {
        'noShowWarningThreshold': 3,
        'noShowSuspensionThreshold': 5,
        'noShowBanThreshold': 10,
        'suspensionDurationDays': 7,
      },
      'universityLocation': {
        'latitude': -16.4055,
        'longitude': -71.5375,
        'name': 'Universidad Nacional de San Agustín',
        'address': 'Av. Independencia s/n, Arequipa, Perú',
      },
      'maintenanceMode': false,
      'version': '1.0.0',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    print('  ✅ Configuración global creada\n');
  }

  /// Limpiar toda la base de datos (usar con precaución)
  Future<void> clearAll() async {
    print('\n🗑️  ========== LIMPIANDO BASE DE DATOS ==========\n');
    print('⚠️  ADVERTENCIA: Esto eliminará TODOS los datos!\n');

    try {
      await _deleteCollection('parking_zones');
      await _deleteCollection('parking_spots');
      await _deleteCollection('reservations');
      await _deleteCollection('entry_exit_logs');
      await _deleteCollection('incidents');
      await _deleteCollection('app_settings');
      
      print('\n✅ Base de datos limpiada\n');
    } catch (e) {
      print('\n❌ Error limpiando base de datos: $e\n');
      rethrow;
    }
  }

  /// Helper para eliminar una colección completa
  Future<void> _deleteCollection(String collectionName) async {
    final snapshot = await _firestore.collection(collectionName).get();
    final batch = _firestore.batch();
    int count = 0;

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
      count++;
      
      if (count >= 500) {
        await batch.commit();
        count = 0;
      }
    }

    if (count > 0) {
      await batch.commit();
    }

    print('  ✅ Colección "$collectionName" eliminada (${snapshot.docs.length} documentos)');
  }
}

/// Función helper para ejecutar el seed desde main.dart
Future<void> runFirestoreSeed() async {
  final seed = FirestoreSeed();
  await seed.runAll();
}

/// Función helper para limpiar la base de datos
Future<void> clearFirestore() async {
  final seed = FirestoreSeed();
  await seed.clearAll();
}
