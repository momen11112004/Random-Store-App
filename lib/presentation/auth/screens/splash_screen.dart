import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_sizes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A), 
                  Color(0xFF1E293B), 
                  Color(0xFF020617), 
                ],
              ),
            ),
          ),

          Positioned(
            top: -50,
            left: -50,
            child: Opacity(
              opacity: 0.03,
              child: Icon(Icons.shopping_bag, size: 300, color: Colors.white),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.1),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded, 
                    size: 60,
                    color: AppColors.accent,
                  ),
                )
                .animate()
                .scale(duration: 800.ms, curve: Curves.elasticOut)
                .shimmer(delay: 1200.ms, duration: 1500.ms),

                const SizedBox(height: AppSizes.p32),

                Column(
                  children: [
                    const Text(
                      'RANDOM',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w200, 
                        color: Colors.white,
                        letterSpacing: 10, 
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .blur(begin: const Offset(10, 10), end: Offset.zero),
                    
                    const Text(
                      'STORE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900, 
                        color: AppColors.accent,
                        letterSpacing: 2,
                      ),
                    )
                    .animate()
                    .slideY(begin: 0.5, end: 0, delay: 400.ms, duration: 600.ms)
                    .fadeIn(),
                  ],
                ),

                const SizedBox(height: AppSizes.p16),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.1)),
                      bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                  child: const Text(
                    'متجر عشوائي .. تجربة تسوق ذكية',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ).animate().fade(delay: 1500.ms),
              ],
            ),
          ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(
                  width: 40,
                  height: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.05),
                    valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                  ),
                ).animate().fade(delay: 2000.ms),
                const SizedBox(height: 12),
                const Text(
                  'جاري تهيئة المتجر...',
                  style: TextStyle(color: Colors.white24, fontSize: 10),
                ).animate().fade(delay: 2200.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}