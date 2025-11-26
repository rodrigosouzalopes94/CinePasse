import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    // Cores dinâmicas baseadas no tema
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Mapeamento das classes CSS: .login-input / .review-textarea
    final Color fillColor = isDarkMode ? const Color(0xFF333333) : const Color(0xFFE5E7EB); // #333 ou #e5e7eb
    final Color borderColor = isDarkMode ? const Color(0xFF444444) : const Color(0xFFD1D5DB); // #444 ou #d1d5db
    final Color textColor = isDarkMode ? const Color(0xFFF5F5F5) : const Color(0xFF111827); // #F5F5F5 ou #111827
    final Color labelColor = isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280); // Cor cinza padrão para o label

    return TextFormField(
      initialValue: initialValue,
      controller: null, // Pode ser adicionado se precisar de um controlador externo
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: isPassword,

      style: TextStyle(color: textColor), // Cor do texto digitado

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: labelColor), // Cor do label
        prefixIcon: icon != null ? Icon(icon, color: labelColor) : null,

        // Estilo do Fundo e Borda
        filled: true,
        fillColor: fillColor,

        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: borderColor),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: borderColor), // Borda no estado normal
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary, // Borda primária quando focado
            width: 2.0,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),

        // Cor do placeholder/hint text
        hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.7)),
      ),
    );
  }
}