import 'package:cloud_firestore/cloud_firestore.dart';

class MovieModel {
  final String id;
  final String titulo;
  final String sinopse;
  final String imagemUrl; // URL da imagem (Poster)
  final String? backdropUrl; // Imagem de fundo (opcional)
  final String classificacao; // Ex: "14", "Livre"
  final String genero;
  final String duracao; // Ex: "2h 15min"
  final double mediaAvaliacao; // Ex: 4.5

  // Construtor
  const MovieModel({
    required this.id,
    required this.titulo,
    required this.sinopse,
    required this.imagemUrl,
    this.backdropUrl,
    required this.classificacao,
    required this.genero,
    required this.duracao,
    required this.mediaAvaliacao,
  });

  // 🏭 FACTORY: O Tradutor
  // Este método pega o Map bagunçado que vem do Firebase e transforma
  // em um objeto MovieModel limpo e seguro para o Flutter usar.
  factory MovieModel.fromMap(Map<String, dynamic> data, String documentId) {
    return MovieModel(
      id: documentId,
      titulo: data['titulo'] ?? 'Título Indisponível',
      sinopse: data['sinopse'] ?? 'Sem sinopse.',
      imagemUrl:
          data['imagemUrl'] ??
          'https://placehold.co/400x600?text=Sem+Imagem', // Fallback
      backdropUrl: data['backdropUrl'],
      classificacao: data['classificacao'] ?? 'Livre',
      genero: data['genero'] ?? 'Geral',
      duracao: data['duracao'] ?? '--',
      // Converte números inteiros ou doubles de forma segura
      mediaAvaliacao: (data['mediaAvaliacao'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Método opcional: Se você precisar enviar dados DE VOLTA para o Firebase
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'sinopse': sinopse,
      'imagemUrl': imagemUrl,
      'backdropUrl': backdropUrl,
      'classificacao': classificacao,
      'genero': genero,
      'duracao': duracao,
      'mediaAvaliacao': mediaAvaliacao,
    };
  }
}
