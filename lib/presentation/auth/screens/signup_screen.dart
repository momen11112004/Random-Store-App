import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routing/app_router.dart';
import '../controllers/auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _superCleanEmail(String email) {
    return email.toLowerCase().replaceAll(RegExp(r'[^a-z0-9@._-]'), '');
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
                content: Text('خطأ: $error'),
                backgroundColor: Colors.redAccent,
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), 
          onPressed: () => context.goNamed(AppRoute.login.name)
        )
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'إنشاء حساب جديد ✨',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textMain),
              ),
              const SizedBox(height: AppSizes.p8),
              const Text(
                'انضم إلينا واستمتع بتجربة تسوق لا مثيل لها.', 
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16)
              ),
              const SizedBox(height: AppSizes.p40),

              _buildLabel('الاسم الكامل'),
              _buildTextField(_nameController, 'أدخل اسمك', Icons.person_outline),
              const SizedBox(height: AppSizes.p20),

              _buildLabel('البريد الإلكتروني'),
              _buildTextField(
                _emailController, 
                'example@mail.com', 
                Icons.email_outlined, 
                keyboardType: TextInputType.emailAddress,
                isEmailField: true,
              ),
              const SizedBox(height: AppSizes.p20),

              _buildLabel('كلمة المرور'),
              _buildTextField(_passwordController, '••••••••', Icons.lock_outline, isPassword: true),
              
              const SizedBox(height: AppSizes.p40),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: authControllerState.isLoading
                      ? null
                      : () async {
                          final email = _superCleanEmail(_emailController.text);
                          final password = _passwordController.text.trim();
                          final name = _nameController.text.trim();

                          if (email.isEmpty || !email.contains('@') || email.length < 5) {
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('البريد الإلكتروني غير صحيح أو يحتوي على رموز غير مسموحة')),
                            );
                            return;
                          }

                          if (password.length < 6) {
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('كلمة المرور يجب أن تكون 6 أحرف على الأقل')),
                            );
                            return;
                          }

                          await ref.read(authControllerProvider.notifier).signUp(
                                name,
                                email,
                                password,
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
                      : const Text('إنشاء الحساب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: AppSizes.p24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('لديك حساب بالفعل؟', style: TextStyle(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () => context.goNamed(AppRoute.login.name),
                    child: const Text('سجل دخولك', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
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

  Widget _buildTextField(
    TextEditingController controller, 
    String hint, 
    IconData icon, 
    {bool isPassword = false, 
    TextInputType? keyboardType,
    bool isEmailField = false}
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      textAlign: TextAlign.start,
      textDirection: isEmailField ? TextDirection.ltr : null,
      autocorrect: false,
      enableSuggestions: !isPassword,
      inputFormatters: isEmailField ? [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
      ] : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}