import 'firebase_oauthStatus.dart';

abstract class IFirebaseAuthUser {
  late FireBaseAuthStatus fireBaseAuthStatus;
  Future<String> emailLogin({
    String? emailId,
    String? password,
  });
  void registerUser();
  void signOut();
  Future<String?> getAccessToken();
  void watchUserAuthChange();
  void changeFireBaseAuthStatus([FireBaseAuthStatus? firebaseAuthStatus]);
}
