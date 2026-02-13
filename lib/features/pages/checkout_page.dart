import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'package:cine_passe_app/features/controllers/payment_viewmodel.dart';
import 'package:cine_passe_app/features/controllers/auth_viewmodel.dart';


import 'package:cine_passe_app/models/plan_model.dart';
import 'package:cine_passe_app/widgets/credit_card_forn.dart';
import 'package:cine_passe_app/widgets/custom_button.dart';
import 'package:cine_passe_app/widgets/payment_method_card.dart';
import 'package:cine_passe_app/widgets/pix_payment_area.dart';
import 'package:cine_passe_app/widgets/plan_summary_card.dart';

enum PaymentMethod { creditCard, pix }

class CheckoutPage extends StatefulWidget {
  final PlanModel? plan;
  final double? manualAmount;

  const CheckoutPage({
    super.key, 
    this.plan, 
    this.manualAmount,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod _selectedMethod = PaymentMethod.creditCard;
  final _formKey = GlobalKey<FormState>();

 
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
    final paymentVM = context.watch<PaymentViewModel>();

   
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    final double totalAmount = args?['amount'] ?? widget.plan?.preco ?? widget.manualAmount ?? 0.0;
    final PlanModel? currentPlan = args?['plan'] ?? widget.plan;
    final bool isSubscription = currentPlan != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isSubscription ? 'Assinar Plano' : 'Pagamento de Ingresso'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              if (isSubscription)
                PlanCheckoutSummary(plan: currentPlan!)
              else
                _buildTicketSummary(theme, totalAmount),

              const SizedBox(height: 32),
              Text('Forma de Pagamento', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: PaymentMethodCard(
                      label: 'Cartão',
                      icon: FontAwesomeIcons.creditCard,
                      isSelected: _selectedMethod == PaymentMethod.creditCard,
                      onTap: () => setState(() => _selectedMethod = PaymentMethod.creditCard),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PaymentMethodCard(
                      label: 'Pix',
                      icon: FontAwesomeIcons.pix,
                      isSelected: _selectedMethod == PaymentMethod.pix,
                      onTap: () => setState(() => _selectedMethod = PaymentMethod.pix),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              
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

              CustomButton(
                text: _selectedMethod == PaymentMethod.creditCard
                    ? 'PAGAR R\$ ${totalAmount.toStringAsFixed(2).replaceAll('.', ',')}'
                    : 'CONFIRMAR PAGAMENTO PIX',
                isLoading: paymentVM.isLoading, 
                onPressed: () => _handlePayment(context, isSubscription, currentPlan, totalAmount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketSummary(ThemeData theme, double amount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.ticket, color: theme.primaryColor),
          const SizedBox(width: 16),
          const Expanded(child: Text('Ingresso Avulso CinePasse', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          Text('R\$ ${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }

  Future<void> _handlePayment(BuildContext context, bool isSub, PlanModel? plan, double amount) async {
    final paymentVM = context.read<PaymentViewModel>();
    final authVM = context.read<AuthViewModel>();
    
    
    final String? userId = authVM.userProfile?.uid;

    if (userId == null) {
      _showFeedback(context, 'Usuário não identificado. Faça login novamente.', Colors.red);
      return;
    }
    
    

    bool success = false;
    final cardData = {
      'number': _numberCtrl.text,
      'name': _nameCtrl.text,
      'date': _expiryCtrl.text,
      'cvv': _cvvCtrl.text,
    };

    if (_selectedMethod == PaymentMethod.creditCard) {
      if (!_formKey.currentState!.validate()) return;
      
      if (isSub) {
        
        success = await paymentVM.subscribe(userId, plan!, cardData);
      } else {
        success = await paymentVM.paySingleTicket(cardData, amount);
      }
    } else {
      
      success = isSub 
          ? await paymentVM.payWithPixAndSubscribe(userId, plan!)
          : await paymentVM.payWithPixAndConfirmTicket(amount);
    }

    if (success && context.mounted) {
      _showFeedback(context, 'Pagamento aprovado!', Colors.green);
      if (!isSub) {
      
        Navigator.of(context).pop(true); 
      } else {
       
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } else if (paymentVM.errorMessage != null && context.mounted) {
      _showFeedback(context, paymentVM.errorMessage!, Colors.red);
    }
  }

  void _showFeedback(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}