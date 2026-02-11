import 'package:cine_passe_app/features/repositories/movierepository/i_movie_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cine_passe_app/models/movie_model.dart';

class FirebaseMovieRepository implements IMovieRepository {
  final FirebaseFirestore _firestore;

  FirebaseMovieRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<MovieModel>> getMoviesStream() {
    return _firestore
        .collection('filmes')
        .orderBy('titulo')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MovieModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<void> rateMovie(String movieId, String userId, double rating, String? comment) async {
    final ratingData = {
      'userId': userId,
      'rating': rating,
      'comentario': comment,
      'dataAvaliacao': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('filmes')
        .doc(movieId)
        .collection('avaliacoes')
        .doc(userId)
        .set(ratingData);
  }
}