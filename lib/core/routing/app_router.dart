import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/entities/product_entity.dart';

import '../../presentation/auth/controllers/auth_controller.dart';

import '../../presentation/auth/screens/splash_screen.dart';
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/auth/screens/signup_screen.dart';
import '../../presentation/auth/screens/profile_screen.dart';
import '../../presentation/home/screens/home_screen.dart';
import '../../presentation/home/screens/product_details_screen.dart';
import '../../presentation/home/screens/favorites_screen.dart';
import '../../presentation/cart/screens/cart_screen.dart';
import '../../presentation/cart/screens/order_success_screen.dart';

enum AppRoute {
  splash,
  home,
  login,
  signup,
  productDetails,
  cart,
  orderSuccess,
  profile,
  favorites,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash', 
    debugLogDiagnostics: true,
    
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final bool isLoggedIn = authState.valueOrNull != null;
      final String currentLocation = state.matchedLocation;

      if (currentLocation == '/splash') return null;

      final bool isAuthPage = currentLocation == '/login' || currentLocation == '/signup';

      if (!isLoggedIn && !isAuthPage) {
        return '/login';
      }

      if (isLoggedIn && isAuthPage) {
        return '/';
      }

      return null;
    },
    
    routes: [
      GoRoute(
        path: '/splash',
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: AppRoute.signup.name,
        builder: (context, state) => const SignUpScreen(),
      ),

      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'product-details',
            name: AppRoute.productDetails.name,
            builder: (context, state) {
              final product = state.extra as ProductEntity;
              return ProductDetailsScreen(product: product);
            },
          ),
          GoRoute(
            path: 'cart',
            name: AppRoute.cart.name,
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: 'profile',
            name: AppRoute.profile.name,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'favorites',
            name: AppRoute.favorites.name,
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: 'order-success',
            name: AppRoute.orderSuccess.name,
            builder: (context, state) => const OrderSuccessScreen(),
          ),
        ],
      ),
    ],
  );
});