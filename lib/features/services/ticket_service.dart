import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cine_passe_app/models/ticket_model.dart';

class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TicketService() {
    // 🔥 Desabilita o cache do Firestore para evitar dados antigos
    _firestore.settings = const Settings(persistenceEnabled: false);
  }

  // =====================================================
  // 1. Criar um ticket no Firestore
  // =====================================================
  Future<void> createTicket(TicketModel ticket) async {
    try {
      print("📌 Criando ticket...");
      await _firestore.collection('tickets').add(ticket.toMap());
      print("✅ Ticket criado com sucesso!");
    } catch (e) {
      print("❌ ERRO ao criar ticket: $e");
      rethrow;
    }
  }

  // =====================================================
  // 2. Stream de tickets do usuário (Tempo Real)
  // =====================================================
  Stream<List<TicketModel>> getUserTicketsStream(String userId) {
    print("📡 Iniciando stream de tickets do usuário: $userId");

    return _firestore
        .collection('tickets')
        .where('usuarioId', isEqualTo: userId)
        .orderBy('dataCriacao', descending: true)
        .snapshots()
        .map((snapshot) {
          print("🔄 Atualização recebida! Total: ${snapshot.docs.length} docs");

          return snapshot.docs.map((doc) {
            final data = doc.data();

            print("📝 Ticket recebido:");
            print("   ➤ ID: ${doc.id}");
            print("   ➤ Status: ${data['statusAprovacao']}");
            print("   ➤ Código: ${data['codigoCompra']}");
            print("--------------------------------------");

            return TicketModel.fromMap(data, doc.id);
          }).toList();
        })
        .handleError((error) {
          print("❌ ERRO NA STREAM de tickets: $error");
        });
  }
}
