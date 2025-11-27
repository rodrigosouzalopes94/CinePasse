import 'package:cine_passe_app/features/services/movie_service.dart';
import 'package:cine_passe_app/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cine_passe_app/widgets/movie_card.dart';
// Import do Serviço que conecta ao Firebase

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instância do serviço para buscar os dados
    final MovieService movieService = MovieService();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Hero Banner (Mantido estático por enquanto, ou pode vir do Firebase também)
          const _HeroBanner(),

          // 2. Movies Grid (Agora Dinâmico via StreamBuilder)
          StreamBuilder<List<MovieModel>>(
            stream: movieService.getMoviesStream(), // Escuta o Firestore
            builder: (context, snapshot) {
              // Estado: Carregando
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const _LoadingState();
              }

              // Estado: Erro
              if (snapshot.hasError) {
                return _ErrorState(error: snapshot.error.toString());
              }

              // Dados recuperados (ou lista vazia se null)
              final movies = snapshot.data ?? [];

              return _MoviesGrid(movies: movies);
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
    // Mantendo a identidade visual do seu HTML
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
            child: Container(color: Colors.black.withValues(alpha: 0.4)),
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

  const _MoviesGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Responsividade (Grid Columns)
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
                      // Aqui você conectará com a lógica de navegação para detalhes
                      onSelectMovie: () =>
                          debugPrint('Selecionou: ${movie.titulo}'),
                      // Aqui você conectará com a lógica de reservar ticket
                      onReserve: () => debugPrint('Reservar: ${movie.titulo}'),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final auxColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5) ??
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
