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

  // 2. Construtor
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

  // 🚀 MÉTODO ESSENCIAL: Permite copiar o objeto com novos valores (imutabilidade)
  UserModel copyWith({
    String? uid,
    String? nome,
    String? cpf,
    String? email,
    int? idade,
    String? planoAtual,
    Timestamp? planoVenceEm,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      idade: idade ?? this.idade,
      planoAtual: planoAtual ?? this.planoAtual,
      planoVenceEm: planoVenceEm ?? this.planoVenceEm,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

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
      // ⚠️ CORREÇÃO: Removido dataRegistro para evitar erro de 'FieldValue'
      // pois toMap é usado no update.
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