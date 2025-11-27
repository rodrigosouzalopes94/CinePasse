import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream de mudanças no estado da auth
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ------------------------------
  // LOGIN
  // ------------------------------
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthErrors(e);
      return null; // nunca chega aqui, mas evita warn
    }
  }

  // ------------------------------
  // REGISTRO
  // ------------------------------
  Future<User?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthErrors(e);
      return null;
    }
  }

  // ------------------------------
  // RESET DE SENHA
  // ------------------------------
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      _handleAuthErrors(e);
    }
  }

  // ------------------------------
  // LOGOUT
  // ------------------------------
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ------------------------------
  // TRATAMENTO CENTRALIZADO DE ERROS
  // ------------------------------
  Never _handleAuthErrors(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
        throw 'Senha incorreta.';
      case 'user-not-found':
        throw 'Usuário não encontrado.';
      case 'invalid-email':
        throw 'Email inválido.';
      case 'email-already-in-use':
        throw 'Este e-mail já está registrado.';
      case 'weak-password':
        throw 'A senha deve conter pelo menos 6 caracteres.';
      case 'network-request-failed':
        throw 'Sem internet. Verifique sua conexão.';
      default:
        throw 'Erro desconhecido: ${e.message}';
    }
  }
}
