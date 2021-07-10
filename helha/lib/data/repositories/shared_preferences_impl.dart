import 'package:helha/data/repositories/i_user_repo.dart';
import 'package:helha/entities/auth_user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesImpl implements IUserRepo {
  static final SharedPreferencesImpl _instance =
      SharedPreferencesImpl._makeInstance();
  factory SharedPreferencesImpl() {
    return _instance;
  }

  SharedPreferencesImpl._makeInstance() {
    print('Init Singleton SharedPreferencesImpl');
  }

  @override
  void saveAccessToken(String? accessToken) async {
    final sharedPreferencesInstance = await getSharedPreferences();
    final AuthUserEntity _authUserEntity =
        AuthUserEntity(accessToken: accessToken!);
    await sharedPreferencesInstance.setString(
        _authUserEntity.key, _authUserEntity.accessToken);
  }

  @override
  Future<AuthUserEntity> getAccessToekn() async {
    final sharedPreferencesInstance = await getSharedPreferences();
    final accessToken = sharedPreferencesInstance.getString('accessToken')!;
    final AuthUserEntity _authUserEntity =
        AuthUserEntity(accessToken: accessToken);
    return _authUserEntity;
  }

  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }
}
