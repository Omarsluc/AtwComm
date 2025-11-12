import 'package:atw_comm/core/helpers/extention.dart';
import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/theming/style.dart';
import 'package:atw_comm/core/widgets/app_button.dart';
import 'package:atw_comm/features/auth/logic/login_cubit.dart';
import 'package:atw_comm/features/auth/logic/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/routing/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleLogin(BuildContext context, LoginState state) {
    if (state.isFailure && state.errorMessage != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.redAccent,
          ),
        );
    }

    if (state.isSuccess) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      context.pushNamed(
        Routes.staffScreen,
        // predicate: (route) => false,
      );
    }
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorsManager.mainColor,
              ColorsManager.mainBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: _handleLogin,
            builder: (context, state) {
              final isLoading = state.isLoading;
              return Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Back',
                          style: TextStyles.font16WhiteMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 32.h,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back',
                                style: TextStyles.font24BlueBold.copyWith(
                                  color: ColorsManager.mainColor,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Log in using your staff credentials to manage articles and podcasts.',
                                style: TextStyles.font13GrayRegular.copyWith(
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 32.h),
                              Text(
                                'Email',
                                style: TextStyles.font13DarkBlueMedium,
                              ),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.username],
                                validator: (value) {
                                  final email = value?.trim() ?? '';
                                  if (email.isEmpty) {
                                    return 'Please enter your email address.';
                                  }
                                  final emailRegExp = RegExp(
                                      r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (!emailRegExp.hasMatch(email)) {
                                    return 'Please enter a valid email address.';
                                  }
                                  return null;
                                },
                                decoration: _inputDecoration(
                                  hint: 'name@company.com',
                                  icon: Icons.email_outlined,
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                'Password',
                                style: TextStyles.font13DarkBlueMedium,
                              ),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                autofillHints: const [AutofillHints.password],
                                validator: (value) {
                                  final password = value ?? '';
                                  if (password.isEmpty) {
                                    return 'Please enter your password.';
                                  }
                                  if (password.length < 6) {
                                    return 'Password must be at least 6 characters.';
                                  }
                                  return null;
                                },
                                decoration: _inputDecoration(
                                  hint: '********',
                                  icon: Icons.lock_outline,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: _togglePasswordVisibility,
                                  ),
                                ),
                              ),
                              SizedBox(height: 34.h),
                              AppButton(
                                onPressed: () => _onSubmit(context),
                                myText: 'Log in',
                                isLoading: isLoading,
                                width: double.infinity,
                              ),
                              SizedBox(height: 16.h),
                              AppButton(
                                onPressed: isLoading
                                    ? null
                                    : () => context.pushNamed(
                                          Routes.cameraScreen,
                                        ),
                                myText: 'Use Face ID instead',
                                isSecondary: true,
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: ColorsManager.mainColor,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: ColorsManager.lightBlue,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: ColorsManager.mainColor,
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
    );
  }
}

