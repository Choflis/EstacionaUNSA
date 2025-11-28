import 'package:flutter/material.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navegación interna removida: la barra inferior ahora la gestiona MainNavScreen

  void _navigateToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF101922).withValues(alpha: 0.8) : const Color(0xFFF6F7F8).withValues(alpha: 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.directions_car, color: Color(0xFF8A0000), size: 30),
                    const SizedBox(width: 8),
                    const Text(
                      'UNSA Parking',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.account_circle),
                      onPressed: _navigateToProfile,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen General
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen General',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Estado rápido de todas las áreas',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Scroll horizontal de zonas
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildZoneCard(
                          'Ingenierías',
                          'Mayormente Disponible',
                          23,
                          245,
                          const Color(0xFF28A745),
                          Icons.check_circle,
                        ),
                        const SizedBox(width: 12),
                        _buildZoneCard(
                          'Sociales',
                          'Plazas Limitadas',
                          8,
                          150,
                          const Color(0xFFFFC107),
                          Icons.error,
                        ),
                        const SizedBox(width: 12),
                        _buildZoneCard(
                          'Biomédicas',
                          'Completo',
                          0,
                          100,
                          const Color(0xFFDC3545),
                          Icons.cancel,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Área de Ingenierías
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Área de Ingenierías',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Disponibilidad en tiempo real',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Lista de estacionamientos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildParkingCard(
                          'Estacionamiento Paucarpata',
                          75,
                          23,
                          const Color(0xFF28A745),
                          'Disponible',
                          Icons.check_circle,
                        ),
                        const SizedBox(height: 12),
                        _buildParkingCard(
                          'Estacionamiento Av. Independencia',
                          120,
                          8,
                          const Color(0xFFFFC107),
                          'Plazas limitadas',
                          Icons.error,
                        ),
                        const SizedBox(height: 12),
                        _buildParkingCard(
                          'Estacionamiento Av. Venezuela',
                          50,
                          0,
                          const Color(0xFFDC3545),
                          'Completo',
                          Icons.cancel,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // La barra inferior la maneja `MainNavScreen`. No se incluye aquí para evitar duplicados.
    );
  }

  Widget _buildZoneCard(String title, String status, int available, int total, Color statusColor, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C2A38) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: statusColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(fontSize: 13, color: statusColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            children: [
              Icon(icon, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(
                '$available/$total Libres',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParkingCard(String name, int total, int available, Color statusColor, String statusText, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = (available / total * 100).clamp(0, 100);
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C2A38) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                children: [
                  Icon(icon, size: 16, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    statusText,
                    style: TextStyle(fontSize: 13, color: statusColor, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Total: $total plazas',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Disponibles', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text(
                '$available / $total',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
  // Nota: no hay método _buildNavItem porque la navegación inferior es responsabilidad de MainNavScreen.
}
