import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cine_passe_app/models/movie_model.dart';
import 'package:cine_passe_app/features/controllers/movie_viewmodel.dart';
import 'package:cine_passe_app/widgets/movie_card.dart';
import 'package:cine_passe_app/widgets/reservation_modal.dart';
import 'package:cine_passe_app/features/pages/movie_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
    // Escuta a ViewModel injetada no main.dart
    final movieViewModel = context.watch<MovieViewModel>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _HeroBanner(),
          
          StreamBuilder<List<MovieModel>>(
            stream: movieViewModel.moviesStream, // Usando o stream da ViewModel
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
                onReserve: (movie) => _showReservationModal(context, movie),
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

// --- Sub-widgets de Suporte ---

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    const double bannerHeight = 256.0;
    return Container(
      height: bannerHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9333EA), Color(0xFFEC4899)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.4))),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('CINEPASSE', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('O melhor do cinema na sua mão', style: TextStyle(color: Colors.white70, fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviesGrid extends StatelessWidget {
  final List<MovieModel> movies;
  final Function(MovieModel) onReserve;
  final Function(MovieModel) onSelectMovie;

  const _MoviesGrid({required this.movies, required this.onReserve, required this.onSelectMovie});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 250).floor().clamp(1, 4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Filmes em Cartaz', 
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
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
                  itemBuilder: (context, index) => MovieCard(
                    movie: movies[index],
                    onSelectMovie: () => onSelectMovie(movies[index]),
                    onReserve: () => onReserve(movies[index]),
                  ),
                ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) => const Padding(padding: EdgeInsets.all(48.0), child: Center(child: CircularProgressIndicator()));
}

class _ErrorState extends StatelessWidget {
  final String error;
  const _ErrorState({required this.error});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(32.0), child: Center(child: Text('Erro ao carregar catálogo.', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.error))));
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Nenhum filme em cartaz no momento.'));
}