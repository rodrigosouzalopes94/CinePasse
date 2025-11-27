import 'package:cine_passe_app/features/api/user_firestore_service.dart';
import 'package:cine_passe_app/features/services/auth_service.dart';
import 'package:cine_passe_app/models/user_model.dart';
import 'package:flutter/material.dart';

class RegistrationController extends ChangeNotifier {
  // -------------------------------------------------------------------
  // Dependências (Services e API)
  // -------------------------------------------------------------------
  final AuthService _authService = AuthService();
  final UserFirestoreService _userFirestoreService = UserFirestoreService();

  // -------------------------------------------------------------------
  // Estado do Formulário
  // -------------------------------------------------------------------
  String _name = '';
  String _cpf = '';
  String _email = '';
  String _password = '';
  int _age = 0;

  bool _isLoading = false;
  String? _errorMessage;

  // -------------------------------------------------------------------
  // Getters
  // -------------------------------------------------------------------
  String get name => _name;
  String get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // -------------------------------------------------------------------
  // Setters (Otimizados para evitar rebuild desnecessário)
  // -------------------------------------------------------------------
  // NOTA: Removemos notifyListeners() daqui para evitar que o teclado feche
  // a cada letra digitada na UI (problema de perda de foco).

  void setName(String value) {
    _name = value;
    // Só limpamos o erro visualmente se ele existir, para evitar rebuild constante
    if (_errorMessage != null) _clearError();
  }

  void setCpf(String value) {
    _cpf = value;
  }

  void setEmail(String value) {
    _email = value.trim();
  }

  void setPassword(String value) {
    _password = value;
  }

  void setAge(String value) {
    _age = int.tryParse(value) ?? 0;
  }

  // -------------------------------------------------------------------
  // Validações
  // -------------------------------------------------------------------
  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Nome é obrigatório.';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email é obrigatório.';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Email inválido.';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Senha é obrigatória.';
    if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';
    return null;
  }

  String? validateCpf(String? value) {
    if (value == null || value.isEmpty) return 'CPF é obrigatório.';
    if (value.length != 11) return 'CPF inválido (11 dígitos).';
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) return 'Idade obrigatória.';
    final age = int.tryParse(value);
    if (age == null || age < 10) return 'Idade inválida.';
    return null;
  }

  // -------------------------------------------------------------------
  // Lógica de Registro (Conectada aos Services)
  // -------------------------------------------------------------------
  Future<bool> registerUser() async {
    // 1. Validação prévia de campos vazios antes de chamar o Firebase
    if (_name.isEmpty || _email.isEmpty || _password.isEmpty || _cpf.isEmpty) {
      _errorMessage = 'Por favor, preencha todos os campos.';
      notifyListeners(); // Avisa a UI para mostrar o erro
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Avisa a UI para mostrar o loading spinner

    try {
      // 2. Cria a conta no Firebase Auth
      final userCredential = await _authService.register(_email, _password);

      if (userCredential != null) {
        // 3. Prepara o modelo de dados
        final newUser = UserModel(
          uid: userCredential.uid, // Usa o UID gerado pelo Auth
          nome: _name,
          cpf: _cpf,
          email: _email,
          idade: _age,
        );

        // 4. Salva os dados complementares no Firestore
        await _userFirestoreService.saveUser(newUser);

        _isLoading = false;
        notifyListeners();
        return true; // Sucesso
      }
    } catch (e) {
      // Trata erros vindos do AuthService ou FirestoreService
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('Erro no Registro: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false; // Falha
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
