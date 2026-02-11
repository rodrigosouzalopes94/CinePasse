import 'package:cine_passe_app/models/plan_model.dart';

abstract class IPlanRepository {
  
  Future<void> subscribeToPlan(String userId, PlanModel plan);

  
  Future<List<PlanModel>> getAvailablePlans();
  
  Future<void> cancelSubscription(String userId);
}