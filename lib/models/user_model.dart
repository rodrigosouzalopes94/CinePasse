import 'package:cloud_firestore/cloud_firestore.dart';

enum SubscriptionPlan { none, premium, familia }

class UserModel {
  final String? uid;
  final String nome;
  final String cpf;
  final String email;
  final int idade;

  final String planoAtual;
  final Timestamp? planoVenceEm;
  final bool isAdmin;

  const UserModel({
    this.uid,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.idade,
    this.planoAtual = 'Nenhum',
    this.planoVenceEm,
    this.isAdmin = false,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'idade': idade,
      'planoAtual': planoAtual,
      'planoVenceEm': planoVenceEm,
      'isAdmin': isAdmin,
    };
  }

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

      planoAtual: data['planoAtual'] ?? 'Nenhum',
      planoVenceEm: data['planoVenceEm'] as Timestamp?,
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => toMap();
}
