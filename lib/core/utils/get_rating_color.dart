import 'package:flutter/material.dart';

// Cores baseadas em padrões comuns de classificação etária
Color getRatingColor(String classification) {
  // Converte para minúsculas e remove espaços para garantir a comparação
  final cleanClassification = classification.toLowerCase().trim();

  switch (cleanClassification) {
    case 'livre':
    case 'l':
      return Colors.green.shade800; // Cor do ícone de classificação "Livre"
    case '10':
      return Colors.blue.shade800; // Cor para classificação 10 anos
    case '12':
      return Colors.yellow.shade800; // Cor para classificação 12 anos
    case '14':
      return Colors.orange.shade800; // Cor para classificação 14 anos
    case '16':
      return Colors.red.shade800; // Cor para classificação 16 anos
    case '18':
      return Colors.black; // Cor para classificação 18 anos
    default:
      return Colors.grey.shade600; // Cor padrão para classificações desconhecidas
  }
}