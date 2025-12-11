import 'package:firebase_auth/firebase_auth.dart';

// ⚠️ Certifique-se de que este serviço é um Singleton ou
// que é injetado corretamente via Provider ou GetIt/Riverpod.

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream para monitorar mudanças no estado da autenticação (Logado <-> Deslogado)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Método para obter o usuário atual
  User? get currentUser => _firebaseAuth.currentUser;

  // 1. Login
  Future<User?> login(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  // 2. Registro
  Future<User?> register(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
      // 🚀 BOAS PRÁTICAS: Força o nome de exibição inicial
      // Isso será atualizado na ProfilePage depois
    );
    return credential.user;
  }

  // 3. Recuperação de Senha
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }
  
  // 🚀 NOVO MÉTODO: Atualiza o nome de exibição do usuário no Firebase Auth
  Future<void> updateUserProfile({required String newName}) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      // O método updateDisplayName é do próprio Firebase
      await user.updateDisplayName(newName);
      
      // Força um refresh no token do ID e no objeto User local,
      // para garantir que a interface seja atualizada imediatamente.
      await user.reload(); 
    } else {
      throw Exception("Usuário não logado. Falha ao atualizar perfil.");
    }
  }
  
  // 4. Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}