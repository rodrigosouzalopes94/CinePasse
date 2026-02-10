import 'dart:math';

class PaymentService {
  Future<bool> processCreditCard({
    required String cardNumber,
    required String holderName,
    required String expiryDate,
    required String cvv,
    required double amount,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    if (cardNumber.endsWith('0000')) {
      throw Exception('Cartão recusado pela operadora.');
    }

    return true;
  }

  Future<bool> verifyPixPayment(String pixCode) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
