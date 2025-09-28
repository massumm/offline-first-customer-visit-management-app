import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/values/app_keys.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> setList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  String getString(String key) => _prefs.getString(key) ?? '';

  bool getBool(String key) => _prefs.getBool(key) ?? false;

  List<String> getList(String key) => _prefs.getStringList(key) ?? [];

  Future<bool> remove(String key) async => await _prefs.remove(key);

  // Works in both main & background isolates
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(StorageKeys.STORAGE_USER_KEY) ?? '').isNotEmpty;
  }
}
