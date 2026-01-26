import 'package:cine_passe_app/models/plan_model.dart';
import 'package:cine_passe_app/widgets/plans_widgets.dart';
import 'package:flutter/material.dart';


import 'checkout_page.dart'; 

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                children: [
                  Text(
                    'Escolha o Plano Perfeito',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Descubra todos os benefícios do CINEPASSE e aproveite o cinema como nunca antes.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            
            
            ...PlanModel.list.map(
              (plan) => PlanCard(
                plan: plan,
                isLoading:
                    false, 
                onSubscribe: () {
                  
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(plan: plan),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
            Divider(color: theme.dividerColor.withOpacity(0.5)),
            const SizedBox(height: 32),

            
            Column(
              children: [
                Text(
                  'Perguntas Frequentes',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                const FaqCard(
                  question: 'Posso cancelar a qualquer momento?',
                  answer:
                      'Sim, você pode cancelar seu plano a qualquer momento nas configurações da conta, sem taxas adicionais.',
                ),
                const FaqCard(
                  question: 'Os planos são renovados automaticamente?',
                  answer: 'Sim, a renovação é mensal. Você será avisado antes.',
                ),
                const FaqCard(
                  question: 'Como funciona o limite do Plano Família?',
                  answer:
                      'O titular pode convidar até 3 membros. Todos compartilham os benefícios, mas cada um tem sua conta.',
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
