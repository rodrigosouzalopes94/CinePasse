import 'package:cine_passe_app/features/api/user_firestore_service.dart';
import 'package:cine_passe_app/features/services/auth_service.dart';
import 'package:cine_passe_app/models/user_model.dart';
import 'package:flutter/material.dart';

class RegistrationController extends ChangeNotifier {
  
  
  
  final AuthService _authService = AuthService();
  final UserFirestoreService _userFirestoreService = UserFirestoreService();

  
  
  
  String _name = '';
  String _cpf = '';
  String _email = '';
  String _password = '';
  int _age = 0;

  bool _isLoading = false;
  String? _errorMessage;

  
  
  
  String get name => _name;
  String get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  
  
  
  
  

  void setName(String value) {
    _name = value;
    
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

  
  
  
  Future<bool> registerUser() async {
    
    if (_name.isEmpty || _email.isEmpty || _password.isEmpty || _cpf.isEmpty) {
      _errorMessage = 'Por favor, preencha todos os campos.';
      notifyListeners(); 
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); 

    try {
      
      final userCredential = await _authService.register(_email, _password);

      if (userCredential != null) {
        
        final newUser = UserModel(
          uid: userCredential.uid, 
          nome: _name,
          cpf: _cpf,
          email: _email,
          idade: _age,
        );

        
        await _userFirestoreService.saveUser(newUser);

        _isLoading = false;
        notifyListeners();
        return true; 
      }
    } catch (e) {
      
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('Erro no Registro: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false; 
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
