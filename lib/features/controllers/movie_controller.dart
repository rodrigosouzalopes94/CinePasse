import 'package:cine_passe_app/features/services/movie_service.dart';
import 'package:cine_passe_app/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MovieController extends ChangeNotifier {
  final MovieService _service = MovieService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isRating = false; // Estado de carregamento ao enviar avaliação
  String? _errorMessage;

  bool get isRating => _isRating;
  String? get errorMessage => _errorMessage;

  // Stream direta para a UI consumir (HomePage)
  Stream<List<MovieModel>> get moviesStream => _service.getMoviesStream();

  // Ação de Avaliar
  Future<bool> submitRating(
    String movieId,
    double rating, {
    String? comment,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      _errorMessage = "Você precisa estar logado para avaliar.";
      notifyListeners();
      return false;
    }

    _isRating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.rateMovie(movieId, user.uid, rating, comment);
      _isRating = false;
      notifyListeners();
      return true; // Sucesso
    } catch (e) {
      _isRating = false;
      _errorMessage = "Erro ao enviar avaliação: $e";
      notifyListeners();
      return false; // Falha
    }
  }
}
