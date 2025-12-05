import 'package:cine_passe_app/features/services/ticket_service.dart';
import 'package:cine_passe_app/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class TicketController with ChangeNotifier {
  final TicketService _service = TicketService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

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

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      setErrorMessage("Erro ao reservar: ${e.toString()}");
      return false;
    }
  }

  // -------------------------------------------------------------------
  // LÓGICA DE STREAMS DE FILTRAGEM (Validação da Lógica de Exibição)
  // -------------------------------------------------------------------

  // 1. Stream Base: Retorna TODOS os tickets do usuário (Base para filtros)
  // Este é o método que executa a QUERY com o índice composto.
  Stream<List<TicketModel>> get allUserTicketsStream {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();
    return _service.getUserTicketsStream(userId);
  }

  // 2. 🚀 LISTA APROVADA: Retorna APENAS tickets APROVADOS (Voucher Válido)
  // Use este getter na TicketsPage para ver os bilhetes liberados.
  Stream<List<TicketModel>> get approvedTicketsStream {
    // Usa o .map para processar a lista e filtrar pelo Enum APROVADO
    return allUserTicketsStream.map((tickets) {
      return tickets.where((t) => t.status == TicketStatus.approved).toList();
    });
  }

  // 3. LISTA DE PENDENTES (Para a aba de revisão)
  Stream<List<TicketModel>> get pendingTicketsStream {
    return allUserTicketsStream.map((tickets) {
      return tickets.where((t) => t.status == TicketStatus.pending).toList();
    });
  }
}
