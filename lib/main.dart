import 'package:atw_comm/core/helpers/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bloc_observer.dart';
import 'core/routing/app_router.dart';
import 'core/service/speachToText.dart';
import 'core/service/textToSpeach.dart';
import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Supabase.initialize(
    url: SharredKeys.supabaseUrl,
    anonKey: SharredKeys.supabaseAnonKey,
  );
  await TextToSpeechService.initTTS();
  SpeechToTextService.initSpeech();

  Bloc.observer = MyBlocObserver();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: MainApp(
      appRouter: AppRouter(),
    ),
  ));
}