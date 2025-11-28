import 'package:flutter/material.dart';
import 'package:cine_passe_app/widgets/custom_text_field.dart';

class CreditCardForm extends StatelessWidget {
  final TextEditingController numberCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController expiryCtrl;
  final TextEditingController cvvCtrl;

  const CreditCardForm({
    super.key,
    required this.numberCtrl,
    required this.nameCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Número do Cartão',
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
          validator: (v) =>
              (v == null || v.length < 16) ? 'Número inválido' : null,
          onChanged: (v) => numberCtrl.text = v,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Nome no Cartão',
          icon: Icons.person,
          validator: (v) =>
              (v == null || v.isEmpty) ? 'Nome obrigatório' : null,
          onChanged: (v) => nameCtrl.text = v,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Validade (MM/AA)',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.datetime,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Obrigatório' : null,
                onChanged: (v) => expiryCtrl.text = v,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'CVV',
                icon: Icons.lock,
                keyboardType: TextInputType.number,
                isPassword: true,
                validator: (v) =>
                    (v == null || v.length < 3) ? 'Inválido' : null,
                onChanged: (v) => cvvCtrl.text = v,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
