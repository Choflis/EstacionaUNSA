import 'package:cloud_firestore/cloud_firestore.dart';

/// Script para inicializar la base de datos con datos de prueba
/// IMPORTANTE: Ejecutar solo UNA VEZ después de crear el proyecto en Firebase
/// 
/// NUEVA VERSIÓN: Incluye soporte para múltiples campus (Ingenierías, Sociales, Biomédicas)
class FirestoreSeed {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Ejecutar todos los seeds
  Future<void> runAll() async {
    print('\n🌱 ========== INICIANDO SEED DE BASE DE DATOS ==========\n');
    
    try {
      await seedCampus();           // ← NUEVO: Crear sedes primero
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

  /// ═══════════════════════════════════════════════════════════════
  /// NUEVO: Crear las 3 sedes/campus universitarios
  /// ═══════════════════════════════════════════════════════════════
  Future<void> seedCampus() async {
    print('🏛️  Creando campus/sedes...\n');

    final campuses = [
      {
        'campusId': 'ingenierias',
        'name': 'Facultad de Ingenierías',
        'shortName': 'Ingenierías',
        'description': 'Campus de la Facultad de Ingeniería de Producción y Servicios',
        'location': {
          'latitude': -16.4065,
          'longitude': -71.538,
          'address': 'Av. Independencia s/n, Arequipa',
          'district': 'Cercado',
          'city': 'Arequipa',
        },
        'stats': {
          'totalZones': 3,
          'totalSpots': 120,
          'availableSpots': 120,
          'occupiedSpots': 0,
          'reservedSpots': 0,
        },
        'contact': {
          'phone': '054-123456',
          'email': 'seguridad.ingenierias@unsa.edu.pe',
          'securityOffice': 'Garita Principal - Av. Ejército',
        },
        'isActive': true,
      },
      {
        'campusId': 'sociales',
        'name': 'Facultad de Ciencias Sociales',
        'shortName': 'Sociales',
        'description': 'Campus de la Facultad de Ciencias Histórico Sociales',
        'location': {
          'latitude': -16.4050,
          'longitude': -71.5360,
          'address': 'Av. Alcides Carrión s/n, Arequipa',
          'district': 'Cercado',
          'city': 'Arequipa',
        },
        'stats': {
          'totalZones': 3,
          'totalSpots': 95,
          'availableSpots': 95,
          'occupiedSpots': 0,
          'reservedSpots': 0,
        },
        'contact': {
          'phone': '054-123457',
          'email': 'seguridad.sociales@unsa.edu.pe',
          'securityOffice': 'Garita - Av. Alcides Carrión',
        },
        'isActive': false, // ← Desactivado por ahora (solo MVP en Ingenierías)
      },
      {
        'campusId': 'biomedicas',
        'name': 'Facultad de Ciencias Biomédicas',
        'shortName': 'Biomédicas',
        'description': 'Campus de Medicina, Enfermería y Ciencias Biomédicas',
        'location': {
          'latitude': -16.4040,
          'longitude': -71.5390,
          'address': 'Av. Daniel Alcides Carrión s/n, Arequipa',
          'district': 'Cercado',
          'city': 'Arequipa',
        },
        'stats': {
          'totalZones': 3,
          'totalSpots': 100,
          'availableSpots': 100,
          'occupiedSpots': 0,
          'reservedSpots': 0,
        },
        'contact': {
          'phone': '054-123458',
          'email': 'seguridad.biomedicas@unsa.edu.pe',
          'securityOffice': 'Garita Hospital Docente',
        },
        'isActive': false, // ← Desactivado por ahora (solo MVP en Ingenierías)
      },
    ];

    for (var campus in campuses) {
      final campusId = campus['campusId'] as String;
      await _firestore.collection('campus').doc(campusId).set({
        'name': campus['name'],
        'shortName': campus['shortName'],
        'description': campus['description'],
        'location': campus['location'],
        'stats': campus['stats'],
        'contact': campus['contact'],
        'isActive': campus['isActive'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('  ✅ ${campus['name']} ${campus['isActive'] == true ? '(ACTIVO)' : '(INACTIVO)'} creado');
    }
    print('\n✅ Total campus creados: ${campuses.length}\n');
  }

  /// Crear las zonas de estacionamiento (ahora asociadas a campus)
  Future<void> seedParkingZones() async {
    print('📍 Creando zonas de estacionamiento...\n');

    final zones = [
      // ═══════════════════════════════════════════════════════════
      // CAMPUS INGENIERÍAS (3 zonas - ACTIVAS)
      // ═══════════════════════════════════════════════════════════
      {
        'zoneId': 'ing_zone_a',
        'campusId': 'ingenierias', // ← FK a campus
        'name': 'Zona A - Entrada Principal Ingenierías',
        'location': {
          'latitude': -16.4065,
          'longitude': -71.538,
          'address': 'Entrada Principal - Ingenierías UNSA',
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
      },
      {
        'zoneId': 'ing_zone_b',
        'campusId': 'ingenierias',
        'name': 'Zona B - Estacionamiento Central',
        'location': {
          'latitude': -16.4065,
          'longitude': -71.538,
          'address': 'Estacionamiento Central - Ingenierías UNSA',
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
      },
      {
        'zoneId': 'ing_zone_c',
        'campusId': 'ingenierias',
        'name': 'Zona C - Pabellón Principal',
        'location': {
          'latitude': -16.4065,
          'longitude': -71.538,
          'address': 'Pabellón Principal - Ingenierías UNSA',
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
      },

      // ═══════════════════════════════════════════════════════════
      // CAMPUS SOCIALES (3 zonas - INACTIVAS por ahora)
      // ═══════════════════════════════════════════════════════════
      {
        'zoneId': 'soc_zone_a',
        'campusId': 'sociales',
        'name': 'Zona D - Entrada Sociales',
        'location': {
          'latitude': -16.4050,
          'longitude': -71.5360,
          'address': 'Av. Alcides Carrión - Entrada Principal',
          'building': 'Zona D',
          'floor': 'Exterior',
        },
        'capacity': {
          'totalSpots': 40,
          'availableSpots': 40,
          'occupiedSpots': 0,
          'reservedSpots': 0,
          'maintenanceSpots': 0,
        },
      },
      {
        'zoneId': 'soc_zone_b',
        'campusId': 'sociales',
        'name': 'Zona E - Patio Central Sociales',
        'location': {
          'latitude': -16.4052,
          'longitude': -71.5362,
          'address': 'Patio Central - Sociales',
          'building': 'Zona E',
          'floor': 'Exterior',
        },
        'capacity': {
          'totalSpots': 25,
          'availableSpots': 25,
          'occupiedSpots': 0,
          'reservedSpots': 0,
          'maintenanceSpots': 0,
        },
      },
      {
        'zoneId': 'soc_zone_c',
        'campusId': 'sociales',
        'name': 'Zona F - Auditorio Sociales',
        'location': {
          'latitude': -16.4055,
          'longitude': -71.5365,
          'address': 'Auditorio Principal - Sociales',
          'building': 'Zona F',
          'floor': 'Exterior',
        },
        'capacity': {
          'totalSpots': 30,
          'availableSpots': 30,
          'occupiedSpots': 0,
          'reservedSpots': 0,
          'maintenanceSpots': 0,
        },
      },

      // ═══════════════════════════════════════════════════════════
      // CAMPUS BIOMÉDICAS (3 zonas - INACTIVAS por ahora)
      // ═══════════════════════════════════════════════════════════
      {
        'zoneId': 'bio_zone_a',
        'campusId': 'biomedicas',
        'name': 'Zona G - Entrada Biomédicas',
        'location': {
          'latitude': -16.4040,
          'longitude': -71.5390,
          'address': 'Av. Daniel Alcides Carrión - Entrada',
          'building': 'Zona G',
          'floor': 'Exterior',
        },
        'capacity': {
          'totalSpots': 35,
          'availableSpots': 35,
          'occupiedSpots': 0,
          'reservedSpots': 0,
          'maintenanceSpots': 0,
        },
      },
      {
        'zoneId': 'bio_zone_b',
        'campusId': 'biomedicas',
        'name': 'Zona H - Laboratorios Biomédicas',
        'location': {
          'latitude': -16.4042,
          'longitude': -71.5392,
          'address': 'Pabellón de Laboratorios',
          'building': 'Zona H',
          'floor': 'Exterior',
        },
        'capacity': {
          'totalSpots': 20,
          'availableSpots': 20,
          'occupiedSpots': 0,
          'reservedSpots': 0,
          'maintenanceSpots': 0,
        },
      },
      {
        'zoneId': 'bio_zone_c',
        'campusId': 'biomedicas',
        'name': 'Zona I - Hospital Docente',
        'location': {
          'latitude': -16.4045,
          'longitude': -71.5395,
          'address': 'Hospital Docente UNSA',
          'building': 'Zona I',
          'floor': 'Exterior',
        },
        'capacity': {
          'totalSpots': 45,
          'availableSpots': 45,
          'occupiedSpots': 0,
          'reservedSpots': 0,
          'maintenanceSpots': 0,
        },
      },
    ];

    // Horario estándar para todas las zonas
    final standardSchedule = {
      'monday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
      'tuesday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
      'wednesday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
      'thursday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
      'friday': {'isOpen': true, 'openTime': '07:00', 'closeTime': '22:00'},
      'saturday': {'isOpen': true, 'openTime': '08:00', 'closeTime': '14:00'},
      'sunday': {'isOpen': false, 'openTime': null, 'closeTime': null},
    };

    for (var zone in zones) {
      final zoneId = zone['zoneId'] as String;
      final campusId = zone['campusId'] as String;
      
      await _firestore.collection('parking_zones').doc(zoneId).set({
        'name': zone['name'],
        'campusId': campusId, // ← FK a campus
        'location': zone['location'],
        'capacity': zone['capacity'],
        'schedule': standardSchedule,
        'isActive': campusId == 'ingenierias', // Solo Ingenierías activo por ahora
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      print('  ✅ ${zone['name']} ${campusId == 'ingenierias' ? '(ACTIVA)' : '(INACTIVA)'} creada');
    }
    print('\n✅ Total zonas creadas: ${zones.length}\n');
  }

  /// Crear espacios de estacionamiento en cada zona
  Future<void> seedParkingSpots() async {
    print('🚗 Creando espacios de estacionamiento...\n');

    // ═══════════════════════════════════════════════════════════
    // CAMPUS INGENIERÍAS (ACTIVO - con espacios reales)
    // ═══════════════════════════════════════════════════════════
    await _createSpotsForZone('ing_zone_a', 'A', 50);  // Ingenierías - Zona A
    await _createSpotsForZone('ing_zone_b', 'B', 30);  // Ingenierías - Zona B
    await _createSpotsForZone('ing_zone_c', 'C', 40);  // Ingenierías - Zona C
    
    // ═══════════════════════════════════════════════════════════
    // CAMPUS SOCIALES (INACTIVO - sin espacios por ahora)
    // ═══════════════════════════════════════════════════════════
    // Descomentar cuando se active:
    // await _createSpotsForZone('soc_zone_a', 'D', 40);
    // await _createSpotsForZone('soc_zone_b', 'E', 25);
    // await _createSpotsForZone('soc_zone_c', 'F', 30);
    
    // ═══════════════════════════════════════════════════════════
    // CAMPUS BIOMÉDICAS (INACTIVO - sin espacios por ahora)
    // ═══════════════════════════════════════════════════════════
    // Descomentar cuando se active:
    // await _createSpotsForZone('bio_zone_a', 'G', 35);
    // await _createSpotsForZone('bio_zone_b', 'H', 20);
    // await _createSpotsForZone('bio_zone_c', 'I', 45);

    print('\n✅ Total espacios creados: 120 (solo Campus Ingenierías activo)\n');
    print('💡 Nota: Sociales y Biomédicas no tienen espacios aún (campus inactivos)\n');
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
      await _deleteCollection('campus');           // ← NUEVO
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
