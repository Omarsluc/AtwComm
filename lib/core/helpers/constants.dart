import 'package:flutter/material.dart';

bool isLogin = false;

class SharredKeys {
  static const String userToken = 'userToken';
  static const String rememberMeKey = 'rememberMeKey';
  static const String userName = 'UserName';
  static const String userImage = '';

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
