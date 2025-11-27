import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // 1. Campos
  final String?
  uid; // Pode ser nulo antes de criar, mas essencial para o Firestore
  final String nome;
  final String cpf;
  final String email;
  final int idade;

  // Nota: NÃO guardamos 'senha' aqui. A senha fica apenas no Firebase Auth.
  // Isso resolve o erro "Required named parameter 'senha' must be provided".

  // 2. Construtor
  const UserModel({
    this.uid,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.idade,
  });

  // 3. toMap (Resolve o erro: method 'toMap' isn't defined)
  // Prepara os dados para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid, // Opcional salvar o UID dentro do documento também
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'idade': idade,
      'planoAtual': 'Nenhum',
      'dataRegistro': FieldValue.serverTimestamp(),
    };
  }

  // 4. fromMap (Resolve o erro: Member not found: 'UserModel.fromMap')
  // Cria o objeto vindo do Firestore
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      nome: data['nome'] ?? '',
      cpf: data['cpf'] ?? '',
      email: data['email'] ?? '',
      idade: data['idade'] is int
          ? data['idade']
          : int.tryParse(data['idade'].toString()) ?? 0,
    );
  }

  // Auxiliar para JSON (útil para debug)
  Map<String, dynamic> toJson() => toMap();
}
