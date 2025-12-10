import 'package:cloud_firestore/cloud_firestore.dart';

// Enum para representar o status de aprovação do voucher
enum TicketStatus { pending, approved, rejected }

class TicketModel {
  final String ticketId;
  final String usuarioId;

  final String movieTitle;
  final String sessionTime;

  final String code;
  final DateTime sessionDate;

  final TicketStatus status;
  final String ticketType;
  final String? qrCodeUrl;

  const TicketModel({
    required this.ticketId,
    required this.usuarioId,
    required this.movieTitle,
    required this.sessionTime,
    required this.code,
    required this.sessionDate,
    required this.status,
    required this.ticketType,
    this.qrCodeUrl,
  });

  // ============================================
  // 1. ENVIO PARA O FIRESTORE
  // ============================================
  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'movieTitle': movieTitle,
      'sessionTime': sessionTime,
      'codigoCompra': code,
      'dataSessao': Timestamp.fromDate(sessionDate),
      'statusAprovacao': status == TicketStatus.approved
          ? 'Aprovado'
          : status == TicketStatus.rejected
          ? 'Rejeitado'
          : 'Pendente',
      'tipoReserva': ticketType,
      'qrCodeUrl': qrCodeUrl ?? 'N/A',
      'dataCriacao': FieldValue.serverTimestamp(),
    };
  }

  // ============================================
  // 2. LEITURA DO FIRESTORE
  // ============================================
  factory TicketModel.fromMap(Map<String, dynamic> data, String documentId) {
    return TicketModel(
      ticketId: documentId,
      usuarioId: data['usuarioId'] ?? '',
      movieTitle: data['movieTitle'] ?? '',
      sessionTime: data['sessionTime'] ?? '',
      code: data['codigoCompra'] ?? '',
      sessionDate: (data['dataSessao'] is Timestamp)
          ? (data['dataSessao'] as Timestamp).toDate()
          : DateTime.now(),
      status: _mapStatus(data['statusAprovacao']),
      ticketType: data['tipoReserva'] ?? 'Reserva Normal',
      qrCodeUrl: data['qrCodeUrl'],
    );
  }

  // ============================================
  // 3. MAPEAMENTO ROBUSTO DE STATUS 🔥
  // ============================================
  static TicketStatus _mapStatus(String? status) {
    if (status == null) return TicketStatus.pending;

    final normalized = status.trim().toLowerCase();

    switch (normalized) {
      case 'aprovado':
      case 'approved':
        return TicketStatus.approved;

      case 'rejeitado':
      case 'rejected':
        return TicketStatus.rejected;

      case 'pendente':
      case 'pending':
      default:
        return TicketStatus.pending;
    }
  }
}
