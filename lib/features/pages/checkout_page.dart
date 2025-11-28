import 'package:cine_passe_app/features/controllers/plan_controller.dart';
import 'package:cine_passe_app/models/plan_model.dart';
import 'package:cine_passe_app/widgets/credit_card_forn.dart';
import 'package:cine_passe_app/widgets/custom_button.dart';
import 'package:cine_passe_app/widgets/payment_method_card.dart';
import 'package:cine_passe_app/widgets/pix_payment_area.dart';
import 'package:cine_passe_app/widgets/plan_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

enum PaymentMethod { creditCard, pix }

class CheckoutPage extends StatefulWidget {
  final PlanModel plan;

  const CheckoutPage({super.key, required this.plan});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod _selectedMethod = PaymentMethod.creditCard;
  final _formKey = GlobalKey<FormState>();

  // Controllers para os campos do cartão
  final _numberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _numberCtrl.dispose();
    _nameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final planController = context.watch<PlanController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Resumo do Pedido (Nome da classe corrigido: PlanCheckoutSummary)
              PlanCheckoutSummary(plan: widget.plan),

              const SizedBox(height: 32),

              // 2. Título Método
              Text(
                'Forma de Pagamento',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 3. Seleção de Método
              Row(
                children: [
                  Expanded(
                    child: PaymentMethodCard(
                      label: 'Cartão',
                      icon: FontAwesomeIcons.creditCard,
                      isSelected: _selectedMethod == PaymentMethod.creditCard,
                      onTap: () => setState(
                        () => _selectedMethod = PaymentMethod.creditCard,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PaymentMethodCard(
                      label: 'Pix',
                      icon: FontAwesomeIcons.pix,
                      isSelected: _selectedMethod == PaymentMethod.pix,
                      onTap: () =>
                          setState(() => _selectedMethod = PaymentMethod.pix),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 4. Área Dinâmica (Formulário ou Pix)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedMethod == PaymentMethod.creditCard
                    ? CreditCardForm(
                        key: const ValueKey('card'),
                        numberCtrl: _numberCtrl,
                        nameCtrl: _nameCtrl,
                        expiryCtrl: _expiryCtrl,
                        cvvCtrl: _cvvCtrl,
                      )
                    : const PixPaymentArea(key: ValueKey('pix')),
              ),

              const SizedBox(height: 40),

              // 5. Botão Finalizar
              CustomButton(
                text: _selectedMethod == PaymentMethod.creditCard
                    ? 'PAGAR R\$ ${widget.plan.preco.toStringAsFixed(2).replaceAll('.', ',')}'
                    : 'JÁ FIZ O PIX',
                isLoading: planController.isLoading,
                onPressed: () => _handlePayment(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePayment(BuildContext context) async {
    final controller = context.read<PlanController>();
    bool success = false;

    if (_selectedMethod == PaymentMethod.creditCard) {
      if (!_formKey.currentState!.validate()) return;

      success = await controller.payWithCardAndSubscribe(
        widget.plan,
        cardNumber: _numberCtrl.text,
        name: _nameCtrl.text,
        date: _expiryCtrl.text,
        cvv: _cvvCtrl.text,
      );
    } else {
      success = await controller.payWithPixAndSubscribe(widget.plan);
    }

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Assinatura Confirmada!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (controller.errorMessage != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
