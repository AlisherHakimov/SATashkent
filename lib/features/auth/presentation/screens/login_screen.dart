import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/di_container.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/bloc_status.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../bloc/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    if (email.isEmpty || password.isEmpty) return;
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().login(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == BlocStatus.success) {
          sl<AppRouter>().router.go(Routes.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.gradientStart, AppColors.gradientEnd],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(Icons.school_rounded, size: 44, color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'SATashkent',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Your path to 1600',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sign in to your account',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 28),
                const _FieldLabel('Email address'),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'you@example.com',
                    prefixIcon: Icon(PhosphorIconsRegular.envelope, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                const _FieldLabel('Password'),
                const SizedBox(height: 6),
                TextField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    prefixIcon: const Icon(PhosphorIconsRegular.lock, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? PhosphorIconsRegular.eye : PhosphorIconsRegular.eyeSlash,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(fontSize: 13, color: AppColors.primaryBlue),
                    ),
                  ),
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state.status == BlocStatus.error && state.errorMessage != null) {
                      return Column(
                        children: [
                          _AuthErrorBanner(message: state.errorMessage!),
                          const SizedBox(height: 12),
                        ],
                      );
                    }
                    return const SizedBox(height: 4);
                  },
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) => PrimaryButton(
                    text: 'Sign In',
                    isLoading: state.status.isLoading,
                    width: double.infinity,
                    onPressed: _submit,
                  ),
                ),
                const SizedBox(height: 24),
                const _OrDivider(),
                const SizedBox(height: 20),
                _SocialButton(
                  label: 'Continue with Google',
                  icon: _GoogleIcon(),
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _SocialButton(
                  label: 'Continue with Telegram',
                  icon: const Icon(PhosphorIconsFill.telegramLogo, color: Colors.white, size: 26),
                  color: const Color(0xFF2AABEE),
                  shadowColor: const Color(0xFF2AABEE),
                  textColor: Colors.white,
                  onTap: () {},
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => context.push(Routes.register),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      );
}

class _AuthErrorBanner extends StatelessWidget {
  final String message;
  const _AuthErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(PhosphorIconsFill.warning, color: AppColors.error, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ),
          ],
        ),
      );
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) => const Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('or', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          ),
          Expanded(child: Divider()),
        ],
      );
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final Color color;
  final Color? shadowColor;
  final Color textColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    this.color = Colors.white,
    this.shadowColor,
    this.textColor = AppColors.textPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
            border: color == Colors.white ? Border.all(color: AppColors.borderMedium) : null,
            boxShadow: [
              BoxShadow(
                color: (shadowColor ?? Colors.black).withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
              ),
            ],
          ),
        ),
      );
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF4285F4),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4285F4).withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'G',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
      );
}
