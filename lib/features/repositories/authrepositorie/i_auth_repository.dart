import 'package:cine_passe_app/models/user_model.dart';

abstract class IAuthRepository {
  
  Stream<UserModel?> get onAuthStateChanged;

 
  Future<UserModel?> login(String email, String password);

 
  Future<UserModel?> register(UserModel user, String password);

  
  Future<void> resetPassword(String email);

  
  Future<void> updateProfile({
    required String newName,
    required int newAge,
    String? newPlan,
  });

  
  Future<UserModel?> fetchUserProfile(String uid);

  Future<void> logout();
}