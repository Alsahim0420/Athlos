import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../presentation/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    debugPrint('👤 [PROFILE_BINDING] Starting dependencies injection...');

    debugPrint('👤 [PROFILE_BINDING] Registering ProfileController...');
    Get.lazyPut<ProfileController>(() => ProfileController());

    debugPrint('👤 [PROFILE_BINDING] All dependencies registered successfully');
  }
}
