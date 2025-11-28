import 'package:cine_passe_app/features/services/payment_service.dart';
import 'package:cine_passe_app/features/services/plan_service.dart';
import 'package:cine_passe_app/models/plan_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ✅ Certifique-se de ter criado este arquivo

class PlanController with ChangeNotifier {
  // Dependências
  final PlanService _planService = PlanService();
  final PaymentService _paymentService = PaymentService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Estado
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // -------------------------------------------------------------------
  // LÓGICA DE PAGAMENTO + ASSINATURA (Métodos que faltavam)
  // -------------------------------------------------------------------

  /// Processa pagamento via Cartão de Crédito e, se aprovado, assina o plano.
  Future<bool> payWithCardAndSubscribe(
    PlanModel plan, {
    required String cardNumber,
    required String name,
    required String date,
    required String cvv,
  }) async {
    // 1. Validação básica de campos
    if (cardNumber.isEmpty || name.isEmpty || date.isEmpty || cvv.isEmpty) {
      _errorMessage = "Por favor, preencha todos os dados do cartão.";
      notifyListeners();
      return false;
    }

    return _handleTransaction(() async {
      // 2. Chama o serviço de pagamento (Gateway)
      await _paymentService.processCreditCard(
        cardNumber: cardNumber,
        holderName: name,
        expiryDate: date,
        cvv: cvv,
        amount: plan.preco,
      );

      // 3. Se o pagamento não lançar exceção, processa a assinatura no banco
      await _subscribeToPlan(plan);
    });
  }

  /// Processa pagamento via Pix e, se confirmado, assina o plano.
  Future<bool> payWithPixAndSubscribe(PlanModel plan) async {
    return _handleTransaction(() async {
      // 1. Verifica pagamento Pix (Mock)
      await _paymentService.verifyPixPayment("codigo_pix_mock");

      // 2. Processa a assinatura no banco
      await _subscribeToPlan(plan);
    });
  }

  // -------------------------------------------------------------------
  // MÉTODOS INTERNOS
  // -------------------------------------------------------------------

  /// Atualiza o documento do usuário no Firestore com os dados do plano
  Future<void> _subscribeToPlan(PlanModel plan) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Usuário não autenticado.");

    // Chama o serviço que grava no Firestore (users collection)
    await _planService.subscribeToPlan(user.uid, plan);
  }

  /// Wrapper genérico para gerenciar estado de Loading e Erros
  Future<bool> _handleTransaction(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // Executa a lógica passada (Pagamento + Assinatura)
      await action();

      _successMessage = "Assinatura realizada com sucesso! Aproveite.";
      return true;
    } catch (e) {
      // Remove "Exception: " da mensagem de erro para ficar mais limpo na UI
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpa as mensagens de feedback (útil ao sair da tela ou fechar snackbar)
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
