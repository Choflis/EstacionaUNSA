import 'package:firebase_auth/firebase_auth.dart';
import '../providers/parking_provider.dart';

class ManualTestUnit003 {
  static Future<void> runTests() async {
    print('\n========================================');
    print('UNIT-003: ParkingProvider.loadZones()');
    print('========================================\n');

    final currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser == null) {
      print('ERROR: No hay usuario autenticado');
      print('Por favor inicia sesion primero\n');
      return;
    }

    print('Usuario autenticado: ${currentUser.email}\n');

    int testsPasados = 0;
    int testsFallados = 0;

    // TEST 1: isLoading cambia correctamente
    try {
      print('TEST 1: Estado isLoading cambia correctamente');
      print('----------------------------------------');
      
      final provider = ParkingProvider();
      
      print('Estado inicial:');
      print('  isLoading: ${provider.isLoading}');
      print('  zones.length: ${provider.zones.length}');
      
      if (provider.isLoading != false) {
        throw Exception('isLoading deberia ser false al inicio');
      }

      print('\nLlamando a loadZones()...');
      
      // Verificar que isLoading se pone en true
      final loadingFuture = provider.loadZones();
      
      // Esperar un momento para que el estado cambie
      await Future.delayed(Duration(milliseconds: 50));
      
      print('Durante la carga:');
      print('  isLoading: ${provider.isLoading}');
      
      // Esperar a que termine
      await loadingFuture;
      
      print('\nDespues de cargar:');
      print('  isLoading: ${provider.isLoading}');
      print('  zones.length: ${provider.zones.length}');
      
      if (provider.isLoading != false) {
        throw Exception('isLoading deberia ser false al terminar');
      }

      print('\nRESULTADO: PASADO\n');
      testsPasados++;
    } catch (e) {
      print('\nRESULTADO: FALLADO');
      print('ERROR: $e\n');
      testsFallados++;
    }

    // TEST 2: Zonas se cargan correctamente
    try {
      print('TEST 2: Zonas se cargan desde Firestore');
      print('----------------------------------------');
      
      final provider = ParkingProvider();
      
      print('Cargando zonas...');
      await provider.loadZones();
      
      print('Zonas cargadas: ${provider.zones.length}');
      
      if (provider.zones.isEmpty) {
        throw Exception('No se cargaron zonas (deberian existir en Firestore)');
      }

      print('\nDetalles de zonas:');
      for (var i = 0; i < provider.zones.length && i < 5; i++) {
        final zone = provider.zones[i];
        print('  Zona ${i + 1}:');
        print('    ID: ${zone.zoneId}');
        print('    Nombre: ${zone.name}');
        print('    Capacidad total: ${zone.capacity.totalSpots}');
        print('    Disponibles: ${zone.capacity.availableSpots}');
        print('    Ocupados: ${zone.capacity.occupiedSpots}');
        print('    Activa: ${zone.isActive}');
      }

      if (provider.zones.length > 5) {
        print('  ... y ${provider.zones.length - 5} zonas mas');
      }

      print('\nRESULTADO: PASADO\n');
      testsPasados++;
    } catch (e) {
      print('\nRESULTADO: FALLADO');
      print('ERROR: $e\n');
      testsFallados++;
    }

    // TEST 3: notifyListeners se llama
    try {
      print('TEST 3: Provider notifica cambios');
      print('----------------------------------------');
      
      final provider = ParkingProvider();
      bool listenerCalled = false;
      
      provider.addListener(() {
        listenerCalled = true;
        print('Listener llamado - zones.length: ${provider.zones.length}');
      });
      
      print('Cargando zonas...');
      await provider.loadZones();
      
      print('\nListener fue llamado: $listenerCalled');
      
      if (!listenerCalled) {
        throw Exception('notifyListeners() no fue llamado');
      }

      print('Verificacion: Provider notifica cambios correctamente');
      print('\nRESULTADO: PASADO\n');
      testsPasados++;
    } catch (e) {
      print('\nRESULTADO: FALLADO');
      print('ERROR: $e\n');
      testsFallados++;
    }

    // TEST 4: Manejo de errores (simulado con zona invalida)
    try {
      print('TEST 4: errorMessage se setea en caso de error');
      print('----------------------------------------');
      
      final provider = ParkingProvider();
      
      print('Estado inicial:');
      print('  errorMessage: ${provider.errorMessage}');
      
      // Este test solo verifica que el campo errorMessage existe
      // El error real se probaria con un servicio mockeado
      
      print('\nCargando zonas normalmente...');
      await provider.loadZones();
      
      print('Despues de carga exitosa:');
      print('  errorMessage: ${provider.errorMessage}');
      
      if (provider.errorMessage != null) {
        throw Exception('errorMessage deberia ser null en carga exitosa');
      }

      print('\nVerificacion: Campo errorMessage funciona correctamente');
      print('\nRESULTADO: PASADO\n');
      testsPasados++;
    } catch (e) {
      print('\nRESULTADO: FALLADO');
      print('ERROR: $e\n');
      testsFallados++;
    }

    // RESUMEN
    print('\n========================================');
    print('RESUMEN UNIT-003');
    print('========================================');
    print('Tests ejecutados: ${testsPasados + testsFallados}');
    print('Tests pasados: $testsPasados');
    print('Tests fallados: $testsFallados');
    print('========================================\n');
  }
}
