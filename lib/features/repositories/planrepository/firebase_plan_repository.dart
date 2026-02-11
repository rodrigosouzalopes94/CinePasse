import 'package:cine_passe_app/features/repositories/planrepository/i_plan_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cine_passe_app/models/plan_model.dart';

class FirebasePlanRepository implements IPlanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

@override
Future<void> subscribeToPlan(String userId, PlanModel plan) async {
  await _firestore.collection('usuarios').doc(userId).set({
    'planoAtual': plan.nome,
    'planoId': plan.id, 
    'limiteMembros': plan.maxMembros,
    'dataAssinatura': FieldValue.serverTimestamp(),
    'statusPlano': 'Ativo',
  }, SetOptions(merge: true));
}

  @override
  Future<List<PlanModel>> getAvailablePlans() async {
    final snapshot = await _firestore.collection('planos').orderBy('preco').get();
    return snapshot.docs.map((doc) => PlanModel.fromMap(doc.data())).toList();
  }

  @override
  Future<void> cancelSubscription(String userId) async {
    await _firestore.collection('usuarios').doc(userId).update({
      'planoAtual': 'Nenhum',
      'statusPlano': 'Cancelado',
    });
  }
}