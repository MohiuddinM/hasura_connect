import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'local_storage.dart';

class LocalStorageHive extends LocalStorage {
  final Completer<Box> _completer = Completer<Box>();
  final String name;

  LocalStorageHive(this.name);

  @override
  Future init(String name) async {
    if (_completer.isCompleted) return;
    assert(LocalStorage.databasePath != null, 'please set the LocalStorage.databasePath before using hasura');

    Hive.init(LocalStorage.databasePath);
    if (Hive.isBoxOpen(name)) {
      _completer.complete(await Hive.openBox(name));
    } else {
      _completer.complete(await Hive.openBox(name));
    }
  }

  @override
  Future<Map<String, dynamic>> getAll() async {
    var box = await _completer.future;
    return box.toMap().map<String, dynamic>((key, value) => MapEntry<String, dynamic>(key, value));
  }

  @override
  Future<Map> getValue(String key) async {
    var box = await _completer.future;
    if (box.containsKey(key)) {
      return jsonDecode(box.get(key));
    } else {
      return null;
    }
  }

  @override
  Future put(String key, Map query) async {
    var box = await _completer.future;
    await box.put(key, jsonEncode(query));
  }

  @override
  Future<bool> remove(String key) async {
    var box = await _completer.future;
    try {
      await box.delete(key);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future clear() async {
    try {
      var box = await _completer.future;
      await box.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future close() async {}
}
