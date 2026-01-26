import 'package:cloud_firestore/cloud_firestore.dart';

class MovieModel {
  final String id;
  final String titulo;
  final String sinopse;
  final String imagemUrl; 
  final String? backdropUrl; 
  final String classificacao; 
  final String genero;
  final String duracao; 
  final double mediaAvaliacao; 

  
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

  
  
  
  factory MovieModel.fromMap(Map<String, dynamic> data, String documentId) {
    return MovieModel(
      id: documentId,
      titulo: data['titulo'] ?? 'Título Indisponível',
      sinopse: data['sinopse'] ?? 'Sem sinopse.',
      imagemUrl:
          data['imagemUrl'] ??
          'https://placehold.co/400x600?text=Sem+Imagem',
      backdropUrl: data['backdropUrl'],
      classificacao: data['classificacao'] ?? 'Livre',
      genero: data['genero'] ?? 'Geral',
      duracao: data['duracao'] ?? '--',
      
      mediaAvaliacao: (data['mediaAvaliacao'] as num?)?.toDouble() ?? 0.0,
    );
  }

  
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
