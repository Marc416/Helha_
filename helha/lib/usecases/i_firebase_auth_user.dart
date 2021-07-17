abstract class IFirebaseAuthUser {
  Future<String> emailLogin({
    String? emailId,
    String? password,
  });
  Future<String> registerUser({
    String? emailId,
    String? password,
  });
  void signOut();
}
