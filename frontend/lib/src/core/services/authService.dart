import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/domain/repository/loginRepository.dart';
import 'package:frontend/src/domain/appConfig.dart';


class AuthService {

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );

  static const String _tokenKey = 'auth_token';
  static const String _clientRutKey = 'client_rut';

  static final AuthService _instance = AuthService._internal();
  factory AuthService() {
    return _instance;
  }
  AuthService._internal();

  Future<bool> login(String rut, int pin) async {
    try {
        final loginRepository = LoginRepository(baseUrl: AppConfig.baseUrl+'/api/auth');
      
      final loginResponse = await loginRepository.login(rut, pin);
      
        await saveToken(loginResponse.token);
        await saveUserRut(rut);
        return true;
      
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      print('Error al obtener token: $e');
      return null;
    }
  }

  Future<String?> getUserRut() async {
    try {
      return await _storage.read(key: _clientRutKey);
    } catch (e) {
      print('Error al obtener RUT: $e');
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _clientRutKey);
    } catch (e) {
      print('Error en logout: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('Error al limpiar storage: $e');
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      print('Error al guardar token: $e');
    }
  }

  Future<void> saveUserRut(String rut) async {
    try {
      await _storage.write(key: _clientRutKey, value: rut);
    } catch (e) {
      print('Error al guardar RUT: $e');
    }
  }


}

