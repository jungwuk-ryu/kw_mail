import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kw_mail/main.dart';
import 'package:kw_mail/utils/my_utils.dart';

import '../service/account_service.dart';

class LoginController extends GetxController {
  final AccountService _accountService = Get.find<AccountService>();
  final TextEditingController usernameFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();

  Future<bool> login() async {
    String username = usernameFieldController.text.trim();
    String password = passwordFieldController.text.trim();

    if (username.isEmpty) {
      MyUtils.snackbar("아이디를 입력해주세요", status: SnackStatus.warn);
      return false;
    }
    if (password.isEmpty) {
      MyUtils.snackbar("비밀번호를 입력해주세요", status: SnackStatus.warn);
      return true;
    }

    bool result = await _accountService.login(username, password);
    if (!result) {
      MyUtils.snackbar("아이디 또는 비밀번호를 확인해주세요", title: "로그인 실패", status: SnackStatus.error);
    } else {
      restartApp();
    }

    return result;
  }
}