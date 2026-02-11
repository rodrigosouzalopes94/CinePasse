import 'package:flutter/material.dart';
import 'package:cine_passe_app/core/mixins/checkout_handler_mixin.dart';
import 'package:cine_passe_app/models/plan_model.dart';
import 'package:cine_passe_app/features/repositories/planrepository/i_plan_repository.dart'; 
import 'package:cine_passe_app/features/services/payment_service.dart';

class PaymentViewModel with ChangeNotifier, CheckoutHandlerMixin {
  final PaymentService _paymentService;
  final IPlanRepository _planRepository;

  PaymentViewModel({
    required PaymentService paymentService,
    required IPlanRepository planRepository,
  })  : _paymentService = paymentService,
        _planRepository = planRepository;

 
  Future<bool> payWithCardAndSubscribe(
    PlanModel plan, {
    required String uid,
    required String cardNumber,
    required String name,
    required String date,
    required String cvv,
  }) async {
    if (cardNumber.isEmpty || name.isEmpty || date.isEmpty || cvv.isEmpty) {
      return false; 
    }

    
    return performCheckoutAction(
      successMsg: "Assinatura aprovada! Bem-vindo ao ${plan.nome}.",
      action: () async {
        
        await _paymentService.processCreditCard(
          cardNumber: cardNumber,
          holderName: name,
          expiryDate: date,
          cvv: cvv,
          amount: plan.preco,
        );

        await _planRepository.subscribeToPlan(uid, plan);
      },
    );
  }

 
  Future<bool> payWithPixAndSubscribe(String uid, PlanModel plan) async {
    return performCheckoutAction(
      successMsg: "Pagamento Pix confirmado!",
      action: () async {
        await _paymentService.verifyPixPayment("codigo_pix_mock");
        await _planRepository.subscribeToPlan(uid, plan);
      },
    );
  }
}