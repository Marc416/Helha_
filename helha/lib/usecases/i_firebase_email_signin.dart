abstract class IFirebaseEmailSignIn {
  Future<String> emailLogin({
    String? emailId,
    String? password,
  });
  void signOut();
}
