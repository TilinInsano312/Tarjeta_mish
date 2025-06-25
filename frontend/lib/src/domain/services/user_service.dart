import 'dart:convert';
import 'package:frontend/src/domain/appConfig.dart';
import 'package:frontend/src/domain/models/user.dart';
import 'package:frontend/src/domain/services/base_service.dart';
import 'package:frontend/src/domain/services/auth_service.dart';

class UserService extends BaseService {
  
  UserService({
    required super.baseUrl
  });

  Future<User> getCurrentUser() async {
    try {
      // Obtener el RUT del usuario autenticado desde el AuthService
      final authService = AuthService();
      final userRut = await authService.getUserRut();
      
      if (userRut == null || userRut.isEmpty) {
        throw Exception('Usuario no autenticado');
      }

      final response = await authenticatedGet('${AppConfig.userEndpoint}/rut/$userRut');

      switch (response.statusCode) {
        case 200:
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          return User.fromJson(jsonResponse);
        case 400:
          throw Exception('Error de solicitud');
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
      throw Exception('Error al obtener datos del usuario: $e');
    }
  }
}
