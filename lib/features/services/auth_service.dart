import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para monitorar mudanças no estado da autenticação (Logado <-> Deslogado)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual (se houver)
  User? get currentUser => _auth.currentUser;

  // 1. Login
  Future<User?> login(String email, String password) async {
    // Deixamos a exceção subir para ser tratada no Controller
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  // 2. Registro
  Future<User?> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  // 3. Recuperação de Senha
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // 4. Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
