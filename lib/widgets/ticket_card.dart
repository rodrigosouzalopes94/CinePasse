import 'package:cine_passe_app/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cine_passe_app/core/constants/colors_constants.dart';
import 'package:cine_passe_app/widgets/ticket_status_badge.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;

  const TicketCard({super.key, required this.ticket});

  // Mapeia o status para a cor da borda (replicando o CSS .ticket-visual)
  Color _getBorderColor() {
    switch (ticket.status) {
      case TicketStatus.approved:
        return kGreenCheckin; // .checked-in
      case TicketStatus.pending:
        return kOrangePending; // .pending-checkin
      case TicketStatus.rejected:
        return kRedRejected; // .rejected-checkin
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = _getBorderColor();
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: theme.cardColor, // .themed-bg-light
        borderRadius: BorderRadius.circular(12.0), // .rounded-xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDarkMode ? 0.3 : 0.1,
            ), // .shadow-lg
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Borda Esquerda Pontilhada (.ticket-visual border-left dashed)
              Container(
                width: 8.0,
                color: borderColor.withValues(
                  alpha: 0.1,
                ), // Fundo leve da borda
                child: CustomPaint(
                  painter: _DashedLinePainter(color: borderColor),
                ),
              ),

              // 2. Conteúdo do Voucher
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabeçalho: Status Badge e Tipo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TicketStatusBadge(status: ticket.status),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Text(
                              ticket.ticketType,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Título do Filme
                      Text(
                        ticket.movieTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Detalhes da Sessão (Ícone + Texto)
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.calendar,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('dd/MM/yyyy').format(ticket.sessionDate),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            FontAwesomeIcons.clock,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ticket.sessionTime,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),

                      // Código do Voucher (Footer)
                      Row(
                        children: [
                          Text(
                            'VOUCHER:',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SelectableText(
                            ticket.code,
                            style: TextStyle(
                              fontFamily: 'Monospace',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 3. QR Code (Área Direita)
              Container(
                width: 100,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF2C2C2C)
                      : const Color(0xFFF3F4F6),
                  border: Border(left: BorderSide(color: theme.dividerColor)),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Simulação do QR Code (em app real usaria o pacote qr_flutter)
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        FontAwesomeIcons.qrcode,
                        size: 50,
                        color: Colors.black.withValues(alpha: .8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan Me',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pintor para replicar o "border-left: 8px dashed"
class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth =
          2.0 // Espessura do traço
      ..style = PaintingStyle
          .stroke; // Alterado para stroke para fazer linhas diagonais ou retas

    // Vamos fazer um padrão pontilhado vertical no centro do container de 8px
    const double dashHeight = 6;
    const double dashSpace = 4;
    double startY = 2;

    // Ajusta o paint para preencher
    paint.style = PaintingStyle.fill;

    while (startY < size.height) {
      // Desenha pequenos retângulos verticais para simular o 'dashed' grosso
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            2,
            startY,
            4,
            dashHeight,
          ), // Centralizado no container de 8px
          const Radius.circular(2),
        ),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
