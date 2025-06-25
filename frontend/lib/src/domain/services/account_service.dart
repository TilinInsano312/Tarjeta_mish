import 'package:frontend/src/domain/appConfig.dart';
import 'package:frontend/src/domain/services/base_service.dart';
import 'package:frontend/src/domain/services/user_service.dart';
import 'package:frontend/src/domain/models/Account.dart';
import 'dart:convert';

class AccountService extends BaseService{
  
  AccountService({
    required String baseUrl,
  }) : super(baseUrl: baseUrl);

  Future<Account> getAccount() async {
    try{
      // Obtener el usuario autenticado para luego buscar su cuenta
      final userService = UserService(baseUrl: baseUrl);
      final currentUser = await userService.getCurrentUser();
      
      // Por ahora usamos el ID del usuario + 1 para simular la relación con la cuenta
      // En una implementación real, necesitarías un endpoint específico para obtener
      // la cuenta por ID de usuario
      final accountId = currentUser.id;

      final response = await authenticatedGet('${AppConfig.accountEndpoint}/$accountId');
        
      switch (response.statusCode) {
      case 200:
        return Account.fromJson(jsonDecode(response.body));
      case 400:
        throw Exception('Error de solicitud');
      case 401:
        throw Exception('No autorizado');
      case 404:
        throw Exception('Cuenta no encontrada');
      case 500:
        throw Exception('Error de servidor');
      default:
        throw Exception('Error de conexión');
    }
    } catch(e){
      throw Exception('Error al obtener la cuenta: $e');
    }

  }

}