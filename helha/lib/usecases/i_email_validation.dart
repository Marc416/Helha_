abstract class IEmailValidation {
  String getEmailErrorMessage(String errorCode);
  Future<String> isEmailVerrified(bool email);
}
