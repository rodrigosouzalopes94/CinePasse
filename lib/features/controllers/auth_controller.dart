import 'package:cine_passe_app/features/api/user_firestore_service.dart';
import 'package:cine_passe_app/features/services/auth_service.dart';
import 'package:cine_passe_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController with ChangeNotifier {
  // Instância do Serviço (Service de Auth)
  // ⚠️ NOTA: A injeção deve ser feita no main.dart, mas aqui instanciamos para simplicidade.
  final AuthService _authService = AuthService();
  // Instância do Serviço Firestore (API de Dados)
  final UserFirestoreService _userFirestoreService = UserFirestoreService(); 

  // -------------------------------------------------------------------
  // ESTADO
  // -------------------------------------------------------------------
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = false;
  
  // ✅ Estado para o Perfil Completo do Firestore
  UserModel? _userProfile; 

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
  // Getter para o objeto User (Firebase Auth)
  User? get currentUser => _authService.currentUser;
  // Getter para o objeto completo do Firestore (UserModel)
  UserModel? get userProfile => _userProfile; 

  // -------------------------------------------------------------------
  // SETTERS (Mantidos)
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
  // AÇÕES CORE (Login, Reset, Logout) - Mocks de Métodos
  // -------------------------------------------------------------------

  // LOGIN (Método incompleto - apenas placeholder)
  Future<void> login() async {
     _startLoading();
     try {
       // A lógica real de login estaria aqui, atualizando o _userProfile no sucesso
       final user = await _authService.login(_email, _password);
       if (user != null) {
         await fetchUserProfile(); // Carrega o perfil completo após login
       }
     } catch (e) {
       _errorMessage = _translateError(e.toString());
     } finally {
       _stopLoading();
     }
  }

  // RECUPERAÇÃO DE SENHA (Método incompleto - apenas placeholder)
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

  // LOGOUT
  Future<void> logout() async {
    await _authService.logout();
    _userProfile = null; // Limpa o perfil
    notifyListeners();
  }
  
  // -------------------------------------------------------------------
  // 🚀 NOVO MÉTODO: ATUALIZAÇÃO DE PERFIL (Nome + Dados do Firestore)
  // -------------------------------------------------------------------
  /// Atualiza o nome no Firebase Auth e os dados (idade, plano) no Firestore.
  Future<void> updateProfileDetails({
    required String newName, 
    required int newAge,
    required String? newPlan, 
  }) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }
    
    // 1. Atualiza o displayName no Firebase Auth (AuthService)
    await _authService.updateUserProfile(newName: newName);
    
    // 2. Atualiza o documento completo no Firestore (UserFirestoreService)
    if (_userProfile != null) {
        // Cria um novo modelo com os dados atualizados
        final updatedModel = _userProfile!.copyWith(
          nome: newName, 
          idade: newAge,
          planoAtual: newPlan ?? _userProfile!.planoAtual, 
        );
        
        await _userFirestoreService.updateUser(updatedModel); 
        _userProfile = updatedModel; // Atualiza o estado local do controller
    } else {
        throw Exception("Dados do perfil não carregados. Tente novamente.");
    }
    
    // Notifica a UI para reconstruir elementos que exibem nome/plano/idade
    notifyListeners();
  }

  // -------------------------------------------------------------------
  // 🚀 NOVO MÉTODO: CARREGAR PERFIL DO FIRESTORE (Chamado no login ou MainAppWrapper)
  // -------------------------------------------------------------------
  /// Busca os dados complementares (idade, cpf, plano) do Firestore.
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
  
  // Implementação de Mock para tradução de erros
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