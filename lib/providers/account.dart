import 'dart:convert';
// import 'package:api/client.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:fun_feast/api/client.dart';
import 'package:fun_feast/data/store.dart';
// import 'package:pknetflix/api/client.dart';
// import 'package:pknetflix/data/store.dart';

class AccountProvider extends ChangeNotifier {
  User? _current;
  User? get current => _current;

  Session? _session;
  Session? get session => _session;

  Future<Session?> get _cachedSession async {
    final cached = await Store.get("session");

    if (cached == null) {
      return null;
    }

    return Session.fromMap(json.decode(cached));
  }

  Future<bool> isValid() async {
    if (session == null) {
      final cached = await _cachedSession;

      if (cached == null) {
        return false;
      }

      _session = cached;
    }

    return _session != null;
  }

  Future<void> register(String email, String password, String? name) async {
    try {
      print(email);
      final apiClient = ApiClient();
      final result = await apiClient.account.create(
          userId: 'unique()', email: email, password: password, name: name);

      _current = result;

      notifyListeners();
    } catch (_e) {
      throw Exception("Failed to register");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      // print(email);

      final apiClient = ApiClient();
      // print(password);
      final result = await apiClient.account
          .createEmailSession(email: email, password: password);
      // print(result);
      _session = result;
      // print(email);
      // print(password);
      Store.set("session", json.encode(result.toMap()));

      notifyListeners();
    } catch (e) {
      print("Login error: $e");
      _session = null;
    }
  }
}
