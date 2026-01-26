

import 'package:flutter/material.dart';
import 'package:cine_passe_app/core/constants/colors_constants.dart'; 

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
    
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          
          gradient: const LinearGradient(
            colors: [kPrimaryColor, kPrimaryDarkColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            foregroundColor: Colors.white,
            
            disabledBackgroundColor: kPrimaryColor.withValues(alpha: 0.5),
          ),
          child: isLoading
          
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
          
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