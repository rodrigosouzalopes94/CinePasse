import 'package:cine_passe_app/features/api/user_firestore_service.dart';
import 'package:cine_passe_app/features/services/auth_service.dart';
import 'package:cine_passe_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController with ChangeNotifier {
  
  
  final AuthService _authService = AuthService();
  
  final UserFirestoreService _userFirestoreService = UserFirestoreService(); 

  
  
  
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = false;
  
  
  UserModel? _userProfile; 

  
  
  
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;
  
  
  bool get isLoggedIn => _authService.currentUser != null;
  
  User? get currentUser => _authService.currentUser;
  
  UserModel? get userProfile => _userProfile; 

  
  
  
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

  
  
  

  
  Future<void> login() async {
     _startLoading();
     try {
       
       final user = await _authService.login(_email, _password);
       if (user != null) {
         await fetchUserProfile(); 
       }
     } catch (e) {
       _errorMessage = _translateError(e.toString());
     } finally {
       _stopLoading();
     }
  }

  
  Future<bool> resetPassword(String email) async {
    _startLoading();
    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = _translateError(e.toString());
      return false;
    } finally {
      _stopLoading();
    }
  }

  
  Future<void> logout() async {
    await _authService.logout();
    _userProfile = null; 
    notifyListeners();
  }
  
  
  
  
  
  Future<void> updateProfileDetails({
    required String newName, 
    required int newAge,
    required String? newPlan, 
  }) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }
    
    
    await _authService.updateUserProfile(newName: newName);
    
    
    if (_userProfile != null) {
        
        final updatedModel = _userProfile!.copyWith(
          nome: newName, 
          idade: newAge,
          planoAtual: newPlan ?? _userProfile!.planoAtual, 
        );
        
        await _userFirestoreService.updateUser(updatedModel); 
        _userProfile = updatedModel; 
    } else {
        throw Exception("Dados do perfil não carregados. Tente novamente.");
    }
    
    
    notifyListeners();
  }

  
  
  
  
  Future<void> fetchUserProfile() async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      try {
        _userProfile = await _userFirestoreService.getUser(uid);
        notifyListeners();
      } catch (e) {
        debugPrint('Erro ao buscar perfil do Firestore: $e');
        _userProfile = null;
      }
    }
  }

  
  
  
  
  void _startLoading() { 
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }
  
  void _stopLoading() { 
    _isLoading = false;
    notifyListeners();
  }
  
  
  String _translateError(String code) {
    if (code.contains('invalid-email')) return 'Email inválido.';
    if (code.contains('user-not-found')) return 'Usuário não encontrado.';
    if (code.contains('wrong-password')) return 'Senha incorreta.';
    return 'Erro desconhecido.';
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
}