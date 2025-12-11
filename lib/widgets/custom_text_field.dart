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
  // ✅ CORREÇÃO: Adicionado o parâmetro 'readOnly' com valor padrão 'false'
  final bool readOnly; 
  final TextEditingController? controller; // Adicionado controller

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
    // ✅ Tornamos opcional:
    this.readOnly = false, 
    // Adicionado controller para uso na ProfilePage
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Cores dinâmicas baseadas no tema
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Mapeamento das classes CSS: .login-input / .review-textarea
    final Color fillColor = isDarkMode ? const Color(0xFF333333) : const Color(0xFFE5E7EB); 
    final Color borderColor = isDarkMode ? const Color(0xFF444444) : const Color(0xFFD1D5DB);
    final Color textColor = isDarkMode ? const Color(0xFFF5F5F5) : const Color(0xFF111827);
    final Color labelColor = isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    // Corrigindo a cor de fundo se for 'readOnly'
    final effectiveFillColor = readOnly 
        ? (isDarkMode ? const Color(0xFF252525) : const Color(0xFFF3F4F6)) 
        : fillColor;

    return TextFormField(
      initialValue: initialValue,
      // ✅ Usando o controller
      controller: controller, 
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: isPassword,
      // ✅ Usando a nova propriedade
      readOnly: readOnly, 
      
      style: TextStyle(
        color: readOnly ? labelColor : textColor,
        fontWeight: readOnly ? FontWeight.w500 : FontWeight.normal,
      ), 
      
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: icon != null ? Icon(icon, color: labelColor) : null,
        
        // Estilo do Fundo e Borda
        filled: true,
        fillColor: effectiveFillColor, // Usando a cor ajustada
        
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: borderColor),
        ),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: borderColor),
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          // Borda primária quando focado
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary, 
            width: 2.0,
          ),
        ),
        
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),

        // Cor do placeholder/hint text
        hintStyle: TextStyle(color: labelColor.withOpacity(0.7)),
      ),
    );
  }
}