import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helha/const/debug_variables.dart';
import 'package:helha/get_dependencies.dart';
import 'package:helha/usecases/firebase_auth_user_impl.dart';
import 'package:helha/usecases/i_firebase_auth_user.dart';

import '../Widgets/oauth_validate_widget.dart';
import 'sign_up_widget.dart';

class LoginWidget extends StatelessWidget {
  final IFirebaseAuthUser _authUser = Get.find<GetDependencies>().authUser;
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (isDebug == true) {
      _emailIdController.text = debugId;
      _pwdController.text = debugPwd;
    }

    return Builder(
      builder: (context) => Scaffold(
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: ListView(
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Center(child: Text('헬하')),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _emailIdController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isNotEmpty &&
                        value.contains('@') &&
                        value.contains('.')) {
                      return null;
                    } else {
                      return '@, .com 가 들어간 이메일을 넣어주세요';
                    }
                  },
                  cursorColor: Colors.black,
                  decoration: oauthValidateWidget(
                      hint: 'ex) abc@def.com', iconData: Icons.email_outlined),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _pwdController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isNotEmpty && value.length >= 6) {
                      return null;
                    } else {
                      return '6자리 이상 비밀번호를 입력해 주세요';
                    }
                  },
                  cursorColor: Colors.black,
                  obscureText: true,
                  decoration: oauthValidateWidget(
                    hint: '비밀번호를 입력하세요',
                    iconData: Icons.lock_outline,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      _authUser.signOut();
                      Get.defaultDialog(middleText: '로그인 시도 중입니다.');
                      String response = await _authUser.emailLogin(
                          emailId: _emailIdController.text,
                          password: _pwdController.text);
                      Get.back();
                      alertOneConfirmDialog(response);
                    },
                    child: const Text('로그인')),
                ElevatedButton(
                    onPressed: () {
                      Get.offAll(SignUp());
                    },
                    child: const Text('가입하기')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void alertOneConfirmDialog(String _message) {
  Get.defaultDialog(
      middleText: _message,
      confirm: OutlinedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('확인')));
}
