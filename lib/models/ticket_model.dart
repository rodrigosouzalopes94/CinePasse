import 'package:cloud_firestore/cloud_firestore.dart';

// Enum para representar o status de aprovação do voucher
enum TicketStatus { pending, approved, rejected }

class TicketModel {
  final String ticketId;
  final String usuarioId; // CRÍTICO: ID do usuário (Auth UID)

  // Informações do Voucher (Lidas do Firestore)
  final String movieTitle;
  final String sessionTime;

  final String code; // Código de compra
  final DateTime sessionDate;

  final TicketStatus status; // Status de Aprovação
  final String ticketType; // Reserva Normal vs Plano Assinatura
  final String? qrCodeUrl;

  // 1. Construtor
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

  // 2. Converte DO App PARA o Firebase (Criação de Ticket)
  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'movieTitle': movieTitle,
      'sessionTime': sessionTime,
      'codigoCompra': code,
      // Salva a data como Timestamp do Firestore
      'dataSessao': Timestamp.fromDate(sessionDate),
      // Converte o Enum para String ('Pendente', 'Aprovado', 'Rejeitado')
      'statusAprovacao': status.name == 'approved'
          ? 'Aprovado'
          : (status.name == 'rejected' ? 'Rejeitado' : 'Pendente'),
      'tipoReserva': ticketType,
      'qrCodeUrl': qrCodeUrl ?? 'N/A',
      'dataCriacao': FieldValue.serverTimestamp(),
    };
  }

  // 3. Converte DO Firebase PARA o App (Leitura de Ticket)
  factory TicketModel.fromMap(Map<String, dynamic> data, String documentId) {
    return TicketModel(
      ticketId: documentId,
      usuarioId: data['usuarioId'] ?? '',
      movieTitle: data['movieTitle'] ?? '',
      sessionTime: data['sessionTime'] ?? '',
      code: data['codigoCompra'] ?? '',
      // Converte o Timestamp do Firestore de volta para DateTime
      sessionDate: (data['dataSessao'] is Timestamp)
          ? (data['dataSessao'] as Timestamp).toDate()
          : DateTime.now(),
      // Converte a String do Firestore de volta para o Enum
      status: _mapStatus(data['statusAprovacao']),
      ticketType: data['tipoReserva'] ?? 'Reserva Normal',
      qrCodeUrl: data['qrCodeUrl'],
    );
  }

  // Helper para conversão de String (Firestore) para Enum (Dart)
  static TicketStatus _mapStatus(String? status) {
    switch (status) {
      case 'Aprovado':
        return TicketStatus.approved;
      case 'Rejeitado':
        return TicketStatus.rejected;
      default:
        return TicketStatus.pending;
    }
  }
}
