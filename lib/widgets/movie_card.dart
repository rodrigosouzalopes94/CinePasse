
import 'package:cine_passe_app/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/utils/get_rating_color.dart';
import 'custom_button.dart';

class MovieCard extends StatefulWidget {
  
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
  
  double _scale = 1.0;

  void _onHover(bool isHovering) {
    setState(() {
      _scale = isHovering ? 1.05 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    
    final cardColor = theme.cardColor;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onSelectMovie, 
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 300), 
          child: Container(
            decoration: BoxDecoration(
              color: cardColor, 
              borderRadius: BorderRadius.circular(12.0), 
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15), 
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Image.network(
                    widget.movie.imagemUrl,
                    fit: BoxFit.cover,
                    height: 256, 
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

                  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Text(
                          widget.movie.titulo,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            
                          ),
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            
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

                            
                            Text(
                              widget.movie.genero,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),

                            
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

                        
                        Text(
                          widget.movie.sinopse,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ), 
                          maxLines: 3, 
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),

                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
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

                            
                            SizedBox(
                              width:
                                  120, 
                              child: CustomButton(
                                text: 'Reservar',
                                onPressed: widget
                                    .onReserve, 
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
