import 'package:flutter/material.dart';


Color getRatingColor(String classification) {
  
  final cleanClassification = classification.toLowerCase().trim();

  switch (cleanClassification) {
    case 'livre':
    case 'l':
      return Colors.green.shade800; 
    case '10':
      return Colors.blue.shade800; 
    case '12':
      return Colors.yellow.shade800; 
    case '14':
      return Colors.orange.shade800; 
    case '16':
      return Colors.red.shade800; 
    case '18':
      return Colors.black; 
    default:
      return Colors.grey.shade600; 
  }
}