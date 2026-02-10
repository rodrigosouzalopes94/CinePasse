import 'package:cine_passe_app/features/repositories/ticketrepository/i_ticket_repository.dart';
import 'package:flutter/material.dart';
import 'package:cine_passe_app/models/ticket_model.dart';

class TicketViewModel with ChangeNotifier {
  final ITicketRepository _repository;

  TicketViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Fluxo de Reserva com integração de lógica de negócio
  Future<bool> reserveTicket({
    required String userId,
    required String movieTitle,
    required DateTime sessionDate,
    required String sessionTime,
    required String ticketType,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final String code = 'CP-${DateTime.now().millisecondsSinceEpoch}';

      final newTicket = TicketModel(
        ticketId: '', 
        usuarioId: userId,
        movieTitle: movieTitle,
        sessionTime: sessionTime,
        code: code,
        sessionDate: sessionDate,
        status: TicketStatus.pending,
        ticketType: ticketType,
      );

      await _repository.createTicket(newTicket);
      
      _successMessage = "Reserva enviada com sucesso! Aguarde a aprovação.";
      return true;
    } catch (e) {
      _errorMessage = "Erro ao processar reserva. Tente novamente.";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Stream<List<TicketModel>> getTicketsByStatus(String userId, TicketStatus status) {
    return _repository.getUserTicketsStream(userId).map((tickets) {
      return tickets.where((t) => t.status == status).toList();
    });
  }
}