import 'package:cine_passe_app/features/services/ticket_service.dart';
import 'package:cine_passe_app/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart'; // ✅ OBRIGATÓRIO: Permite usar .map em Streams (instale com flutter pub add rxdart)

class TicketController with ChangeNotifier {
  final TicketService _service = TicketService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método auxiliar para setar o erro publicamente (usado pelo ReservationController)
  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Método para criar uma reserva (chamado quando clica em "Reservar" no filme)
  Future<bool> reserveTicket({
    required String movieTitle,
    required DateTime sessionDate,
    required String sessionTime,
    required String ticketType, // 'Reserva Normal' ou 'Plano Assinatura'
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      _errorMessage = "Usuário não autenticado. Faça login novamente.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Gera um código simples de compra (Ex: CP-TIMESTAMP)
      final String code = 'CP-${DateTime.now().millisecondsSinceEpoch}';

      final newTicket = TicketModel(
        ticketId: '',
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
      // Captura o erro do Service (que vem formatado)
      _isLoading = false;
      _errorMessage = "Erro ao reservar: ${e.toString()}";
      notifyListeners();
      return false;
    }
  }

  // -------------------------------------------------------------------
  // LÓGICA DE STREAMS DE FILTRAGEM (Validação da Regra de Negócio)
  // -------------------------------------------------------------------

  // 1. Stream Base: Retorna TODOS os tickets do Firestore
  Stream<List<TicketModel>> get allUserTicketsStream {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();
    return _service.getUserTicketsStream(userId);
  }

  // 2. 🚀 LISTA PRINCIPAL: Retorna APENAS tickets APROVADOS
  // Esta Stream deve ser usada na TicketsPage quando o usuário quiser ver o voucher
  Stream<List<TicketModel>> get approvedTicketsStream {
    // Usamos o .map para processar a lista e filtrar localmente no lado do App
    return allUserTicketsStream.map((tickets) {
      return tickets.where((t) => t.status == TicketStatus.approved).toList();
    });
  }

  // 3. LISTA DE PENDENTES (Para a aba "Aguardando Aprovação")
  Stream<List<TicketModel>> get pendingTicketsStream {
    return allUserTicketsStream.map((tickets) {
      return tickets.where((t) => t.status == TicketStatus.pending).toList();
    });
  }

  // 4. LISTA DE REJEITADOS (Para o histórico)
  Stream<List<TicketModel>> get rejectedTicketsStream {
    return allUserTicketsStream.map((tickets) {
      return tickets.where((t) => t.status == TicketStatus.rejected).toList();
    });
  }
}
