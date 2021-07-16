abstract class IFirebaseAuthUser {
  Future<String> emailLogin({
    String? emailId,
    String? password,
  });
  void registerUser({
    String? emailId,
    String? password,
  });
  void signOut();
}
