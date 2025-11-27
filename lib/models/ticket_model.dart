import 'package:cloud_firestore/cloud_firestore.dart';

enum TicketStatus { pending, approved, rejected }

class TicketModel {
  final String ticketId;
  final String usuarioId; // ✅ Adicionado (era o erro do controller)

  final String movieTitle;
  final String sessionTime;
  final String code;
  final DateTime sessionDate;

  final TicketStatus status;
  final String ticketType;
  final String? qrCodeUrl;

  const TicketModel({
    required this.ticketId,
    required this.usuarioId, // ✅ Obrigatório no construtor
    required this.movieTitle,
    required this.sessionTime,
    required this.code,
    required this.sessionDate,
    required this.status,
    required this.ticketType,
    this.qrCodeUrl,
  });

  // ✅ Método fromMap (Corrige o erro "Member not found: 'TicketModel.fromMap'")
  factory TicketModel.fromMap(Map<String, dynamic> data, String documentId) {
    return TicketModel(
      ticketId: documentId,
      usuarioId: data['usuarioId'] ?? '',
      movieTitle: data['movieTitle'] ?? '',
      sessionTime: data['sessionTime'] ?? '',
      code: data['codigoCompra'] ?? '',
      // Tratamento seguro para data
      sessionDate: (data['dataSessao'] is Timestamp)
          ? (data['dataSessao'] as Timestamp).toDate()
          : DateTime.now(),
      status: _mapStatus(data['statusAprovacao']),
      ticketType: data['tipoReserva'] ?? 'Reserva Normal',
      qrCodeUrl: data['qrCodeUrl'],
    );
  }

  // ✅ Método toMap (Corrige o erro "The method 'toMap' isn't defined")
  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'movieTitle': movieTitle,
      'sessionTime': sessionTime,
      'codigoCompra': code,
      'dataSessao': Timestamp.fromDate(sessionDate),
      'statusAprovacao': status.name, // Salva como 'pending', etc.
      'tipoReserva': ticketType,
      'qrCodeUrl': qrCodeUrl,
      'dataCriacao': FieldValue.serverTimestamp(),
    };
  }

  static TicketStatus _mapStatus(String? status) {
    switch (status) {
      case 'approved':
        return TicketStatus.approved;
      case 'rejected':
        return TicketStatus.rejected;
      default:
        return TicketStatus.pending;
    }
  }
}
