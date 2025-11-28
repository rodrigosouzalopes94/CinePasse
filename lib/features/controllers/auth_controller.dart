import 'package:cine_passe_app/features/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController with ChangeNotifier {
  // Instância do Serviço
  final AuthService _authService = AuthService();

  // -------------------------------------------------------------------
  // ESTADO
  // -------------------------------------------------------------------
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = false;

  // -------------------------------------------------------------------
  // GETTERS
  // -------------------------------------------------------------------
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;

  // Verifica estado de login consultando o serviço
  bool get isLoggedIn => _authService.currentUser != null;

  // -------------------------------------------------------------------
  // SETTERS
  // -------------------------------------------------------------------
  void setEmail(String value) {
    _email = value.trim();
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void setPassword(String value) {
    _password = value.trim();
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  // -------------------------------------------------------------------
  // AÇÕES (Login, Reset, Logout)
  // -------------------------------------------------------------------

  // LOGIN
  Future<void> login() async {
    if (_email.isEmpty || _password.isEmpty) {
      _errorMessage = 'Preencha email e senha.';
      notifyListeners();
      return;
    }

    _startLoading();

    try {
      await _authService.login(_email, _password);
      // Sucesso: O listener no main.dart (authStateChanges) cuidará da navegação.
    } on FirebaseAuthException catch (e) {
      _errorMessage = _translateError(e.code);
    } catch (e) {
      _errorMessage = 'Erro inesperado ao entrar.';
    } finally {
      _stopLoading();
    }
  }

  // RECUPERAÇÃO DE SENHA
  Future<bool> resetPassword(String email) async {
    if (email.isEmpty) {
      _errorMessage = 'Informe o email para recuperar a senha.';
      notifyListeners();
      return false;
    }

    _startLoading();

    try {
      await _authService.resetPassword(email);
      _stopLoading();
      return true; // Sucesso
    } on FirebaseAuthException catch (e) {
      _errorMessage = _translateError(e.code);
      _stopLoading();
      return false;
    } catch (e) {
      _errorMessage = 'Erro ao enviar email. Tente novamente.';
      _stopLoading();
      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  // -------------------------------------------------------------------
  // AUXILIARES
  // -------------------------------------------------------------------

  void _startLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  // Tradutor de Erros do Firebase para Português
  String _translateError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email não cadastrado.';
      case 'wrong-password':
      case 'invalid-credential': // Código novo comum
        return 'Email ou senha incorretos.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'user-disabled':
        return 'Conta desativada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde alguns minutos.';
      default:
        return 'Erro de autenticação ($code).';
    }
  }

  // Validações de Interface
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email obrigatório';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
      return 'Email inválido';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Senha obrigatória';
    if (value.length < 6) return 'Mínimo de 6 caracteres';
    return null;
  }
}
