import 'package:cine_passe_app/features/repositories/movierepository/i_movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:cine_passe_app/models/movie_model.dart';

class MovieViewModel with ChangeNotifier {
  final IMovieRepository _repository;

  MovieViewModel(this._repository);

  bool _isRating = false;
  bool get isRating => _isRating;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Stream<List<MovieModel>> get moviesStream => _repository.getMoviesStream();

  Future<bool> submitRating({
    required String movieId,
    required String userId,
    required double rating,
    String? comment,
  }) async {
    _isRating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.rateMovie(movieId, userId, rating, comment);
      return true;
    } catch (e) {
      _errorMessage = "Erro ao avaliar: $e";
      return false;
    } finally {
      _isRating = false;
      notifyListeners();
    }
  }
}