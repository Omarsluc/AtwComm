import 'package:atw_comm/core/helpers/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bloc_observer.dart';
import 'core/routing/app_router.dart';
import 'core/service/textToSpeach.dart';
import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Supabase.initialize(
    url: SharredKeys.supabaseUrl,
    anonKey: SharredKeys.supabaseAnonKey,
  );
  await TextToSpeechService.initTTS();
  Bloc.observer = MyBlocObserver();

  // final response = await Supabase.instance.client
  //     .from('api_keys')
  //     .select('key_value')
  //     .eq('key_name', 'elevenlabs')
  //     .maybeSingle();
  //
  // if (response == null) {
  //   debugPrint("API key not found in Supabase.");
  // } else {
  //   final apiKey = response['key_value'];
  //   SharredKeys.elevenLabsKey = apiKey;
  //   debugPrint("API key found in Supabase: $apiKey");
  //
  //   // debugPrint("API key: $apiKey");
  // }

  runApp(MainApp(
      appRouter: AppRouter(),
    ),
  );
}