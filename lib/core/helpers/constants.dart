import 'package:flutter/material.dart';

bool isLogin = false;

class SharredKeys {
  static const String userToken = 'userToken';
  static const String rememberMeKey = 'rememberMeKey';
  static const String userName = 'UserName';
  static const String userImage = '';

  static const String supabaseUrl = 'https://bjoyuyovngiqfbvuvrbg.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJqb3l1eW92bmdpcWZidnV2cmJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEzODA3MDQsImV4cCI6MjA2Njk1NjcwNH0.wbnHhDZfddB9_2NZTVG_TZS1N816yIo-fSF0Sx3B_yw';

  static const String elevenLabsKey = 'sk_8d8a0934a19dad3b2f60c07029597978268b7ea555a89885';

  static const String selectedLang = 'English';

  static const String payPalClientId =
      'AY0wWXVM2zfiI5z_dwYqLLtYhoR-HOAFKX4d8025qQTLVX9PbgnsJVOdUo_AksS0BUkV5y_tGdBSBPGP';

  static const String payPalSecertKey =
      'EPmx5EMDEpC3JeIfikhCBX6vrYcmyFaptcRyAJE50ibNdw10UZa8JiN2kRn4mC4vL3vsnG6F1ScwoGYY';

  static List<Locale> supportedLocales = const [
    Locale('en'),
    Locale('ar'),
    Locale('it'),
    Locale('fr'),
    Locale('de'),
    Locale('ru'),
    Locale('pt'),
    Locale('es')
  ];

  static Locale defaultLang = const Locale('en');
}
