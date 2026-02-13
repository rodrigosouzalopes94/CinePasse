abstract class IPaymentRepository {
  Future<void> processCreditCard({
    required double amount,
    required String cardNumber,
    required String holderName,
    required String expiryDate,
    required String cvv,
  });

  Future<String> generatePixPayment(double amount);
}