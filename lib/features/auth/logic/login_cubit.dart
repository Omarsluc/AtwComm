import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/consts.dart';
import '../utils/display_name.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({SupabaseClient? client})
      : _supabase = client ?? Supabase.instance.client,
        super(const LoginState.initial());

  final SupabaseClient _supabase;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (normalizedEmail.isEmpty || trimmedPassword.isEmpty) {
      emit(LoginState.failure('Email and password are required.'));
      return;
    }

    emit(const LoginState.loading());
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: normalizedEmail,
        password: trimmedPassword,
      );

      final user = response.user;
      if (user != null) {
        userNameIdentified = extractDisplayName(user);
      }

      emit(const LoginState.success());
    } on AuthException catch (error) {
      emit(LoginState.failure(error.message));
    } catch (error) {
      emit(const LoginState.failure(
        'Something went wrong while signing in. Please try again.',
      ));
    }
  }

}

