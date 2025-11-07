import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'history_screen.dart';
import 'my_vehicle_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;
  static const List<Widget> _pages = [
    HomeScreen(), // Disponibilidad
    MapScreen(),
    HistoryScreen(),
    MyVehicleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Disponibilidad'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Mis Vehículos'),
        ],
      ),
    );
  }
}