// lib/models/user_model.dart

class UserModel {
  // Propriedades são finais para garantir que o objeto seja imutável após a criação.
  final String nome;
  final String cpf;
  final String email;
  final String
  senha; // Armazenar a senha diretamente é **desaconselhado** em ambientes reais, mas é mantido aqui para simular o modelo de dados fornecido.
  final int idade;

  // Construtor principal (requer todos os campos)
  const UserModel({
    required this.nome,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.idade,
  });

  // -------------------------------------------------------------------
  // 🏭 Construtor para desserialização (JSON -> Objeto Dart)
  // Útil ao receber dados de uma API.
  // -------------------------------------------------------------------
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nome: json['nome'] as String,
      cpf: json['cpf'] as String,
      email: json['email'] as String,
      // **Atenção:** Se este modelo for usado para receber dados de uma API real,
      // o campo 'senha' NUNCA deve ser incluído no JSON de retorno!
      senha: json['senha'] as String,
      idade: json['idade'] as int,
    );
  }

  // -------------------------------------------------------------------
  // 📦 Método para serialização (Objeto Dart -> JSON)
  // Útil ao enviar dados para uma API (ex: no cadastro ou login).
  // -------------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cpf': cpf,
      'email': email,
      // A senha deve ser enviada, mas deve ser **HASHEADA** no backend!
      'senha': senha,
      'idade': idade,
    };
  }

  // -------------------------------------------------------------------
  // 🔄 Método copyWith (para criar uma cópia com alterações)
  // Útil se você precisar de uma versão mutável do modelo (ex: formulário de edição).
  // -------------------------------------------------------------------
  UserModel copyWith({
    String? nome,
    String? cpf,
    String? email,
    String? senha,
    int? idade,
  }) {
    return UserModel(
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      idade: idade ?? this.idade,
    );
  }
}
