// lib/features/auth/controllers/registration_controller.dart

import 'package:flutter/material.dart';
import '../../../models/user_model.dart'; // Importa o seu UserModel

// Usamos ChangeNotifier para gerenciar o estado do formulário.
class RegistrationController extends ChangeNotifier {
  // Estado do Formulário
  String _name = '';
  String _cpf = '';
  String _email = '';
  String _password = '';
  int _age = 0;

  bool _isLoading = false;

  // Getters para acessar o estado
  String get name => _name;
  String get email => _email;
  bool get isLoading => _isLoading;

  // -------------------------------------------------------------------
  // Setters (Para a UI atualizar o estado)
  // -------------------------------------------------------------------
  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setCpf(String value) {
    _cpf = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setAge(int value) {
    _age = value;
    notifyListeners();
  }

  // -------------------------------------------------------------------
  // Validações
  // -------------------------------------------------------------------

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required.';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    // Uma regex básica para email (pode ser mais complexa)
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  // -------------------------------------------------------------------
  // Lógica de Submissão
  // -------------------------------------------------------------------
  Future<void> registerUser() async {
    // Simulação de Validação do Formulário (O Form Widget fará a validação da UI)
    if (_name.isEmpty || _email.isEmpty || _password.isEmpty) {
      // Aqui você lidaria com erros, talvez mostrando uma Snackbar.
      print('Form validation failed in controller.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Cria o objeto Model
    final newUser = UserModel(
      nome:
          _name, // Usando 'nome' conforme definido em user_model.dart (se for manter o português lá)
      cpf: _cpf,
      email: _email,
      senha: _password, // Usando 'senha' conforme definido em user_model.dart
      idade: _age,
    );

    // Simulação de chamada de API
    await Future.delayed(const Duration(seconds: 2));

    print('User registered successfully: ${newUser.toJson()}');

    _isLoading = false;
    notifyListeners();

    // Lógica de navegação pós-registro (ex: ir para a tela de login)
  }
}
