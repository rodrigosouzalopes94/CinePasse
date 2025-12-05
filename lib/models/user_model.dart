import 'package:cloud_firestore/cloud_firestore.dart';

// -----------------------------------------------------------
// ENUM PARA TIPOS DE PLANO (Garante consistência)
// -----------------------------------------------------------
enum SubscriptionPlan {
  none, // Gratuito / Nenhum
  premium,
  familia,
}

class UserModel {
  final String? uid;
  final String nome;
  final String cpf;
  final String email;
  final int idade;
  // ✅ Adicionado: Campo para armazenar o Plano como uma string
  final String planoAtual;
  final Timestamp? planoVenceEm;
  final bool isAdmin;

  // 2. Construtor (Adicionando os novos campos)
  const UserModel({
    this.uid,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.idade,
    this.planoAtual = 'Nenhum', // Padrão
    this.planoVenceEm,
    this.isAdmin = false,
  });

  // 3. toMap (Prepara os dados para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'idade': idade,
      'planoAtual': planoAtual, // Salva o nome do plano (string)
      'planoVenceEm': planoVenceEm,
      'isAdmin': isAdmin,
      'dataRegistro': FieldValue.serverTimestamp(),
    };
  }

  // 4. fromMap (Cria o objeto vindo do Firestore)
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      nome: data['nome'] ?? '',
      cpf: data['cpf'] ?? '',
      email: data['email'] ?? '',
      idade:
          (data['idade'] is int
              ? data['idade']
              : int.tryParse(data['idade'].toString())) ??
          0,

      // ✅ Corrigido: Recuperando o plano e validade
      planoAtual: data['planoAtual'] ?? 'Nenhum',
      planoVenceEm: data['planoVenceEm'] as Timestamp?,
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => toMap();
}
