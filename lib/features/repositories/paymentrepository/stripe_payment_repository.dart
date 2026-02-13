import 'package:cine_passe_app/features/repositories/paymentrepository/i_payment_repository.dart';

class StripePaymentRepository implements IPaymentRepository {
  
  @override
  Future<void> processCreditCard({
    required double amount,
    required String cardNumber,
    required String holderName,
    required String expiryDate,
    required String cvv,
  }) async {
   
    await Future.delayed(const Duration(seconds: 2));

   
    if (cardNumber.endsWith('0000')) {
      throw Exception('Cartão recusado: Saldo insuficiente.');
    }

    if (!cardNumber.endsWith('4242')) {
      throw Exception('Ambiente de Teste: Use um cartão terminado em 4242.');
    }

    print("Sucesso: R\$ $amount cobrados via Stripe no cartão $cardNumber");
  }

  @override
  Future<String> generatePixPayment(double amount) async {
    // Simulação de geração de Payload de Pix (Copia e Cola)
    await Future.delayed(const Duration(seconds: 1));
    
    // Retorna um código Mock de Pix
    return "00020126360014BR.GOV.BCB.PIX0114+55419999999995204000053039865405${amount.toStringAsFixed(2)}5802BR5913CINEPASSEAPP6008CURITIBA62070503***6304E2CA";
  }
}