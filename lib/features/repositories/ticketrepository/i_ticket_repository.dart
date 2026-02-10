import 'package:cine_passe_app/models/ticket_model.dart';

abstract class ITicketRepository {
  
  Future<void> createTicket(TicketModel ticket);

  
  Stream<List<TicketModel>> getUserTicketsStream(String userId);
}