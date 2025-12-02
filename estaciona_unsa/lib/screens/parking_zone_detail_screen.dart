import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/parking_spot_model.dart';
import '../providers/parking_provider.dart';
import '../providers/reservation_provider.dart';
import '../widgets/parking/spot_reservation_modal.dart';
import '../config/constants.dart';

class ParkingZoneDetailScreen extends StatefulWidget {
  final String zoneId;
  final String zoneName;

  const ParkingZoneDetailScreen({
    super.key,
    required this.zoneId,
    required this.zoneName,
  });

  @override
  State<ParkingZoneDetailScreen> createState() => _ParkingZoneDetailScreenState();
}

class _ParkingZoneDetailScreenState extends State<ParkingZoneDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSpots();
    });
  }

  Future<void> _loadSpots() async {
    final parkingProvider = context.read<ParkingProvider>();
    await parkingProvider.loadSpotsByZone(widget.zoneId);
  }

  void _showSpotDetails(ParkingSpotModel spot) {
    if (spot.status != AppConstants.statusAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Este espacio está ${spot.status == AppConstants.statusOccupied ? "ocupado" : "en mantenimiento"}'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SpotReservationModal(
        spot: spot,
        zoneName: widget.zoneName,
      ),
    );
  }

  Color _getSpotColor(String status) {
    switch (status) {
      case AppConstants.statusAvailable:
        return const Color(0xFF10B981); // Verde más suave
      case AppConstants.statusOccupied:
        return const Color(0xFFEF4444); // Rojo más suave
      case AppConstants.statusReserved:
        return const Color(0xFFF59E0B); // Naranja más suave
      case AppConstants.statusMaintenance:
        return const Color(0xFF6B7280); // Gris más suave
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getSpotIcon(String type) {
    switch (type) {
      case 'regular':
        return Icons.directions_car;
      case 'motorcycle':
        return Icons.motorcycle;
      default:
        return Icons.local_parking;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E1A) : const Color(0xFFF5F7FA),
      body: Consumer<ParkingProvider>(
        builder: (context, parkingProvider, child) {
          if (parkingProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final spots = parkingProvider.spots
              .where((spot) => spot.zoneId == widget.zoneId)
              .toList();

          if (spots.isEmpty) {
            return const Center(
              child: Text('No hay espacios disponibles en esta zona'),
            );
          }

          final availableCount = spots.where((s) => s.status == AppConstants.statusAvailable).length;
          final totalCount = spots.length;

          return SafeArea(
            child: Column(
              children: [
                // Custom Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Text(
                              widget.zoneName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatChip('$availableCount Libres', const Color(0xFF10B981), Icons.check_circle),
                          _buildStatChip('${totalCount - availableCount} Ocupados', const Color(0xFFEF4444), Icons.cancel),
                          _buildStatChip('$totalCount Total', const Color(0xFF6B7280), Icons.local_parking),
                        ],
                      ),
                    ],
                  ),
                ),

                // Parking Layout
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadSpots,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Legend
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildLegendItem('Libre', const Color(0xFF10B981)),
                                _buildLegendItem('Ocupado', const Color(0xFFEF4444)),
                                _buildLegendItem('Reservado', const Color(0xFFF59E0B)),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // 3D Parking Layout
                          _build3DParkingLayout(spots, isDark),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3DParkingLayout(List<ParkingSpotModel> spots, bool isDark) {
    // Organizar spots en filas (simulando un estacionamiento real)
    final spotsPerRow = 4;
    final rows = <List<ParkingSpotModel>>[];
    
    for (var i = 0; i < spots.length; i += spotsPerRow) {
      final end = (i + spotsPerRow < spots.length) ? i + spotsPerRow : spots.length;
      rows.add(spots.sublist(i, end));
    }

    return Column(
      children: [
        // Título
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF8A0000),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Vista del Estacionamiento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Filas de estacionamiento
        ...rows.asMap().entries.map((entry) {
          final rowIndex = entry.key;
          final rowSpots = entry.value;
          
          return Column(
            children: [
              // Etiqueta de fila
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Fila ${String.fromCharCode(65 + rowIndex)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Espacios de la fila con perspectiva 3D
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: rowSpots.map((spot) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildParkingSpot3D(spot, isDark),
                  ),
                )).toList(),
              ),
              
              const SizedBox(height: 24),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildParkingSpot3D(ParkingSpotModel spot, bool isDark) {
    final color = _getSpotColor(spot.status);
    final isAvailable = spot.status == AppConstants.statusAvailable;
    
    return GestureDetector(
      onTap: () => _showSpotDetails(spot),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Base del espacio (piso)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.2),
                    color.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
            ),
            
            // Líneas de perspectiva
            CustomPaint(
              size: const Size(double.infinity, 100),
              painter: ParkingLinePainter(color: color.withValues(alpha: 0.3)),
            ),
            
            // Contenido
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getSpotIcon(spot.type),
                    color: color,
                    size: 32,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    spot.spotId.replaceAll('${widget.zoneId}_spot_', ''),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 16,
                    ),
                  ),
                  if (!isAvailable)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        spot.status == AppConstants.statusOccupied ? 'Ocupado' : 'Reservado',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildParkingSpot(ParkingSpotModel spot) {
    final color = _getSpotColor(spot.status);
    final icon = _getSpotIcon(spot.type);
    final isAvailable = spot.status == AppConstants.statusAvailable;

    return InkWell(
      onTap: () => _showSpotDetails(spot),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 4),
            Text(
              spot.spotId,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
            if (!isAvailable)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  spot.status == AppConstants.statusOccupied ? 'Ocupado' : 'Reservado',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter para las líneas de perspectiva del estacionamiento
class ParkingLinePainter extends CustomPainter {
  final Color color;

  ParkingLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Líneas diagonales para dar efecto 3D
    final path = Path();
    
    // Línea superior izquierda a inferior derecha
    path.moveTo(size.width * 0.2, 0);
    path.lineTo(size.width * 0.8, size.height);
    
    // Línea superior derecha a inferior izquierda
    path.moveTo(size.width * 0.8, 0);
    path.lineTo(size.width * 0.2, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
