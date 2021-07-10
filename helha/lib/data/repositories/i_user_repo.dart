import 'package:helha/entities/auth_user_entity.dart';

abstract class IUserRepo {
  void saveAccessToken(String? accessToken);
  Future<AuthUserEntity> getAccessToekn();
}
