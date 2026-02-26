import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/utils/firebase_providers.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> get authStateChanges;
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String name, String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user == null) throw Exception('فشل في تسجيل الدخول');

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      } else {
        return UserModel(id: user.uid, email: user.email ?? '', name: 'مستخدم');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('خطأ في المصادقة: ${e.message}');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user == null) throw Exception('فشل في إنشاء الحساب');

      final userModel = UserModel(id: user.uid, email: email, name: name);

      await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception('خطأ في إنشاء الحساب: ${e.message}');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    ref.watch(firebaseAuthProvider),
    ref.watch(firestoreProvider),
  );
});