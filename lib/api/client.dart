import 'package:appwrite/appwrite.dart';

class ApiClient {
  Client get _client {
    Client client = Client();

    client.setEndpoint('http://localhost/v1').setProject('funfeast');
    // .setSelfSigned(status: true);

    return client;
  }

  Account get account => Account(_client);
  Databases get database => Databases(_client);
  Storage get storage => Storage(_client);

  static final ApiClient _instance = ApiClient._internal();
  ApiClient._internal();
  factory ApiClient() => _instance;
}
