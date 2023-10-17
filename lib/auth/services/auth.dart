import 'package:social_network_utilities/utilities/utilities.dart';

import '../models/auth_cred.dart';

abstract class AuthService {
  String get loginUrl;
  String get registerUrl;
  String get passwordResetUrl;

  StorageService get storage;
  String get storageKey;

  APIService get apiService;

  AuthCredentials? _credentials;

  bool get isLogedIn => _credentials != null;

  Future<AuthCredentials?> get credentials async {
    if (_credentials != null) {
      return _credentials;
    }
    final stored = await storage.getItem(storageKey);
    if (stored == null) return null;
    try {
      _credentials = AuthCredentials.fromJson(stored);
    } catch (e) {
      print(e);
    }
    return _credentials;
  }

  Future<void> setCredentials(AuthCredentials? credentials) async {
    print("setting credentials: ${credentials?.toJson()}");
    if (credentials == null) {
      clear();
      return;
    }

    await storage.setItem(storageKey, credentials.toJson());
    _credentials = credentials;
    print("seted credentials: ${_credentials?.toJson()}");
  }

  Future<String?> get access async => (await credentials)?.accessToken;

  Future<String?> get refresh async => (await credentials)?.refreshToken;

  Future<bool?> login({required AuthFields fields}) async {
    final result = await apiService.actionAndGetResponseItems(
        url: loginUrl,
        authService: this,
        body: fields.toJson(),
        action: APIAction.post /* ,
        headers: Hidden_Form_Headers */
        );

    print("login result: $result");
    if (result == null || result['access_token'] == null) return false;

    try {
      setCredentials(AuthCredentials.fromJson(result));
      return true;
    } catch (e) {
      print("login error: $e");
      return null;
    }
  }

  Future<bool?> register({required AuthFields fields}) async {
    final result = await apiService.actionAndGetResponseItems(
        authService: this,
        url: registerUrl,
        body: fields.toJson(),
        action: APIAction.post);

    if (result == null) return false;

    return result['access_token'] != null;
  }

  Future<bool?> resetPassword({required AuthFields fields}) async {
    final result = await apiService.actionAndGetResponseItems(
        authService: this,
        url: passwordResetUrl + fields.email!,
        body: fields.toJson(),
        action: APIAction.post);

    return result != null;
  }

  void clear() async => storage.deleteItem(storageKey);
}
