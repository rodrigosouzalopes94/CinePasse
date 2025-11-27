import 'package:cine_passe_app/features/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ✅ Importa o Serviço

class AuthController with ChangeNotifier {
  // 1. Substituímos a instância direta do FirebaseAuth pelo nosso Service
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

  // Verifica se está logado consultando o serviço
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
  // LÓGICA DE LOGIN
  // -------------------------------------------------------------------
  Future<void> login() async {
    if (_email.isEmpty || _password.isEmpty) {
      _errorMessage = 'Preencha email e senha.';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      // ✅ Chama o método do Serviço
      await _authService.login(_email, _password);

      // Sucesso! O listener no main.dart vai detectar a mudança de estado
      // via authStateChanges e navegará automaticamente.
    } on FirebaseAuthException catch (e) {
      // O Serviço deixou o erro subir, nós tratamos aqui para a UI
      _handleFirebaseError(e.code);
    } catch (e) {
      _errorMessage = 'Erro inesperado. Tente novamente.';
    } finally {
      _setLoading(false);
    }
  }

  // -------------------------------------------------------------------
  // LÓGICA DE RECUPERAÇÃO DE SENHA
  // -------------------------------------------------------------------
  Future<bool> resetPassword(String email) async {
    if (email.isEmpty) {
      _errorMessage = 'Informe seu email para redefinir a senha.';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      // ✅ Chama o método do Serviço
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e.code);
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'Erro ao enviar email de recuperação.';
      _setLoading(false);
      return false;
    }
  }

  // -------------------------------------------------------------------
  // LÓGICA DE LOGOUT
  // -------------------------------------------------------------------
  Future<void> logout() async {
    // ✅ Chama o método do Serviço
    await _authService.logout();
    notifyListeners();
  }

  // -------------------------------------------------------------------
  // MÉTODOS AUXILIARES
  // -------------------------------------------------------------------
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Tradutor de erros (Fica aqui no Controller pois é texto para a UI)
  void _handleFirebaseError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
      case 'invalid-credential': // Código novo comum
        _errorMessage = 'Email ou senha incorretos.';
        break;
      case 'wrong-password':
        _errorMessage = 'Senha incorreta.';
        break;
      case 'invalid-email':
        _errorMessage = 'Email inválido.';
        break;
      case 'user-disabled':
        _errorMessage = 'Usuário desativado.';
        break;
      case 'too-many-requests':
        _errorMessage = 'Muitas tentativas. Tente mais tarde.';
        break;
      default:
        _errorMessage = 'Falha na autenticação ($errorCode).';
    }
    notifyListeners();
  }

  // Validações locais (UI)
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email obrigatório.';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
      return 'Email inválido.';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Senha obrigatória.';
    if (value.length < 6) return 'Mínimo de 6 caracteres.';
    return null;
  }
}
