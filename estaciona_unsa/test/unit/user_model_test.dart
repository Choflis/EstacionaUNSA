import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estaciona_unsa/models/user_model.dart';

void main() {
  group('UserModel - Serialización', () {
    late UserModel testUser;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime(2024, 12, 1, 10, 30);
      testUser = UserModel(
        uid: 'test_uid_123',
        email: 'fernando.test@unsa.edu.pe',
        displayName: 'Fernando Test',
        role: 'user',
        vehicles: [
          VehicleInfo(
            licensePlate: 'ABC-123',
            brand: 'Toyota',
            model: 'Corolla',
            color: 'Azul',
            isPrimary: true,
          ),
        ],
        stats: UserStats(
          totalReservations: 5,
          completedReservations: 4,
          cancelledReservations: 1,
          noShowCount: 0,
        ),
        createdAt: testDate,
        updatedAt: testDate,
        phoneNumber: '959123456',
        photoURL: 'https://example.com/photo.jpg',
        isActive: true,
      );
    });

    test('TEST 1: toMap() genera estructura correcta', () {
      print('\n========================================');
      print('🧪 TEST 1: toMap() estructura correcta');
      print('========================================');

      final map = testUser.toMap();

      print('✅ toMap() ejecutado exitosamente');
      print('\n📋 Map generado:');
      print('  email: ${map['email']}');
      print('  displayName: ${map['displayName']}');
      print('  role: ${map['role']}');
      print('  vehicles: ${map['vehicles']}');
      print('  stats: ${map['stats']}');
      print('  phoneNumber: ${map['phoneNumber']}');
      print('  photoURL: ${map['photoURL']}');
      print('  isActive: ${map['isActive']}');

      expect(map['email'], 'fernando.test@unsa.edu.pe');
      expect(map['displayName'], 'Fernando Test');
      expect(map['role'], 'user');
      expect(map['phoneNumber'], '959123456');
      expect(map['isActive'], true);
      expect(map['vehicles'], isA<List>());
      expect((map['vehicles'] as List).length, 1);
      expect(map['stats'], isA<Map>());
      expect(map['createdAt'], isA<Timestamp>());

      print('✅ Todas las validaciones pasadas\n');
    });

    test('TEST 2: fromMap() reconstruye objeto correctamente', () {
      print('\n========================================');
      print('🧪 TEST 2: fromMap() reconstruye objeto');
      print('========================================');

      final map = {
        'email': 'test@unsa.edu.pe',
        'displayName': 'Test User',
        'role': 'admin',
        'vehicles': [
          {
            'licensePlate': 'XYZ-789',
            'brand': 'Honda',
            'model': 'Civic',
            'color': 'Rojo',
            'isPrimary': true,
          }
        ],
        'stats': {
          'totalReservations': 10,
          'completedReservations': 8,
          'cancelledReservations': 2,
          'noShowCount': 0,
          'isBanned': false,
        },
        'createdAt': Timestamp.fromDate(testDate),
        'updatedAt': Timestamp.fromDate(testDate),
        'phoneNumber': '987654321',
        'photoURL': 'https://test.com/img.jpg',
        'isActive': true,
      };

      print('📥 Reconstruyendo objeto desde Map...');
      final user = UserModel.fromMap(map, 'reconstructed_uid');

      print('✅ fromMap() ejecutado exitosamente');
      print('\n📋 Objeto reconstruido:');
      print('  uid: ${user.uid}');
      print('  email: ${user.email}');
      print('  displayName: ${user.displayName}');
      print('  role: ${user.role}');
      print('  vehicles: ${user.vehicles.length} vehículo(s)');
      print('  stats.total: ${user.stats.totalReservations}');
      print('  phoneNumber: ${user.phoneNumber}');
      print('  isActive: ${user.isActive}');

      expect(user.uid, 'reconstructed_uid');
      expect(user.email, 'test@unsa.edu.pe');
      expect(user.displayName, 'Test User');
      expect(user.role, 'admin');
      expect(user.vehicles.length, 1);
      expect(user.vehicles.first.licensePlate, 'XYZ-789');
      expect(user.stats.totalReservations, 10);
      expect(user.phoneNumber, '987654321');
      expect(user.isActive, true);

      print('✅ Todas las validaciones pasadas\n');
    });

    test('TEST 3: Round-trip (toMap → fromMap) preserva datos', () {
      print('\n========================================');
      print('🧪 TEST 3: Round-trip preserva datos');
      print('========================================');

      print('📤 Paso 1: Convertir objeto original a Map');
      final map = testUser.toMap();
      
      print('📥 Paso 2: Reconstruir objeto desde Map');
      final reconstructed = UserModel.fromMap(map, testUser.uid);

      print('🔍 Paso 3: Comparar valores...');
      print('\n📊 Comparación:');
      print('  uid: ${testUser.uid} == ${reconstructed.uid}');
      print('  email: ${testUser.email} == ${reconstructed.email}');
      print('  displayName: ${testUser.displayName} == ${reconstructed.displayName}');
      print('  role: ${testUser.role} == ${reconstructed.role}');
      print('  vehicles: ${testUser.vehicles.length} == ${reconstructed.vehicles.length}');
      print('  phoneNumber: ${testUser.phoneNumber} == ${reconstructed.phoneNumber}');

      expect(reconstructed.uid, testUser.uid);
      expect(reconstructed.email, testUser.email);
      expect(reconstructed.displayName, testUser.displayName);
      expect(reconstructed.role, testUser.role);
      expect(reconstructed.vehicles.length, testUser.vehicles.length);
      expect(reconstructed.vehicles.first.licensePlate,
          testUser.vehicles.first.licensePlate);
      expect(reconstructed.stats.totalReservations,
          testUser.stats.totalReservations);
      expect(reconstructed.phoneNumber, testUser.phoneNumber);
      expect(reconstructed.photoURL, testUser.photoURL);
      expect(reconstructed.isActive, testUser.isActive);

      print('✅ Round-trip exitoso: Todos los datos preservados\n');
    });
  });

  print('\n========================================');
  print('✅ TODOS LOS TESTS COMPLETADOS');
  print('========================================\n');
}
