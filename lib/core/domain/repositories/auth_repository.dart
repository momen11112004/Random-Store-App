import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<UserEntity> signIn(String email, String password);

  Future<UserEntity> signUp(String name, String email, String password);

  Future<void> signOut();
}