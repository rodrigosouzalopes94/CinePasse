import 'package:cine_passe_app/features/services/ticket_service.dart';
import 'package:cine_passe_app/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; 
import 'package:rxdart/rxdart.dart'; 

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

  
  Future<bool> reserveTicket({
    required String movieTitle,
    required DateTime sessionDate,
    required String sessionTime,
    required String ticketType, 
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
      
      final String code = 'CP-${DateTime.now().millisecondsSinceEpoch}';

      final newTicket = TicketModel(
        ticketId: '', 
        usuarioId: user.uid, 
        movieTitle: movieTitle,
        sessionTime: sessionTime,
        code: code,
        sessionDate: sessionDate,
        status: TicketStatus.pending, 
        ticketType: ticketType,
      );

      await _service.createTicket(newTicket);

      _successMessage = "Reserva enviada com sucesso! Aguardando aprovação.";

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      
      setErrorMessage("Erro ao reservar: ${e.toString()}");
      return false;
    }
  }

  
  
  

  
  Stream<List<TicketModel>> get allUserTicketsStream {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();
    return _service.getUserTicketsStream(userId);
  }

  
  Stream<List<TicketModel>> get approvedTicketsStream {
    
    return allUserTicketsStream.map((tickets) {
      return tickets.where((t) => t.status == TicketStatus.approved).toList();
    });
  }

  
  Stream<List<TicketModel>> get pendingTicketsStream {
    return allUserTicketsStream.map((tickets) {
      return tickets.where((t) => t.status == TicketStatus.pending).toList();
    });
  }

  
  Stream<List<TicketModel>> get rejectedTicketsStream {
    return allUserTicketsStream.map((tickets) {
      return tickets.where((t) => t.status == TicketStatus.rejected).toList();
    });
  }
}
