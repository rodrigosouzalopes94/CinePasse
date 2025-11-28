import 'dart:math';

// Simula a resposta de um gateway de pagamento
class PaymentService {
  Future<bool> processCreditCard({
    required String cardNumber,
    required String holderName,
    required String expiryDate,
    required String cvv,
    required double amount,
  }) async {
    // Simula delay de rede
    await Future.delayed(const Duration(seconds: 2));

    // Lógica Mock: Se o cartão terminar em '0000', falha. Senão, aprova.
    // Em produção, aqui entraria a chamada HTTP para o Stripe/Pagar.me
    if (cardNumber.endsWith('0000')) {
      throw Exception('Cartão recusado pela operadora.');
    }

    return true; // Pagamento Aprovado
  }

  Future<bool> verifyPixPayment(String pixCode) async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // Pix confirmado
  }
}
