import 'package:blood_pressure/presentation/home/home_page.dart';
import 'package:blood_pressure/presentation/profiles/profile_page.dart';
import 'package:flutter/material.dart';

abstract class AppRouter {
  static const home = '/';
  static const settings = '/settings';
  static const measurment = '/measurment';
  static const analytics = '/analytics';
  static const profile = '/profile';

  static Route? generateRoute(RouteSettings route) {
    switch (route.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return null;
    }
  }
}
