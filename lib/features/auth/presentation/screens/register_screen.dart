import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/di_container.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/bloc_status.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../bloc/auth_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController(text: '+998 ');
  final _emailCtrl = TextEditingController();
  final _loginCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool _agreedToTerms = false;

  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push(Routes.termsOfService);
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push(Routes.privacyPolicy);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _loginCtrl.dispose();
    _passwordCtrl.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final login = _loginCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || login.isEmpty || password.isEmpty || phone.length < 6) {
      return;
    }

    FocusScope.of(context).unfocus();

    final nameParts = name.split(RegExp(r'\s+'));
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    context.read<AuthCubit>().register(
          firstName: firstName,
          lastName: lastName,
          phone: UzPhoneFormatter.toApiFormat(phone),
          email: email,
          username: login,
          password: password,
        );
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(PhosphorIconsRegular.arrowLeft),
                      onPressed: () => context.pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    'Join thousands of SAT students',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 28),
                const _FieldLabel('Name and Surname'),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameCtrl,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Alisher Hakimov',
                    prefixIcon: Icon(PhosphorIconsRegular.user, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                const _FieldLabel('Phone Number'),
                const SizedBox(height: 6),
                TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [UzPhoneFormatter()],
                  decoration: const InputDecoration(
                    hintText: '+998 90 123-45-67',
                    prefixIcon: Icon(PhosphorIconsRegular.phone, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                const _FieldLabel('Email Address'),
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
                const _FieldLabel('Username'),
                const SizedBox(height: 6),
                TextField(
                  controller: _loginCtrl,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_.]')),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'alisher98',
                    prefixIcon: Icon(PhosphorIconsRegular.at, size: 20),
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
                    hintText: 'Min. 8 characters',
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
                const SizedBox(height: 20),
                _TermsRow(
                  value: _agreedToTerms,
                  onChanged: (v) => setState(() => _agreedToTerms = v),
                  termsRecognizer: _termsRecognizer,
                  privacyRecognizer: _privacyRecognizer,
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) => PrimaryButton(
                    text: 'Sign Up',
                    isLoading: state.status.isLoading,
                    width: double.infinity,
                    onPressed: _submit,
                  ),
                ),
                const SizedBox(height: 24),
                const _OrDivider(),
                const SizedBox(height: 20),
                _GoogleButton(onTap: _submit),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Text(
                        'Sign In',
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

class _TermsRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final TapGestureRecognizer termsRecognizer;
  final TapGestureRecognizer privacyRecognizer;

  const _TermsRow({
    required this.value,
    required this.onChanged,
    required this.termsRecognizer,
    required this.privacyRecognizer,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Use',
                      recognizer: termsRecognizer,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      recognizer: privacyRecognizer,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
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

class _GoogleButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GoogleButton({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderMedium),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
              ),
              const SizedBox(width: 12),
              const Text(
                'Sign up with Google',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );
}
