import 'package:flutter/material.dart';
import 'package:estaciona_unsa/widgets/parking/parking_card.dart';

class ParkingListScreen extends StatelessWidget {
  const ParkingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estacionamientos Disponibles'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ParkingCard(
            name: 'Zona A - UNSA Central',
            location: 'Av. Venezuela 123',
            available: true,
          ),
          ParkingCard(
            name: 'Zona B - Ingenierías',
            location: 'Calle San José 215',
            available: false,
          ),
          ParkingCard(
            name: 'Zona C - Sociales',
            location: 'Av. Independencia 101',
            available: true,
          ),
          ParkingCard(
            name: 'Zona D - Medicina',
            location: 'Calle Los Robles 512',
            available: true,
          ),
        ],
      ),
    );
  }
}
