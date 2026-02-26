import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/repositories/auth_repository_impl.dart';
import '../../../core/domain/entities/user_entity.dart';
import '../../../core/domain/repositories/auth_repository.dart';

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signIn(email, password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signUp(name, email, password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository);
});