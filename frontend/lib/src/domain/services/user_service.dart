import 'dart:convert';
import 'package:frontend/src/domain/appConfig.dart';
import 'package:frontend/src/domain/models/user.dart';
import 'package:frontend/src/domain/services/base_service.dart';
import 'package:frontend/src/domain/services/auth_service.dart';

class UserService extends BaseService {
  
  UserService({
    required super.baseUrl
  });

  final AuthService _authService = AuthService();

  Future<User> getCurrentUser() async {
    try {
      // Obtener el RUT del usuario autenticado desde el storage
      final userRut = await _authService.getUserRut();
      if (userRut == null || userRut.isEmpty) {
        throw Exception('No hay usuario autenticado');
      }

      // Buscar el usuario por RUT en el backend
      final response = await authenticatedGet('${AppConfig.userEndpoint}/rut/$userRut');

      switch (response.statusCode) {
        case 200:
          final Map<String, dynamic> userJson = jsonDecode(response.body);
          return User.fromJson(userJson);
        case 401:
          throw Exception('No autorizado');
        case 404:
          throw Exception('Usuario no encontrado');
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error desconocido: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener usuario actual: $e');
    }
  }

  Future<User?> getUserById(int id) async {
    try {
      final response = await authenticatedGet('${AppConfig.userEndpoint}/$id');

      switch (response.statusCode) {
        case 200:
          final Map<String, dynamic> userJson = jsonDecode(response.body);
          return User.fromJson(userJson);
        case 401:
          throw Exception('No autorizado');
        case 404:
          return null; // Usuario no encontrado
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error desconocido: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener usuario por ID: $e');
    }
  }

  Future<User?> getUserByRut(String rut) async {
    try {
      final response = await authenticatedGet('${AppConfig.userEndpoint}/rut/$rut');

      switch (response.statusCode) {
        case 200:
          final Map<String, dynamic> userJson = jsonDecode(response.body);
          return User.fromJson(userJson);
        case 401:
          throw Exception('No autorizado');
        case 404:
          return null; // Usuario no encontrado
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error desconocido: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener usuario por RUT: $e');
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final response = await authenticatedGet(AppConfig.userEndpoint);

      switch (response.statusCode) {
        case 200:
          final List<dynamic> jsonList = jsonDecode(response.body);
          return jsonList.map((json) => User.fromJson(json)).toList();
        case 401:
          throw Exception('No autorizado');
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error desconocido: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener lista de usuarios: $e');
    }
  }

  Future<int> createUser(User user) async {
    try {
      final response = await authenticatedPost(
        AppConfig.userEndpoint,
        jsonEncode(user.toJson()),
      );

      switch (response.statusCode) {
        case 200:
        case 201:
          // Backend retorna el ID del usuario creado
          return int.parse(response.body.trim());
        case 400:
          throw Exception('Datos de usuario inválidos');
        case 401:
          throw Exception('No autorizado');
        case 409:
          throw Exception('Usuario ya existe');
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error al crear usuario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }

  Future<void> deleteUser(String rut) async {
    try {
      final response = await authenticatedDelete('${AppConfig.userEndpoint}/$rut');

      switch (response.statusCode) {
        case 200:
        case 204:
          // Usuario eliminado exitosamente
          break;
        case 401:
          throw Exception('No autorizado');
        case 404:
          throw Exception('Usuario no encontrado');
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error al eliminar usuario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }
}
