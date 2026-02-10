import 'package:cine_passe_app/models/movie_model.dart';

abstract class IMovieRepository {
 
  Stream<List<MovieModel>> getMoviesStream();

  Future<void> rateMovie(String movieId, String userId, double rating, String? comment);
}