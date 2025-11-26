class MovieModel {
  final String id;
  final String titulo;
  final String sinopse;
  final String imagemUrl; // Capa (Poster)
  final String? backdropUrl; // Imagem de fundo (para a tela de detalhes)
  final String classificacao; // Ex: "14"
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

  // Método de fábrica para criar MovieModel a partir de dados do Firestore (Map)
  factory MovieModel.fromMap(Map<String, dynamic> data, String id) {
    return MovieModel(
      id: id,
      titulo: data['titulo'] ?? '',
      sinopse: data['sinopse'] ?? '',
      imagemUrl: data['imagemUrl'] ?? '',
      backdropUrl: data['backdropUrl'],
      classificacao: data['classificacao'] ?? 'Livre',
      genero: data['genero'] ?? '',
      duracao: data['duracao'] ?? 'N/A',
      mediaAvaliacao: (data['mediaAvaliacao'] as num?)?.toDouble() ?? 0.0,
    );
  }
}