import 'firebase_oauthStatus.dart';

abstract class IFirebaseAuthUser {
  Future<String> emailLogin({
    String? emailId,
    String? password,
  });
  void registerUser();
  void signOut();
}
