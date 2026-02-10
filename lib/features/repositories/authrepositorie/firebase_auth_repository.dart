import 'package:cine_passe_app/features/repositories/authrepositorie/i_auth_repository.dart';
import 'package:cine_passe_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<UserModel?> get onAuthStateChanged {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await fetchUserProfile(user.uid);
    });
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user != null) {
      return await fetchUserProfile(credential.user!.uid);
    }
    return null;
  }

  @override
  Future<UserModel?> fetchUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  @override
  Future<UserModel?> register(UserModel user, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: user.email.trim(),
      password: password,
    );

    if (credential.user != null) {
      final newUser = user.copyWith(uid: credential.user!.uid);
      await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());
      return newUser;
    }
    return null;
  }

  @override
  Future<void> updateProfile({
    required String newName,
    required int newAge,
    String? newPlan,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Usuário não autenticado");

    
    await user.updateDisplayName(newName);
    await user.reload();

    
    await _firestore.collection('users').doc(user.uid).update({
      'nome': newName,
      'idade': newAge,
      if (newPlan != null) 'planoAtual': newPlan,
    });
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }
}