// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert'; // For JSON encoding/decoding

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
// import 'package:appwrite/models.dart';

import '../data/store.dart'; // Import the Appwrite package

class AuthManager {
  final Client
      _client; // Make _client final and initialize it in the constructor
  Session? _session; // Make _session nullable

  AuthManager()
      : _client = Client()
            .setEndpoint(
                'http://localhost/v1') // Replace with your server endpoint
            .setProject('your_project_id'); // Replace with your project ID

  Future<void> login(String email, String password) async {
    try {
      final account = Account(_client);

      // Create a session using email and password
      final result = await account.createEmailSession(
        email: email,
        password: password,
      );

      if (result != null) {
        _session = result; // Assuming result contains session data directly
        Store.set("session", json.encode(result.toMap()));

        print('Logged in successfully!');
      } else {
        print('Login failed');
        _session = null;
      }
    } catch (e) {
      print("Login error: $e");
      _session = null;
    }
  }
}
