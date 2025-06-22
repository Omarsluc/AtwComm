import 'package:atw_comm/core/routing/routes.dart';
import 'package:atw_comm/features/face_recognition/camera_view.dart';
import 'package:atw_comm/features/home/views/knowledge_contributions_screen.dart';
import 'package:atw_comm/features/staff/views/staff_screen.dart';
import 'package:flutter/material.dart';

import '../../features/home/views/home_screen.dart';
import '../../features/staff/views/add_article_screen.dart';

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
          builder: (_) => KnowledgeContributionScreen(),
        );
      case Routes.cameraScreen:
        return MaterialPageRoute(
          builder: (_) => CameraScreen(),
        );
      case Routes.staffScreen:
        return MaterialPageRoute(
          builder: (_) => StaffScreen(),
        );
      case Routes.addArticleScreen:
        return MaterialPageRoute(
          builder: (_) => AddArticleScreen(),
        );
      default:
        return null;
    }
  }
}
