import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyVehicleScreen extends StatefulWidget {
  const MyVehicleScreen({super.key});

  @override
  State<MyVehicleScreen> createState() => _MyVehicleScreenState();
}

class _MyVehicleScreenState extends State<MyVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  
  String _selectedVehicleType = 'car';
  
  // Lista de vehículos registrados (solo frontend por ahora)
  final List<Map<String, String>> _vehicles = [];

  @override
  void dispose() {
    _plateController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _showAddVehicleDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddVehicleModal(),
    );
  }

  void _addVehicle() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _vehicles.add({
          'plate': _plateController.text.toUpperCase(),
          'brand': _brandController.text,
          'model': _modelController.text,
          'color': _colorController.text,
          'type': _selectedVehicleType,
        });
      });
      
      // Limpiar formulario
      _plateController.clear();
      _brandController.clear();
      _modelController.clear();
      _colorController.clear();
      _selectedVehicleType = 'car';
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('¡Vehículo registrado exitosamente!'),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _deleteVehicle(int index) {
    setState(() {
      _vehicles.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vehículo eliminado'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E1A) : const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8A0000).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: Color(0xFF8A0000),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mis Vehículos',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          '${_vehicles.length} ${_vehicles.length == 1 ? "vehículo registrado" : "vehículos registrados"}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _vehicles.isEmpty
                  ? _buildEmptyState(isDark)
                  : _buildVehicleList(isDark),
            ),
          ],
        ),
      ),
      
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddVehicleDialog,
        backgroundColor: const Color(0xFF8A0000),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Registrar Vehículo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark 
                    ? const Color(0xFF1A1F2E)
                    : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.directions_car_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No tienes vehículos registrados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Registra tu vehículo para poder hacer reservas de estacionamiento',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showAddVehicleDialog,
              icon: const Icon(Icons.add),
              label: const Text('Registrar mi primer vehículo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A0000),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = _vehicles[index];
        return _buildVehicleCard(vehicle, index, isDark);
      },
    );
  }

  Widget _buildVehicleCard(Map<String, String> vehicle, int index, bool isDark) {
    final isMotorcycle = vehicle['type'] == 'motorcycle';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark 
              ? Colors.grey.shade800
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isMotorcycle
                        ? [const Color(0xFFF59E0B), const Color(0xFFD97706)]
                        : [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isMotorcycle ? Icons.two_wheeler : Icons.directions_car,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8A0000).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF8A0000).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        vehicle['plate']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Color(0xFF8A0000),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${vehicle['brand']} ${vehicle['model']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showDeleteConfirmation(index),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Eliminar vehículo',
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.grey.shade900
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Color: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  vehicle['color']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getColorFromName(vehicle['color']!),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('¿Eliminar vehículo?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteVehicle(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    final colors = {
      'Blanco': Colors.white,
      'Negro': Colors.black,
      'Gris': Colors.grey,
      'Rojo': Colors.red,
      'Azul': Colors.blue,
      'Verde': Colors.green,
      'Amarillo': Colors.yellow,
      'Naranja': Colors.orange,
      'Plata': Colors.grey.shade300,
    };
    return colors[colorName] ?? Colors.grey;
  }

  Widget _buildAddVehicleModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 12,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  'Registrar Vehículo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Completa los datos de tu vehículo',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Tipo de vehículo
                const Text(
                  'Tipo de vehículo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildVehicleTypeOption(
                        'car',
                        'Auto',
                        Icons.directions_car,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildVehicleTypeOption(
                        'motorcycle',
                        'Moto',
                        Icons.two_wheeler,
                        isDark,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Placa
                TextFormField(
                  controller: _plateController,
                  decoration: InputDecoration(
                    labelText: 'Placa *',
                    hintText: 'Ej: ABC-123',
                    prefixIcon: const Icon(Icons.pin),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9-]')),
                    LengthLimitingTextInputFormatter(8),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la placa';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Marca
                TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    labelText: 'Marca *',
                    hintText: 'Ej: Toyota, Honda',
                    prefixIcon: const Icon(Icons.directions_car_filled),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la marca';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Modelo
                TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(
                    labelText: 'Modelo *',
                    hintText: 'Ej: Corolla, Civic',
                    prefixIcon: const Icon(Icons.design_services),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el modelo';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Color
                DropdownButtonFormField<String>(
                  value: _colorController.text.isEmpty ? null : _colorController.text,
                  decoration: InputDecoration(
                    labelText: 'Color *',
                    prefixIcon: const Icon(Icons.palette),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    'Blanco',
                    'Negro',
                    'Gris',
                    'Plata',
                    'Rojo',
                    'Azul',
                    'Verde',
                    'Amarillo',
                    'Naranja',
                  ].map((color) {
                    return DropdownMenuItem(
                      value: color,
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _getColorFromName(color),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(color),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _colorController.text = value;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona un color';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _addVehicle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8A0000),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Registrar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleTypeOption(String type, String label, IconData icon, bool isDark) {
    final isSelected = _selectedVehicleType == type;
    
    return InkWell(
      onTap: () => setState(() => _selectedVehicleType = type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8A0000).withValues(alpha: 0.1)
              : (isDark ? Colors.grey.shade900 : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8A0000)
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? const Color(0xFF8A0000) : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF8A0000) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}