abstract class IFirebaseEmailSignUp {
  Future<String> registerUser({
    String? emailId,
    String? password,
  });
}
