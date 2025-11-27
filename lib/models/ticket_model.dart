// lib/core/models/ticket_model.dart

// Este Enum mapeia diretamente para os status de aprovação
enum TicketStatus { pending, approved, rejected }

class TicketModel {
  final String ticketId;

  // Informações do Filme/Voucher (Para exibição na UI)
  final String movieTitle;
  final String sessionTime;

  final String code;
  final DateTime sessionDate;

  // Status de Aprovação: CRUCIAL (Status de 'Pendente' é o default)
  final TicketStatus status;

  final String ticketType; // 'Reserva Normal' vs 'Plano Assinatura'

  const TicketModel({
    required this.ticketId,
    required this.movieTitle,
    required this.sessionTime,
    required this.code,
    required this.sessionDate,
    required this.status,
    required this.ticketType,
  });

  // Futuramente adicionaremos aqui o factory TicketModel.fromMap para converter do Firebase
}
