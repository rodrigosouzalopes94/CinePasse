import 'package:cine_passe_app/features/services/payment_service.dart';
import 'package:cine_passe_app/features/services/plan_service.dart';
import 'package:cine_passe_app/models/plan_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentController with ChangeNotifier {
  
  
  
  final PaymentService _paymentService = PaymentService();
  final PlanService _planService = PlanService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  
  
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  
  
  

  
  Future<bool> payWithCardAndSubscribe(
    PlanModel plan, {
    required String cardNumber,
    required String name,
    required String date,
    required String cvv,
  }) async {
    
    if (cardNumber.isEmpty || name.isEmpty || date.isEmpty || cvv.isEmpty) {
      _errorMessage = "Por favor, preencha todos os dados do cartão.";
      notifyListeners();
      return false;
    }

    
    return _handleTransaction(() async {
      
      await _paymentService.processCreditCard(
        cardNumber: cardNumber,
        holderName: name,
        expiryDate: date,
        cvv: cvv,
        amount: plan.preco,
      );

      
      await _subscribeToPlan(plan);
    });
  }

  
  Future<bool> payWithPixAndSubscribe(PlanModel plan) async {
    return _handleTransaction(() async {
      
      await _paymentService.verifyPixPayment("codigo_pix_mock");

      
      await _subscribeToPlan(plan);
    });
  }

  
  
  

  
  Future<void> _subscribeToPlan(PlanModel plan) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Usuário não autenticado. Faça login novamente.");
    }

    
    await _planService.subscribeToPlan(user.uid, plan);
  }

  
  Future<bool> _handleTransaction(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await action();
      _successMessage = "Pagamento aprovado! Assinatura ativa.";
      return true;
    } catch (e) {
      
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
