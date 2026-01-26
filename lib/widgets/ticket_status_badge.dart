import 'package:cine_passe_app/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:cine_passe_app/core/constants/colors_constants.dart';

class TicketStatusBadge extends StatelessWidget {
  final TicketStatus status;

  const TicketStatusBadge({super.key, required this.status});

  
  Map<String, dynamic> _getStatusData() {
    switch (status) {
      case TicketStatus.approved:
        
        return {'text': 'APROVADO', 'color': kGreenCheckin};
      case TicketStatus.pending:
        
        return {'text': 'PENDENTE', 'color': kOrangePending};
      case TicketStatus.rejected:
        
        return {'text': 'REJEITADO', 'color': kRedRejected};
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getStatusData();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      
      decoration: BoxDecoration(
        color: data['color'] as Color,
        borderRadius: BorderRadius.circular(
          20.0,
        ), 
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
