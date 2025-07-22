import 'package:flutter/material.dart';

bool isLogin = false;

class SharredKeys {
  static const String userToken = 'userToken';
  static const String rememberMeKey = 'rememberMeKey';
  static const String userName = 'UserName';
  static const String userImage = '';

  static const String supabaseUrl = 'https://bjoyuyovngiqfbvuvrbg.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJqb3l1eW92bmdpcWZidnV2cmJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEzODA3MDQsImV4cCI6MjA2Njk1NjcwNH0.wbnHhDZfddB9_2NZTVG_TZS1N816yIo-fSF0Sx3B_yw';

  static const String elevenLabsKey = 'sk_e45412fd8ac001e571dbd360c9105306b8d18b6334497ee7';

  static const String selectedLang = 'English';

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
