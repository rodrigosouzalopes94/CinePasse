import 'package:cine_passe_app/features/repositories/authrepository/i_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:cine_passe_app/models/user_model.dart';

class RegistrationViewModel with ChangeNotifier {
  final IAuthRepository _repository;

  RegistrationViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String cpf,
    required int age,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newUser = UserModel(
        nome: name,
        email: email,
        cpf: cpf,
        idade: age,
        planoAtual: 'Nenhum',
      );

      final result = await _repository.register(newUser, password);
      return result != null;
    } catch (e) {
      _errorMessage = _parseError(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _parseError(String error) {
    if (error.contains('email-already-in-use')) return 'Este e-mail já está em uso.';
    if (error.contains('weak-password')) return 'A senha é muito fraca.';
    return 'Erro ao criar conta. Tente novamente.';
  }
}