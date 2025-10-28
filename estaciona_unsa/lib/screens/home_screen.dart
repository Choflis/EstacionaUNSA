import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:estaciona_unsa/widgets/common/custom_button.dart';
import 'package:estaciona_unsa/widgets/common/custom_text_field.dart';
import 'package:estaciona_unsa/widgets/common/loading_indicator.dart';
import 'package:estaciona_unsa/widgets/parking/parking_card.dart';
import 'package:estaciona_unsa/widgets/parking/parking_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _noteController = TextEditingController();
  bool _isLoading = false;
  bool _isSaving = false;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    // Después de cerrar sesión, volver al login
    if (!mounted) return;
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    // Simular guardado
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Nota guardada!')),
    );
    setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
          IconButton(
            icon: const Icon(Icons.view_list),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ParkingListScreen()),
          );
        },
      ),
    ],
      ),
      body: _isLoading 
        ? const LoadingIndicator()
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Información del usuario
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.verified_user, size: 72, color: Colors.green),
                        const SizedBox(height: 16),
                        Text(
                          user != null ? user.displayName ?? user.email ?? 'Usuario' : 'No autenticado',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(user?.email ?? ''),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Sección de prueba de componentes
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Prueba de Componentes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Escribe una nota',
                          controller: _noteController,
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'Guardar Nota',
                          isLoading: _isSaving,
                          onPressed: _handleSave,
                        ),
                        
                        if (_isSaving) ...[
                          const SizedBox(height: 16),
                        
                          const Center(
                            child: Text(
                              'Procesando...',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
