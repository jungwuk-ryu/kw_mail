import 'dart:developer';

import 'package:get/get.dart';
import 'package:kw_mail/main.dart';
import 'package:kw_mail/service/secure_storage_service.dart';
import 'package:kw_mail/utils/api_manager.dart';

class AccountService extends GetxService {
  static const String keyUsername = "acc_username";
  static const String keyPassword = "acc_password";
  static const String keyHasLoggedIn = "acc_login";

  final ApiManager _apiManager = Get.find<ApiManager>();

  final SecureStorageService _secureStorageService =
      Get.find<SecureStorageService>();

  Future<bool> hasLoggedInAccount() async {
    return await _secureStorageService.read(keyHasLoggedIn) != null;
  }

  Future<String?> getUsername() async {
    return await _secureStorageService.read(keyUsername);
  }

  Future<String?> getPassword() async {
    return await _secureStorageService.read(keyPassword);
  }

  Future<bool> login(String username, String password) async {
    username = username.trim();
    password = password.trim();

    if (username.isEmpty || password.isEmpty) {
      log("로그인 할 수 없음: 아이디 또는 비밀번호가 비어 있음");
      return false;
    }

    _setUsername(username);
    _setPassword(password);

    await _apiManager.webmailLogin(username, password);
    bool success = true;
    if (success) {
      _setLoggedIn(true);
    }

    // TODO 로그인 성공 여부 검사
    return true;
  }

  Future<void> logout() async {
    Future.wait([
      _secureStorageService.remove(keyUsername),
      _secureStorageService.remove(keyPassword)
    ]);
    _setLoggedIn(false);
    await restartApp();
  }

  Future<void> _setUsername(String username) async {
    username = username.trim();
    if (username.isEmpty) {
      log("Username is empty!!");
      return;
    }

    await _secureStorageService.set(keyUsername, username);
  }

  Future<void> _setPassword(String password) async {
    password = password.trim();
    if (password.isEmpty) {
      log("Password is empty!!");
      return;
    }

    await _secureStorageService.set(keyPassword, password);
  }

  Future<void> _setLoggedIn(bool status) async {
    if (status) {
      await _secureStorageService.set(keyHasLoggedIn, "true");
    } else {
      await _secureStorageService.remove(keyHasLoggedIn);
    }
  }
}
