import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routing/app_router.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authControllerState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stack) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل تسجيل الدخول: $error'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.p48),
              const Text(
                'مرحباً بك مجدداً! 👋',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: AppSizes.p8),
              const Text(
                'سجل دخولك لتجربة تسوق فريدة وفخمة.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: AppSizes.p48),

              _buildLabel('البريد الإلكتروني'),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.start, 
                decoration: _inputDecoration(
                  hint: 'example@mail.com',
                  icon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: AppSizes.p20),

              _buildLabel('كلمة المرور'),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                textAlign: TextAlign.start,
                decoration: _inputDecoration(
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
              ),
              
              const SizedBox(height: AppSizes.p12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {}, 
                  child: const Text('نسيت كلمة المرور؟', style: TextStyle(color: AppColors.accent)),
                ),
              ),
              const SizedBox(height: AppSizes.p32),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: authControllerState.isLoading
                      ? null
                      : () async {
                          if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('يرجى ملء جميع الحقول')),
                            );
                            return;
                          }
                          await ref.read(authControllerProvider.notifier).signIn(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: authControllerState.isLoading
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: AppSizes.p24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ليس لديك حساب؟', style: TextStyle(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () => context.goNamed(AppRoute.signup.name),
                    child: const Text('أنشئ حساباً الآن', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon, bool isPassword = false}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
      suffixIcon: isPassword 
        ? IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.textSecondary, size: 20),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          )
        : null,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
    );
  }
}