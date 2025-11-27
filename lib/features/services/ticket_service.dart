import 'package:cine_passe_app/models/ticket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Criar um novo Ticket (Reserva)
  Future<void> createTicket(TicketModel ticket) async {
    // Usamos o .doc() para gerar um ID automático ou usamos o ID do ticket se já existir
    await _firestore.collection('tickets').add(ticket.toMap());
  }

  // 2. Escutar os Tickets de um Usuário (Stream em Tempo Real)
  Stream<List<TicketModel>> getUserTicketsStream(String userId) {
    return _firestore
        .collection('tickets')
        .where('usuarioId', isEqualTo: userId)
        .orderBy('dataCriacao', descending: true) // Mais recentes primeiro
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TicketModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }
}
