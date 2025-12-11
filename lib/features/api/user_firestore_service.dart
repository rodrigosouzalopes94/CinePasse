import 'package:cine_passe_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // 1. SALVAR DADOS DO USUÁRIO (no Registro)
  // ---------------------------------------------------------------------------
  Future<void> saveUser(UserModel user) async {
    if (user.uid == null) throw Exception("UID do usuário é obrigatório");

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toMap());
    } catch (e) {
      throw Exception("Erro ao salvar dados do usuário: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 2. ATUALIZAR PERFIL DO USUÁRIO
  // ---------------------------------------------------------------------------
  Future<void> updateUser(UserModel user) async {
    if (user.uid == null) throw Exception("UID do usuário é obrigatório para atualização.");

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(user.toMap());
    } catch (e) {
      throw Exception("Erro ao atualizar dados do usuário: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 3. LER DADOS DO USUÁRIO
  // ---------------------------------------------------------------------------
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      throw Exception("Erro ao buscar usuário: $e");
    }
  }
}
