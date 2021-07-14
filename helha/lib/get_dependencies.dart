import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'usecases/firebase_auth_user_impl.dart';

class GetDependencies extends GetxController {
  final authUser = Get.put(FirebaseAuthUserImpl());
}
