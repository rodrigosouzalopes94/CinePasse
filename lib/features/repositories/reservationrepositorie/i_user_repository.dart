import 'package:cine_passe_app/models/user_model.dart';

abstract class IUserRepository {
  Future<UserModel?> getUserProfile(String uid);
}