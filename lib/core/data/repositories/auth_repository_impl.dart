import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((firebaseUser) {
      if (firebaseUser == null) return null;
      return UserEntity(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName ?? 'مستخدم',
      );
    });
  }

  @override
  Future<UserEntity> signIn(String email, String password) async {
    final userModel = await _remoteDataSource.signIn(email, password);
    return userModel.toEntity(); 
  }

  @override
  Future<UserEntity> signUp(String name, String email, String password) async {
    final userModel = await _remoteDataSource.signUp(name, email, password);
    return userModel.toEntity();
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});