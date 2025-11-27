import 'package:cine_passe_app/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:cine_passe_app/core/constants/colors_constants.dart';

class TicketStatusBadge extends StatelessWidget {
  final TicketStatus status;

  const TicketStatusBadge({super.key, required this.status});

  // Função que mapeia o Enum para cor e texto (replicando o CSS)
  Map<String, dynamic> _getStatusData() {
    switch (status) {
      case TicketStatus.approved:
        // Mapeia para kGreenCheckin (.badge-checked-in)
        return {'text': 'APROVADO', 'color': kGreenCheckin};
      case TicketStatus.pending:
        // Mapeia para kOrangePending (.badge-pending)
        return {'text': 'PENDENTE', 'color': kOrangePending};
      case TicketStatus.rejected:
        // Mapeia para kRedRejected (.badge-rejeitado)
        return {'text': 'REJEITADO', 'color': kRedRejected};
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getStatusData();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      // badge-checked-in, badge-pending, badge-rejeitado
      decoration: BoxDecoration(
        color: data['color'] as Color,
        borderRadius: BorderRadius.circular(
          20.0,
        ), // Borda arredondada estilo badge
      ),
      child: Text(
        data['text'] as String,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
