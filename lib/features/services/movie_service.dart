import 'package:cine_passe_app/models/movie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MovieModel>> getMoviesStream() {
    return _firestore
        .collection('filmes')
        .orderBy('titulo') 
        .snapshots()
        .map((snapshot) {
          
          return snapshot.docs.map((doc) {
            return MovieModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  
  
  
  
  
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

    
    
    
    await _firestore
        .collection('filmes')
        .doc(movieId)
        .collection('avaliacoes')
        .doc(userId)
        .set(ratingData);
  }
}
