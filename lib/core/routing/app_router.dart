import 'package:atw_comm/core/routing/routes.dart';
import 'package:atw_comm/features/face_recognition/camera_view.dart';
import 'package:atw_comm/features/staff/views/staff_screen.dart';
import 'package:flutter/material.dart';
import '../../features/articles/views/all_articles_screen.dart';
import '../../features/articles/views/article_details_screen.dart';
import '../../features/staff/views/add_article_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
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
      case Routes.allArticlesScreen:
        return MaterialPageRoute(
          builder: (_) => AllArticlesScreen(),
        );
      case Routes.articleDetailsScreen:
        return MaterialPageRoute(
          builder: (_) => ArticleDetailsScreen(),
        );
      default:
        return null;
    }
  }
}
