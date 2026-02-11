import 'package:cine_passe_app/features/repositories/authrepository/i_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:cine_passe_app/models/user_model.dart';

class AuthViewModel with ChangeNotifier {

  final IAuthRepository _repository;

  AuthViewModel(this._repository) {
    _listenToAuthChanges();
  }

 
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _userProfile != null;

  
  void _listenToAuthChanges() {
    _repository.onAuthStateChanged.listen((user) {
      _userProfile = user;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      _userProfile = await _repository.login(email, password);
    } catch (e) {
      _errorMessage = _mapErrorToMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  
  Future<void> updateProfileDetails({
    required String newName,
    required int newAge,
    required String? newPlan,
  }) async {
    _setLoading(true);
    try {
      await _repository.updateProfile(
        newName: newName,
        newAge: newAge,
        newPlan: newPlan,
      );
      
      if (_userProfile != null) {
        _userProfile = _userProfile!.copyWith(
          nome: newName,
          idade: newAge,
          planoAtual: newPlan ?? _userProfile!.planoAtual,
        );
      }
    } catch (e) {
      _errorMessage = "Não foi possível atualizar o perfil. Tente novamente.";
    } finally {
      _setLoading(false);
    }
  }

  
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _repository.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = _mapErrorToMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _userProfile = null;
    notifyListeners();
  }

 

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _errorMessage = null; 
    notifyListeners();
  }

  String _mapErrorToMessage(String error) {
    final e = error.toLowerCase();
    if (e.contains('invalid-email')) return 'E-mail informado é inválido.';
    if (e.contains('user-not-found')) return 'Usuário não cadastrado.';
    if (e.contains('wrong-password')) return 'Senha incorreta.';
    if (e.contains('network-request-failed')) return 'Falha na conexão com o servidor.';
    return 'Ocorreu um erro inesperado. Tente novamente.';
  }
}