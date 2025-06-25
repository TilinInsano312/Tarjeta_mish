import 'package:frontend/src/domain/appConfig.dart';
import 'package:frontend/src/domain/models/card.dart' as domain_card;
import 'package:frontend/src/domain/services/base_service.dart';
import 'package:frontend/src/domain/services/user_service.dart';
import 'dart:convert';

class CardService extends BaseService {
  
  CardService({
    required String baseUrl,
  }) : super(baseUrl: baseUrl);

  Future<domain_card.Card> getCard() async {
    try {
      // Obtener el usuario autenticado para luego buscar su tarjeta
      final userService = UserService(baseUrl: baseUrl);
      final currentUser = await userService.getCurrentUser();
      
      // Por ahora usamos el ID del usuario para simular la relación con la tarjeta
      // En una implementación real, necesitarías un endpoint específico para obtener
      // la tarjeta por ID de usuario
      final cardId = currentUser.id;
      
      final response = await authenticatedGet('${AppConfig.cardEndpoint}/$cardId');
      
      switch (response.statusCode) {
        case 200:
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          return domain_card.Card.fromJson(jsonResponse);
        case 400:
          throw Exception('Error de solicitud incorrecta');
        case 401:
          throw Exception('No autorizado');
        case 404:
          throw Exception('Tarjeta no encontrada');
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error desconocido');
      }
    } catch (e) {
      throw Exception('Error al obtener la tarjeta: $e');
    }
  }
  
}