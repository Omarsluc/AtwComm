import 'package:atw_comm/features/articles/views/play_podcast_screen.dart';
import 'package:atw_comm/features/articles/views/articles_categories_screen.dart';
import 'package:atw_comm/features/onboarding/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/routing/app_router.dart';


class MainApp extends StatelessWidget {
  final AppRouter appRouter;

  const MainApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360,820),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          home: OnboardingScreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                titleSpacing: 0,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                elevation: 0,
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
          ),
          // initialRoute: Routes.homeScreen,
          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}