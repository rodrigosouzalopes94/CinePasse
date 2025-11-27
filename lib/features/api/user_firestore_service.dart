import 'package:cine_passe_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Salvar dados do usuário ao registrar
  Future<void> saveUser(UserModel user) async {
    if (user.uid == null) throw Exception("UID do usuário é obrigatório");

    try {
      await _firestore
          .collection('users')
          .doc(user.uid) // Usa o UID do Auth como ID do documento
          .set(user.toMap());
    } catch (e) {
      throw Exception("Erro ao salvar dados do usuário: $e");
    }
  }

  // Ler dados do usuário (útil para saber o plano atual)
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
