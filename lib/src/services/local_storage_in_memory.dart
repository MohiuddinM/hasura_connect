import 'dart:async';

import 'local_storage.dart';

class LocalStorageInMemory extends LocalStorage {
  final Map<String, Map<String, dynamic>> databases = {};
  String name;

  @override
  Future init(String name) async {
    databases[name] = {};
    this.name = name;
  }

  @override
  Future<Map<String, dynamic>> getAll() async => databases[name];

  @override
  Future<Map> getValue(String key) async {
    key = '$name.$key';
    if (databases[name].containsKey(key)) {
      return databases[name][key];
    } else {
      return null;
    }
  }

  @override
  Future put(String key, Map query) async {
    databases[name]['$name.$key'] = query;
  }

  @override
  Future<bool> remove(String key) async {
    if (databases[name].containsKey(key)) {
      databases[name].remove(key);
      return true;
    }
    return false;
  }

  @override
  Future clear() async {
    try {
      databases[name].clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future close() async {}
}
