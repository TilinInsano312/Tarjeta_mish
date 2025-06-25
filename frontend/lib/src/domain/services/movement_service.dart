import 'package:frontend/src/domain/appConfig.dart';
import 'package:frontend/src/domain/services/base_service.dart';
import 'package:frontend/src/domain/services/user_service.dart';
import 'package:frontend/src/domain/models/movement.dart';
import 'dart:convert';

class MovementService extends BaseService{
  
  MovementService({
    required String baseUrl,
  }) : super(baseUrl: baseUrl);

  Future<List<Movement>> getMovements() async {
    try {
      // Obtener el usuario autenticado
      final userService = UserService(baseUrl: baseUrl);
      final currentUser = await userService.getCurrentUser();
      
      // Obtener todas las transacciones
      final response = await authenticatedGet(AppConfig.transactionEndpoint);
      
      switch (response.statusCode) {
        case 200:
          final List<dynamic> jsonList = jsonDecode(response.body);
          final allMovements = jsonList.map((json) => Movement.fromJson(json)).toList();
          
          // Filtrar transacciones del usuario actual
          // Filtramos por RUT de origen o por RUT de destino del usuario
          final userMovements = allMovements.where((movement) {
            return movement.rutOrigin == currentUser.rut || 
                   movement.rutDestination == currentUser.rut;
          }).toList();
          
          return userMovements;
        case 400:
          throw Exception('Error de solicitud');
        case 401:
          throw Exception('No autorizado');
        case 404:
          throw Exception('Transacciones no encontradas');
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error desconocido');
      }
    } catch (e) {
      throw Exception('Error al obtener movimientos: $e');
    }
  }

} 