import 'package:cine_passe_app/models/movie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // 1. LEITURA (READ): Stream para carregar filmes em tempo real
  // ---------------------------------------------------------------------------
  // Este método escuta a coleção 'filmes'. Qualquer alteração feita pelo
  // seu Painel Admin (React) será refletida aqui instantaneamente.
  Stream<List<MovieModel>> getMoviesStream() {
    return _firestore
        .collection('filmes')
        .orderBy('titulo') // Ordena alfabeticamente por padrão
        .snapshots()
        .map((snapshot) {
          // Mapeia cada documento do Firestore para um objeto MovieModel
          return snapshot.docs.map((doc) {
            return MovieModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // ---------------------------------------------------------------------------
  // 2. AVALIAÇÃO (WRITE): O usuário apenas avalia, não edita o filme
  // ---------------------------------------------------------------------------
  // Salva a avaliação em uma subcoleção separada para manter os dados organizados
  // e evitar conflitos de permissão na coleção principal de filmes.
  Future<void> rateMovie(
    String movieId,
    String userId,
    double rating,
    String? comment,
  ) async {
    final ratingData = {
      'userId': userId,
      'rating': rating,
      'comentario': comment,
      'dataAvaliacao': FieldValue.serverTimestamp(),
    };

    // Caminho: /filmes/{movieId}/avaliacoes/{userId}
    // Usar o userId como ID do documento garante que cada usuário só possa
    // ter UMA avaliação por filme (se avaliar de novo, sobrescreve a anterior).
    await _firestore
        .collection('filmes')
        .doc(movieId)
        .collection('avaliacoes')
        .doc(userId)
        .set(ratingData);
  }
}
