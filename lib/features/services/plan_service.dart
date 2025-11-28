import 'package:cine_passe_app/models/plan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Assinar um plano (Atualiza o documento do usuário)
  Future<void> subscribeToPlan(String userId, PlanModel plan) async {
    try {
      // Calcula a data de vencimento (30 dias a partir de hoje)
      final DateTime validUntil = DateTime.now().add(const Duration(days: 30));

      await _firestore.collection('users').doc(userId).update({
        'planoAtual': plan.nome, // 'Passe Premium' ou 'Família'
        'planoId': plan.id,
        'planoVenceEm': Timestamp.fromDate(validUntil),
        'membrosFamilia': plan.maxMembros,
        'dataAtualizacao': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao processar assinatura: $e');
    }
  }
}
