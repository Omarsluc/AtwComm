import 'package:atw_comm/core/routing/routes.dart';
import 'package:atw_comm/features/home/views/community_screen.dart';
import 'package:atw_comm/features/home/views/staff_screen.dart';
import 'package:flutter/material.dart';

import '../../features/home/views/home_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case Routes.commScreen:
        return MaterialPageRoute(
          builder: (_) => CommunityScreen(),
        );
      case Routes.staffScreen:
        return MaterialPageRoute(
          builder: (_) => StaffScreen(),
        );
      default:
        return null;
    }
  }
}
