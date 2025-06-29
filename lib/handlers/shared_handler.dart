import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';

class SharedPrefHandler {
  static SharedPrefHandler? instance;

  late final Box? _box;

  SharedPrefHandler._internal();

  static init() async {
    if (instance == null) {
      await Hive.initFlutter();
      // shared = await SharedPreferences.getInstance();
      instance = SharedPrefHandler._internal();
      instance!._box = await Hive.openBox('gold4card_box');
      log('Hive init');
    }
  }

  Future<void> save(String key, {dynamic value}) async => _box!.put(key, value);

  T get<T>({required String key}) {
    var value = _box!.get(key);
    if (value is T) {
      log("Retrieved value for key '$key': $value");
      return value;
    } else {
      log("Value for key '$key' is not of type $T");
      throw TypeError();
    }
  }

  void removeAllOf({required List<String> keys}) async {
    for (String key in keys) {
      if (_box!.containsKey(key)) {
        log( 'Key $key exists, deleting...');
        await _box!.delete(key);
      }
    }
  }

  void remove(String key) async {
    if (_box!.containsKey(key)) {
      log( 'Key $key exists, deleting...');
      await _box!.delete(key);
    }
  }

  clear() async {
    log(" Hive cleared");
    await _box!.clear();
  }

  bool contains(String key){
    return _box!.containsKey(key);
  }
}
