import 'package:cine_passe_app/features/services/ticket_service.dart';
import 'package:cine_passe_app/models/ticket_model.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class TicketController with ChangeNotifier {
  final TicketService _service = TicketService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para criar uma reserva (chamado quando clica em "Reservar" no filme)
  Future<bool> reserveTicket({
    required String movieTitle,
    required DateTime sessionDate,
    required String sessionTime,
    required String ticketType, // 'Reserva Normal' ou 'Plano Assinatura'
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      _errorMessage = "Usuário não autenticado.";
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
        ticketId: '', // O Firestore gera o ID
        usuarioId: user.uid,
        movieTitle: movieTitle,
        sessionTime: sessionTime,
        code: code,
        sessionDate: sessionDate,
        status:
            TicketStatus.pending, // Sempre começa Pendente (Regra de Negócio)
        ticketType: ticketType,
      );

      await _service.createTicket(newTicket);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Erro ao reservar: $e";
      notifyListeners();
      return false;
    }
  }

  // Método para pegar a Stream de tickets do usuário atual
  Stream<List<TicketModel>> get myTicketsStream {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();
    return _service.getUserTicketsStream(userId);
  }
}
