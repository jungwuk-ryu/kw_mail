import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorageService extends GetxService {
  late FlutterSecureStorage _storage;

  @override
  void onInit() {
    super.onInit();
    _storage = const FlutterSecureStorage();
    //_storage.deleteAll();
  }

  Future<String?> read(String key, {dynamic defaultValue}) async {
    String? value = await _storage.read(key: key);
    value ??= defaultValue;

    return value;
  }

  Future<void> set(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> removeAll() async {
    await _storage.deleteAll();
  }
}