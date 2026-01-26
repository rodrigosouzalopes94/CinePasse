import 'package:firebase_auth/firebase_auth.dart';




class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  
  User? get currentUser => _firebaseAuth.currentUser;

  
  Future<User?> login(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  
  Future<User?> register(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
      
      
    );
    return credential.user;
  }

  
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }
  
  
  Future<void> updateUserProfile({required String newName}) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      
      await user.updateDisplayName(newName);
      
      
      
      await user.reload(); 
    } else {
      throw Exception("Usuário não logado. Falha ao atualizar perfil.");
    }
  }
  
  
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}