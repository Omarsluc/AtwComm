import 'package:atw_comm/core/routing/routes.dart';
import 'package:atw_comm/features/auth/logic/login_cubit.dart';
import 'package:atw_comm/features/auth/views/login_screen.dart';
import 'package:atw_comm/features/face_recognition/camera_view.dart';
import 'package:atw_comm/features/staff/views/staff_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/articles/views/all_articles_screen.dart';
import '../../features/articles/views/articles_categories_screen.dart';
import '../../features/articles/views/create_ai_podcast.dart';
import '../../features/staff/views/add_article_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
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
      // case Routes.articleDetailsScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => PlayPodcastScreen(podcast: null,),
      //   );
      case Routes.articlesCategoriesScreen:
        return MaterialPageRoute(
          builder: (_) => ArticlesCategoriesScreen(),
        );
      case Routes.createAIPodcastScreen:
        return MaterialPageRoute(
          builder: (_) => CreateAIPodcastScreen(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LoginCubit(),
            child: const LoginScreen(),
          ),
        );
      // case Routes.articlesScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => ArticlesScreen(),
      //   );
      default:
        return null;
    }
  }
}
