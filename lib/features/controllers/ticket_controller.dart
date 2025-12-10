import 'package:cine_passe_app/features/services/ticket_service.dart';
import 'package:cine_passe_app/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // ✅ Import de pacote externo
import 'package:rxdart/rxdart.dart'; // ✅ Import de pacote externo

class TicketController with ChangeNotifier {
  final TicketService _service = TicketService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void setErrorMessage(String? message) {
    _errorMessage = message;
    _successMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // 1. Método para criar uma reserva (chamado pela ReservationModal)
  Future<bool> reserveTicket({
    required String movieTitle,
    required DateTime sessionDate,
    required String sessionTime,
    required String ticketType, // 'Reserva Normal' ou 'Plano Assinatura'
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      setErrorMessage("Usuário não autenticado. Faça login novamente.");
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // Gera um código de ticket simples (ex: CP-TIMESTAMP)
      final String code = 'CP-${DateTime.now().millisecondsSinceEpoch}';

      final newTicket = TicketModel(
        ticketId: '', // O Firestore gera o ID
        usuarioId: user.uid, // CRÍTICO: Passando o UID do usuário logado
        movieTitle: movieTitle,
        sessionTime: sessionTime,
        code: code,
        sessionDate: sessionDate,
        status: TicketStatus.pending, // Sempre Pendente para aprovação do Admin
        ticketType: ticketType,
      );

      await _service.createTicket(newTicket);

      _successMessage = "Reserva enviada com sucesso! Aguardando aprovação.";

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      // 🎯 Aqui, removemos a dependência do tipo de exceção (para o caso de conflito)
      setErrorMessage("Erro ao reservar: ${e.toString()}");
      return false;
    }
  }

  // -------------------------------------------------------------------
  // 2. STREAMS DE FILTRAGEM (Lógica de Exibição)
  // -------------------------------------------------------------------

  // Stream Base: Retorna TODOS os tickets do usuário
  Stream<List<TicketModel>> get allUserTicketsStream {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();
    return _service.getUserTicketsStream(userId);
  }

  // Lista Aprovada: Retorna APENAS tickets APROVADOS (Voucher Válido)
  Stream<List<TicketModel>> get approvedTicketsStream {
    // 🎯 O Dart consegue fazer .map em streams nativas se a dependência do rxdart for resolvida
    return allUserTicketsStream.map((tickets) {
      return tickets.where((t) => t.status == TicketStatus.approved).toList();
    });
  }

  // Lista de Pendentes (Para o histórico ou aba de revisão)
  Stream<List<TicketModel>> get pendingTicketsStream {
    return allUserTicketsStream.map((tickets) {
      return tickets.where((t) => t.status == TicketStatus.pending).toList();
    });
  }

  // Lista de Rejeitados (Para o histórico)
  Stream<List<TicketModel>> get rejectedTicketsStream {
    return allUserTicketsStream.map((tickets) {
      return tickets.where((t) => t.status == TicketStatus.rejected).toList();
    });
  }
}
