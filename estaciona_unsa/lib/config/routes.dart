import 'package:flutter/material.dart';
import '../screens/auth_wrapper.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/main_nav_screen.dart';
import '../screens/map_screen.dart';
import '../screens/history_screen.dart';
import '../screens/my_vehicle_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const String authWrapper = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String mainNav = '/main';
  static const String map = '/map';
  static const String history = '/history';
  static const String myVehicle = '/my-vehicle';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
    authWrapper: (context) => const AuthWrapper(),
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    mainNav: (context) => const MainNavScreen(),
    map: (context) => const MapScreen(),
    history: (context) => const HistoryScreen(),
    myVehicle: (context) => const MyVehicleScreen(),
    profile: (context) => const ProfileScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case mainNav:
        return MaterialPageRoute(builder: (_) => const MainNavScreen());
      case map:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case myVehicle:
        return MaterialPageRoute(builder: (_) => const MyVehicleScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return null;
    }
  }
}
