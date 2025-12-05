import 'package:cine_passe_app/features/pages/movie_detail_page.dart';
import 'package:cine_passe_app/features/services/movie_service.dart';
import 'package:cine_passe_app/models/movie_model.dart';
import 'package:cine_passe_app/widgets/movie_card.dart';
import 'package:cine_passe_app/widgets/reservation_modal.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // 1. Função para exibir o modal de reserva
  void _showReservationModal(BuildContext context, MovieModel movie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReservationModal(movie: movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Instância do serviço para buscar os dados
    final MovieService movieService = MovieService();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Hero Banner
          const _HeroBanner(),

          // 2. Movies Grid
          StreamBuilder<List<MovieModel>>(
            stream: movieService.getMoviesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const _LoadingState();
              }
              if (snapshot.hasError) {
                return _ErrorState(error: snapshot.error.toString());
              }

              final movies = snapshot.data ?? [];

              return _MoviesGrid(
                movies: movies,
                // ✅ Conecta o onReserve do Card à função local
                onReserve: (movie) => _showReservationModal(context, movie),
                // ✅ Conecta o onSelectMovie (ir para detalhes)
                onSelectMovie: (movie) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// WIDGETS AUXILIARES
// -------------------------------------------------------------------

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    const double bannerHeight = 256.0;
    const Color purple600 = Color(0xFF9333EA);
    const Color pink600 = Color(0xFFEC4899);

    return Container(
      height: bannerHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [purple600, pink600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CINEPASSE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'O melhor do cinema na sua mão',
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviesGrid extends StatelessWidget {
  final List<MovieModel> movies;
  // ✅ CORREÇÃO: Adiciona os callbacks que faltavam
  final Function(MovieModel) onReserve;
  final Function(MovieModel) onSelectMovie;

  const _MoviesGrid({
    required this.movies,
    required this.onReserve, // Adicionado
    required this.onSelectMovie, // Adicionado
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if (screenWidth >= 600) crossAxisCount = 2;
    if (screenWidth >= 900) crossAxisCount = 3;
    if (screenWidth >= 1200) crossAxisCount = 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Filmes em Cartaz',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyMedium?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          movies.isEmpty
              ? const _EmptyState()
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 24.0,
                    mainAxisSpacing: 24.0,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return MovieCard(
                      movie: movie,
                      onSelectMovie: () => onSelectMovie(movie),
                      // Passa o callback para o MovieCard
                      // O MovieCard espera VoidCallback, então a HomePage já trata o MovieModel no closure
                      onReserve: () => onReserve(movie),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

// --- WIDGETS DE ESTADO ---
// (Para evitar que o app quebre se o StreamBuilder retornar estados não processados)

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final auxColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5) ??
        Colors.grey;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Column(
          children: [
            Icon(FontAwesomeIcons.film, size: 64, color: auxColor),
            const SizedBox(height: 16),
            Text(
              'Nenhum filme em cartaz',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Aguarde as atualizações do catálogo.',
              style: TextStyle(color: auxColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(48.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  const _ErrorState({required this.error});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Text(
          'Erro ao carregar catálogo.\nVerifique sua conexão.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
