// lib/features/auth/controllers/auth_controller.dart

import 'package:flutter/material.dart';

// O AuthController gerencia o estado do formulário de Login e a autenticação
class AuthController extends ChangeNotifier {
  // Estado do Formulário
  String _email = '';
  String _password = '';
  bool _rememberMe = false;

  // Estado da UI/Lógica
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;

  // -------------------------------------------------------------------
  // Setters (Para a UI atualizar o estado)
  // -------------------------------------------------------------------
  void setEmail(String value) {
    _email = value.trim();
    // Limpa a mensagem de erro ao começar a digitar
    _errorMessage = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _errorMessage = null;
    notifyListeners();
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  // -------------------------------------------------------------------
  // Validações
  // -------------------------------------------------------------------

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'O email é obrigatório.'; // Mensagem de erro em Português
    }
    // Adicione validação de formato de email aqui se necessário
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'A senha é obrigatória.'; // Mensagem de erro em Português
    }
    return null;
  }

  // -------------------------------------------------------------------
  // Lógica de Login (Simulação do Firebase)
  // -------------------------------------------------------------------

  Future<void> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ⚠️ SIMULAÇÃO DE CHAMADA FIREBASE
      // Em um app real, você usaria:
      // await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);

      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simula latência de rede

      // Lógica de verificação SIMULADA (sucesso/falha)
      if (_email == 'teste@cinepasse.com' && _password == '123456') {
        print('Login bem-sucedido. Redirecionando...');

        // 🚀 Sucesso: Se for um app real, você navegaria para a HomeScreen aqui.
      } else {
        throw Exception('Credenciais inválidas. Verifique seu email e senha.');
      }
    } catch (e) {
      // Captura erros do Firebase (ex: wrong-password, user-not-found)
      _errorMessage = e.toString().contains('Credenciais inválidas')
          ? 'Email ou senha incorretos.' // Mensagem amigável em Português
          : 'Ocorreu um erro no login. Tente novamente mais tarde.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
