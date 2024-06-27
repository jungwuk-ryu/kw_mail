import 'package:get/get.dart';
import 'package:kw_mail/controller/HomeController.dart';
import 'package:kw_mail/controller/setting_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.lazyPut(() => SettingController());
  }
}