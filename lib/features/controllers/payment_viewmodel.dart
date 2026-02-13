import 'package:cine_passe_app/features/repositories/paymentrepository/i_payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:cine_passe_app/core/mixins/checkout_handler_mixin.dart';
import 'package:cine_passe_app/models/plan_model.dart';
import 'package:cine_passe_app/features/repositories/planrepository/i_plan_repository.dart'; 


class PaymentViewModel with ChangeNotifier, CheckoutHandlerMixin {
  final IPaymentRepository _paymentRepo; 
  final IPlanRepository _planRepository;

  PaymentViewModel({
    required IPaymentRepository paymentRepo,
    required IPlanRepository planRepository,
  })  : _paymentRepo = paymentRepo,
        _planRepository = planRepository;

  Future<bool> subscribe(
    String uid, 
    PlanModel plan, 
    Map<String, String> cardData
  ) async {
    
    return performCheckoutAction(
      successMsg: "Assinatura aprovada! Bem-vindo ao ${plan.nome}.",
      action: () async {
       
        await _paymentRepo.processCreditCard(
          cardNumber: cardData['number']!,
          holderName: cardData['name']! ,
          expiryDate: cardData['date']!,
          cvv: cardData['cvv']!,
          amount: plan.preco,
        );

        
        await _planRepository.subscribeToPlan(uid, plan);
      },
    );
  }

 
  Future<bool> paySingleTicket(Map<String, String> cardData, double amount) async {
    return performCheckoutAction(
      successMsg: "Pagamento do ingresso aprovado!",
      action: () async {
       
        await _paymentRepo.processCreditCard(
          cardNumber: cardData['number']!,
          holderName: cardData['name']!,
          expiryDate: cardData['date']!,
          cvv: cardData['cvv']!,
          amount: amount,
        );
        
      },
    );
  }

  
  Future<bool> payWithPixAndSubscribe(String uid, PlanModel plan) async {
    return performCheckoutAction(
      successMsg: "Pagamento Pix confirmado!",
      action: () async {
       
        await _paymentRepo.generatePixPayment(plan.preco);
        await _planRepository.subscribeToPlan(uid, plan);
      },
    );
  }

 
  Future<bool> payWithPixAndConfirmTicket(double amount) async {
    return performCheckoutAction(
      successMsg: "Pix do ingresso confirmado!",
      action: () async {
        await _paymentRepo.generatePixPayment(amount);
      },
    );
  }
}