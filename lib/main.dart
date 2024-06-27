import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kw_mail/binding/home_binding.dart';
import 'package:kw_mail/binding/login_binding.dart';
import 'package:kw_mail/controller/HomeController.dart';
import 'package:kw_mail/service/account_service.dart';
import 'package:kw_mail/service/secure_storage_service.dart';
import 'package:kw_mail/utils/api_manager.dart';
import 'package:kw_mail/view/home_view.dart';
import 'package:kw_mail/view/login_view.dart';

late Widget _rootWidget;
late Bindings _rootBindings;

void main() async {
  await initWidgets();

   runApp(ScreenUtilInit(
       designSize: const Size(360, 720),
       minTextAdapt: true,
       splitScreenMode: true,
       child: Phoenix(
           child: GetMaterialApp(home: _rootWidget, initialBinding: _rootBindings)))
   );
}

Future<void> initWidgets() async {
  Get.put(ApiManager());
  Get.put(SecureStorageService());
  AccountService accountService = Get.put(AccountService());

  if (await accountService.hasLoggedInAccount()) {
    await accountService.login((await accountService.getUsername())!, (await accountService.getPassword())!);
    _rootWidget = HomeView();
    _rootBindings = HomeBinding();
  } else {
    _rootWidget = LoginView();
    _rootBindings = LoginBinding();
  }
}

/// 앱을 재실행합니다
Future<void> restartApp() async {
  Get.deleteAll(force: true);
  Get.reset();
  await initWidgets();
  Phoenix.rebirth(Get.context!);
}
