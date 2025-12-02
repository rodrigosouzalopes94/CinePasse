// ✅ Usando caminho relativo para o MovieModel para evitar erros de nome de pacote
import 'package:cine_passe_app/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/utils/get_rating_color.dart';
import 'custom_button.dart';

class MovieCard extends StatefulWidget {
  // CORRIGIDO
  final MovieModel movie;
  final VoidCallback onSelectMovie;
  final VoidCallback onReserve;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onSelectMovie,
    required this.onReserve,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  // Estado para simular o efeito hover do Tailwind (hover:scale-105)
  double _scale = 1.0;

  void _onHover(bool isHovering) {
    setState(() {
      _scale = isHovering ? 1.05 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Cor de fundo do Card (themed-bg-light)
    final cardColor = theme.cardColor;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onSelectMovie, // @click="selectMovie(filme)"
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 300), // transition
          child: Container(
            decoration: BoxDecoration(
              color: cardColor, // themed-bg-light
              borderRadius: BorderRadius.circular(12.0), // rounded-xl
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15), // shadow-lg
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            // movie-card themed-bg-light rounded-xl overflow-hidden shadow-lg
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem (img w-full h-64 object-cover)
                  Image.network(
                    widget.movie.imagemUrl,
                    fit: BoxFit.cover,
                    height: 256, // h-64 (Aprox 256px)
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 256,
                        color: theme.dividerColor,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 256,
                      color: theme.dividerColor,
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),

                  // Detalhes do Filme (div p-4)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título (h3 text-xl font-bold themed-text mb-2 line-clamp-1)
                        Text(
                          widget.movie.titulo,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            // themed-text
                          ),
                          maxLines: 1, // line-clamp-1
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Info (div flex items-center gap-2 text-sm text-gray-400)
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            // Classificação Etária (span.classificacao)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: getRatingColor(
                                  widget.movie.classificacao,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.movie.classificacao,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            // Gênero
                            Text(
                              widget.movie.genero,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),

                            // Duração
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FontAwesomeIcons.clock,
                                  size: 12,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.movie.duracao,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Sinopse (p text-gray-400 text-sm line-clamp-3)
                        Text(
                          widget.movie.sinopse,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ), // text-gray-400
                          maxLines: 3, // line-clamp-3
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),

                        // Rodapé (Avaliação e Botão)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Avaliação (span text-yellow-400)
                            Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.solidStar,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.movie.mediaAvaliacao.toStringAsFixed(
                                    1,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            // Botão Reservar
                            SizedBox(
                              width:
                                  120, // Largura fixa para o botão dentro do card
                              child: CustomButton(
                                text: 'Reservar',
                                onPressed: widget
                                    .onReserve, // @click.stop="iniciarReserva(filme)"
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
