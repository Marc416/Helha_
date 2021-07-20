import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helha/data/repositories/i_user_repo.dart';
import 'package:helha/get_dependencies.dart';
import 'package:helha/usecases/i_email_validation.dart';
import 'package:helha/usecases/i_firebase_email_signup.dart';

import 'firebase_oauthStatus.dart';
import 'i_firebase_email_signin.dart';
import 'i_sign_in_validation.dart';

class FirebaseAuthUserImpl extends GetxController
    implements
        IFirebaseEmailSignIn,
        IEmailValidation,
        ISignInValidation,
        IFirebaseEmailSignUp {
  FireBaseAuthStatus _fireBaseAuthStatus = FireBaseAuthStatus.signout;
  final IUserRepo _userRepo = Get.find<GetDependencies>().sharedPreferences;
  User? _firebaseUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FireBaseAuthStatus get fireBaseAuthStatus => _fireBaseAuthStatus;

  set fireBaseAuthStatus(FireBaseAuthStatus status) {
    _fireBaseAuthStatus = status;
    update();
  }

  void watchUserAuthChange() {
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      if (_firebaseUser == null && firebaseUser == null) {
        detectFireBaseAuthStatus();
      } else if (_firebaseUser != firebaseUser) {
        _firebaseUser = firebaseUser;

        // Save Token
        _userRepo.saveAccessToken(await getAccessToken());
        detectFireBaseAuthStatus();
      }
    });
  }

  @override
  Future<String> emailLogin({
    @required String? emailId,
    @required String? password,
  }) async {
    UserCredential? authResult;
    try {
      authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: emailId!.trim(), password: password!.trim());
    } on FirebaseAuthException catch (e) {
      return getEmailErrorMessage(e.code);
    }

    // If User is null -> return error message
    _firebaseUser = authResult.user;
    final userNull = isUserNull(_firebaseUser);
    if (userNull != '') return userNull;

    watchUserAuthChange();
    return await isEmailVerrified(_firebaseUser!.emailVerified);
  }

  @override
  Future<String> registerUser({
    @required String? emailId,
    @required String? password,
  }) async {
    changeFireBaseAuth(FireBaseAuthStatus.progress);

    UserCredential? authResult;
    try {
      authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailId!.trim(), password: password!.trim());
    } on FirebaseAuthException catch (e) {
      return getSignInErrorMessage(e.code);
    }

    _firebaseUser = authResult.user;
    final userErrorCheck = isUserNull(_firebaseUser);
    if (userErrorCheck.isNotEmpty) return userErrorCheck;

    watchUserAuthChange();
    await _firebaseUser?.sendEmailVerification();
    return '이메일 인증을 한 뒤 로그인 해 주세요.';
  }

  @override
  void signOut() {
    _fireBaseAuthStatus = FireBaseAuthStatus.signout;
    if (_firebaseUser != null) {
      _firebaseUser = null;
      _firebaseAuth.signOut();
    }
    update();
  }

  void changeFireBaseAuth(FireBaseAuthStatus firebaseAuthStatus) {
    _fireBaseAuthStatus = firebaseAuthStatus;
    update();
  }

  void detectFireBaseAuthStatus() {
    if (_firebaseUser != null) {
      _fireBaseAuthStatus = FireBaseAuthStatus.signin;
    } else {
      _fireBaseAuthStatus = FireBaseAuthStatus.signout;
    }
    update();
  }

  Future<String?> getAccessToken() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    return await _firebaseMessaging.getToken();
  }

  @override
  String getEmailErrorMessage(String errorCode) {
    String _message = '오류입니다';
    switch (errorCode) {
      case 'invalid-email':
        _message = '유효하지 않은 이메일 입니다';
        break;
      case 'user-disabled':
        _message = '차단된 사용자입니다.';
        break;
      case 'user-not-found':
        _message = '없는 이메일 입니다';
        break;
      case 'wrong-password':
        _message = '비밀번호가 틀렸습니다';
        break;
    }
    return _message;
  }

  @override
  Future<String> isEmailVerrified(bool emailVerified) async {
    if (emailVerified == false) {
      await _firebaseUser?.sendEmailVerification();
      return "이메일 인증을 한뒤 다시 로그인 해주세요.";
    } else {
      return "로그인 완료되었습니다.";
    }
  }

  String isUserNull(User? _firebaseUser) {
    if (_firebaseUser == null) {
      return '오류가 떴으니 나중에 다시해주세요.';
    }
    return '';
  }

  @override
  String getSignInErrorMessage(String errorCode) {
    String _message = '알수없는 오류입니';
    switch (errorCode) {
      case 'email-already-in-use':
        _message = '해당 아이디는 이미 사용중입니다';
        break;
      case 'invalid-email':
        _message = '이메일 형식이 아닙니다';
        break;
      case 'operation-not-allowed':
        _message = '아이디나 비밀번호가 일치하지않습니다';
        break;
    }
    return _message;
  }
}
