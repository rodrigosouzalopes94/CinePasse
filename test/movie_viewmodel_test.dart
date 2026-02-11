import 'dart:async';
import 'package:cine_passe_app/features/repositories/movierepository/i_movie_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cine_passe_app/features/controllers/movie_viewmodel.dart';
import 'package:cine_passe_app/models/movie_model.dart';


class MockMovieRepository extends Mock implements IMovieRepository {}

void main() {
  late MovieViewModel viewModel;
  late MockMovieRepository mockRepo;

  setUp(() {
    mockRepo = MockMovieRepository();
    viewModel = MovieViewModel(mockRepo);
  });

  group('MovieViewModel - Testes de Catálogo', () {
    
    test('Deve emitir a lista de filmes quando o repositório enviar novos dados', () async {
     
      final controller = StreamController<List<MovieModel>>();
      final tMovies = [
        const MovieModel(
          id: '1',
          titulo: 'Interestelar',
          sinopse: 'Viagem espacial',
          imagemUrl: 'url_imagem',
          classificacao: 'Livre',
          genero: 'Ficção',
          duracao: '169 min',
          mediaAvaliacao: 9.0,
        ),
      ];

      
      when(() => mockRepo.getMoviesStream()).thenAnswer((_) => controller.stream);

      
      expect(viewModel.moviesStream, emits(tMovies));

      
      controller.add(tMovies);

      
      await controller.close();
    });

    test('Deve retornar erro ao tentar avaliar sem estar logado (simulado)', () async {
    
      
      when(() => mockRepo.rateMovie(any(), any(), any(), any()))
          .thenThrow(Exception('Erro de permissão'));

      final result = await viewModel.submitRating(
        movieId: '1',
        userId: 'user_123',
        rating: 5.0,
      );

      expect(result, false);
      expect(viewModel.errorMessage, contains('Erro ao avaliar'));
      expect(viewModel.isRating, false);
    });
  });
}