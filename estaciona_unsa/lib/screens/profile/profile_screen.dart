import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _signOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      body: CustomScrollView(
        slivers: [
          // App Bar con imagen de perfil
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF8A0000),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF8A0000), Color(0xFFB71C1C)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: user?.photoURL != null 
                          ? NetworkImage(user!.photoURL!)
                          : null,
                        child: user?.photoURL == null
                          ? Text(
                              user?.displayName?.substring(0, 1).toUpperCase() ?? 
                              user?.email?.substring(0, 1).toUpperCase() ?? 
                              'U',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8A0000),
                              ),
                            )
                          : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.displayName ?? 'Usuario',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información Personal
                  _buildSectionTitle('Información Personal'),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    title: 'Nombre Completo',
                    subtitle: user?.displayName ?? 'No disponible',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    title: 'Correo Electrónico',
                    subtitle: user?.email ?? 'No disponible',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoCard(
                    icon: Icons.verified_user_outlined,
                    title: 'Estado de Verificación',
                    subtitle: user?.emailVerified == true ? 'Verificado' : 'No verificado',
                    trailing: user?.emailVerified == true
                      ? const Icon(Icons.check_circle, color: Color(0xFF28A745), size: 20)
                      : const Icon(Icons.warning, color: Color(0xFFFFC107), size: 20),
                  ),

                  const SizedBox(height: 24),

                  // Estadísticas
                  _buildSectionTitle('Estadísticas'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('0', 'Reservas\nActivas', Icons.bookmark_outline),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('0', 'Reservas\nTotales', Icons.history),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('0', 'Horas\nEstacionado', Icons.access_time),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('\$0', 'Total\nGastado', Icons.attach_money),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Opciones
                  _buildSectionTitle('Configuración'),
                  const SizedBox(height: 12),
                  _buildOptionCard(
                    icon: Icons.directions_car_outlined,
                    title: 'Mis Vehículos',
                    subtitle: 'Administra tus vehículos',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Próximamente: Mis Vehículos')),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildOptionCard(
                    icon: Icons.credit_card_outlined,
                    title: 'Métodos de Pago',
                    subtitle: 'Gestiona tus tarjetas',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Próximamente: Métodos de Pago')),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildOptionCard(
                    icon: Icons.history,
                    title: 'Historial de Reservas',
                    subtitle: 'Ver todas tus reservas',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Próximamente: Historial')),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildOptionCard(
                    icon: Icons.notifications_outlined,
                    title: 'Notificaciones',
                    subtitle: 'Configura tus alertas',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Próximamente: Notificaciones')),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Botón de Cerrar Sesión
                  _buildLogoutButton(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C2A38) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF8A0000).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF8A0000), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C2A38) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF8A0000), size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8A0000),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C2A38) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF8A0000).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF8A0000), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _signOut,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout),
            SizedBox(width: 8),
            Text(
              'Cerrar Sesión',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
