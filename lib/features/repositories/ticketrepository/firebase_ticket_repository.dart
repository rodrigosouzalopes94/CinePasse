import 'package:cine_passe_app/features/repositories/ticketrepository/i_ticket_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cine_passe_app/models/ticket_model.dart';

class FirebaseTicketRepository implements ITicketRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createTicket(TicketModel ticket) async {
    await _firestore.collection('tickets').add(ticket.toMap());
  }

  @override
  Stream<List<TicketModel>> getUserTicketsStream(String userId) {
    return _firestore
        .collection('tickets')
        .where('usuarioId', isEqualTo: userId)
        .orderBy('dataCriacao', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TicketModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}