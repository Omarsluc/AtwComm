import 'dart:async';

import 'package:atw_comm/features/staff/views/staff_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/consts.dart';
import '../../onboarding/views/onboarding_screen.dart';
import '../utils/display_name.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Session? _session;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    final auth = Supabase.instance.client.auth;
    _session = auth.currentSession;
    final user = _session?.user;
    if (user != null) {
      userNameIdentified = extractDisplayName(user);
    }

    _authSubscription = auth.onAuthStateChange.listen((state) {
      setState(() {
        _session = state.session;
      });

      final authUser = state.session?.user;
      if (authUser != null) {
        userNameIdentified = extractDisplayName(authUser);
      } else {
        userNameIdentified = null;
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_session?.user != null) {
      return const StaffScreen();
    }
    return const OnboardingScreen();
  }
}

