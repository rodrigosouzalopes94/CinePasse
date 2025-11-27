import 'package:cine_passe_app/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cine_passe_app/core/utils/get_rating_color.dart';
import 'package:cine_passe_app/widgets/custom_button.dart';

class MovieDetailPage extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      // Estende o corpo atrás da AppBar para o efeito de transparência
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: 100,
        ), // Espaço para o botão flutuante se houver
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BACKDROP E POSTER (Hero Section)
            _buildHeader(context),

            const SizedBox(height: 24),

            // 2. CONTEÚDO PRINCIPAL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    movie.titulo,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Metadados (Gênero • Duração)
                  Text(
                    '${movie.genero} • ${movie.duracao}',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 16),

                  // Badges (Classificação e Estrelas)
                  Row(
                    children: [
                      // Classificação
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: getRatingColor(movie.classificacao),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          movie.classificacao,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Estrelas
                      Icon(
                        FontAwesomeIcons.solidStar,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        movie.mediaAvaliacao.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Sinopse
                  Text(
                    movie.sinopse,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: isDarkMode
                          ? Colors.grey.shade300
                          : Colors.grey.shade800,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Botão de Ação (Reservar)
                  CustomButton(
                    text: 'Reservar Ingresso',
                    onPressed: () {
                      // TODO: Implementar lógica de reserva (chamar TicketController)
                      debugPrint('Iniciar reserva para: ${movie.titulo}');
                    },
                  ),

                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 20),

                  // 3. SEÇÃO DE AVALIAÇÕES (Placeholder baseado no HTML)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Avaliações',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Aqui entrará o widget de lista de avaliações futuramente
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Ainda não há avaliações para este filme. Seja o primeiro!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para montar o cabeçalho complexo (Imagem de fundo + Poster)
  Widget _buildHeader(BuildContext context) {
    // Usa backdropUrl se disponível, senão usa a imagemUrl (poster) com zoom/blur
    final bgImage = movie.backdropUrl ?? movie.imagemUrl;

    return SizedBox(
      height: 400, // Altura da área de destaque
      child: Stack(
        children: [
          // Fundo (Backdrop)
          Positioned.fill(
            child: Image.network(
              bgImage,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.6), // Escurece a imagem
              colorBlendMode: BlendMode.darken,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
            ),
          ),

          // Gradiente inferior para suavizar a transição para o corpo
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Poster Flutuante Centralizado (Opcional, mas comum em apps de cinema)
          Positioned(
            bottom: 0,
            left: 20,
            child: Hero(
              tag:
                  'movie-poster-${movie.id}', // Animação de transição da Home para cá
              child: Container(
                width: 120,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(movie.imagemUrl, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
