// lib/widgets/custom_button.dart

import 'package:flutter/material.dart';
import 'package:cine_passe_app/core/constants/colors_constants.dart'; // Suas cores

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // 1. SizedBox com double.infinity para forçar a largura máxima
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          // 2. Gradiente (efeito glow de fundo)
          gradient: const LinearGradient(
            colors: [kPrimaryColor, kPrimaryDarkColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          // 3. Efeito box-shadow/glow
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          // 4. Desabilita o botão se estiver carregando
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            // 5. Transparente para que o Container (com o gradiente) apareça
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            foregroundColor: Colors.white,
            // Cor para quando o botão estiver desabilitado (ex: durante o loading)
            disabledBackgroundColor: kPrimaryColor.withValues(alpha: 0.5),
          ),
          child: isLoading
          // 6. Indicador de progresso se estiver carregando
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
          // 7. Texto normal do botão
              : Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}