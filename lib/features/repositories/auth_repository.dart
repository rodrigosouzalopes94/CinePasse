import 'package:cine_passe_app/models/user_model.dart';
import 'package:your_app/services/auth_service.dart';
import 'package:your_app/api/user_firestore_service.dart';
import 'package:your_app/models/user_model.dart';

class AuthRepository {
  final AuthService _authService;
  final UserFirestoreService _firestoreService;

  AuthRepository(this._authService, this._firestoreService);

  Future<void> registerUser(UserModel user, String password) async {
    final userCredential = await _authService.registerWithEmail(
      user.email,
      password,
    );

    final uid = userCredential.user!.uid;

    await _firestoreService.saveUser(user.copyWith(uid: uid));
  }

  Future<void> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<void> logout() {
    return _authService.logout();
  }

  Future<UserModel?> getUserData(String uid) {
    return _firestoreService.getUser(uid);
  }
}
