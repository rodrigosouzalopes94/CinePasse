// lib/widgets/themed_input_field.dart

import 'package:flutter/material.dart';

class ThemedInputField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;

  const ThemedInputField({
    super.key,
    required this.label,
    this.icon,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Adaptação das cores do seu CSS/Tailwind:
    final fillColor = isDarkMode
        ? const Color(0xFF333333)
        : const Color(0xFFE5E7EB);
    final borderColor = isDarkMode
        ? const Color(0xFF444444)
        : const Color(0xFFD1D5DB);
    final hintColor = isDarkMode
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    return TextFormField(
      obscureText: isPassword,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: fillColor,
        prefixIcon: icon != null ? Icon(icon, color: hintColor) : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: borderColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: borderColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
