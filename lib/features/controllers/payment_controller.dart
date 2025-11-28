import 'package:cine_passe_app/features/services/payment_service.dart';
import 'package:cine_passe_app/features/services/plan_service.dart';
import 'package:cine_passe_app/models/plan_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentController with ChangeNotifier {
  // -------------------------------------------------------------------
  // DEPENDÊNCIAS
  // -------------------------------------------------------------------
  final PaymentService _paymentService = PaymentService();
  final PlanService _planService = PlanService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // -------------------------------------------------------------------
  // ESTADO
  // -------------------------------------------------------------------
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // -------------------------------------------------------------------
  // GETTERS
  // -------------------------------------------------------------------
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // -------------------------------------------------------------------
  // AÇÕES DE PAGAMENTO
  // -------------------------------------------------------------------

  /// Processa pagamento via Cartão de Crédito e, se aprovado, realiza a assinatura.
  Future<bool> payWithCardAndSubscribe(
    PlanModel plan, {
    required String cardNumber,
    required String name,
    required String date,
    required String cvv,
  }) async {
    // 1. Validação simples antes de chamar o serviço
    if (cardNumber.isEmpty || name.isEmpty || date.isEmpty || cvv.isEmpty) {
      _errorMessage = "Por favor, preencha todos os dados do cartão.";
      notifyListeners();
      return false;
    }

    // 2. Executa a transação
    return _handleTransaction(() async {
      // Chama o gateway de pagamento (PaymentService)
      await _paymentService.processCreditCard(
        cardNumber: cardNumber,
        holderName: name,
        expiryDate: date,
        cvv: cvv,
        amount: plan.preco,
      );

      // Se passou pelo pagamento sem erro, assina o plano (PlanService)
      await _subscribeToPlan(plan);
    });
  }

  /// Processa pagamento via Pix e, se confirmado, realiza a assinatura.
  Future<bool> payWithPixAndSubscribe(PlanModel plan) async {
    return _handleTransaction(() async {
      // Verifica o Pix (PaymentService)
      await _paymentService.verifyPixPayment("codigo_pix_mock");

      // Assina o plano (PlanService)
      await _subscribeToPlan(plan);
    });
  }

  // -------------------------------------------------------------------
  // MÉTODOS INTERNOS (Lógica de Negócio)
  // -------------------------------------------------------------------

  /// Atualiza o documento do usuário no Firestore com os dados do novo plano
  Future<void> _subscribeToPlan(PlanModel plan) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Usuário não autenticado. Faça login novamente.");
    }

    // Chama o serviço de dados para salvar no Firestore
    await _planService.subscribeToPlan(user.uid, plan);
  }

  /// Wrapper para centralizar o tratamento de erros e estado de loading
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
      // Limpa a mensagem de erro para exibição amigável
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpa mensagens da UI ao sair da tela
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
