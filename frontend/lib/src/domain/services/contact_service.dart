import 'dart:convert';
import 'package:frontend/src/domain/appConfig.dart';
import 'package:frontend/src/domain/models/contact.dart';
import 'package:frontend/src/domain/services/base_service.dart';
import 'package:frontend/src/domain/services/user_service.dart';


class ContactService extends BaseService {
  
  ContactService({
    required super.baseUrl
  });


  Future<List<Contact>> getContacts() async {
    try {
      // Obtener el ID del usuario autenticado
      final userService = UserService(baseUrl: baseUrl);
      final currentUser = await userService.getCurrentUser();
      
      // Usar el endpoint específico que filtra por usuario
      final response = await authenticatedGet('${AppConfig.contactEndpoint}/user/${currentUser.id}');

      switch (response.statusCode){
        case 200:
          final List<dynamic> jsonList = jsonDecode(response.body);
          return jsonList.map((json) {
            try {
              return Contact.fromJson(json);
            } catch (e) {
              print('Error parsing contact JSON: $e, JSON: $json');
              rethrow;
            }
          }).toList();
        case 400:
          throw Exception('Error de solicitud');
        case 401:
          throw Exception('No autorizado');
        case 404:
          return []; // Si no hay contactos, retorna lista vacía en lugar de error
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error desconocido: ${response.statusCode}');
      }
    }catch (e){
      print('Error in getContacts: $e');
      throw Exception('Error al obtener los contactos: $e');
    }
  }

  Future<bool> isAliasAvailable(String alias) async {
    try {
      final response = await authenticatedGet('${AppConfig.contactEndpoint}/alias/$alias');
      
      switch (response.statusCode) {
        case 200:
          return false; // Alias ya existe
        case 404:
          return true; // Alias disponible
        case 500:
          // En caso de error 500, asumimos que el alias está disponible
          // para que el usuario pueda continuar
          print('Error 500 al verificar alias, asumiendo disponible');
          return true;
        default:
          print('Error ${response.statusCode} al verificar alias');
          return true; // Permitir continuar en caso de error
      }
    } catch (e) {
      print('Excepción al verificar alias: $e');
      // En caso de cualquier error, permitir continuar
      return true;
    }
  }

  Future<Contact> createContact(Contact contact) async {
    try {
      print('Creating contact: ${jsonEncode(contact.toJson())}');
      
      final response = await authenticatedPost(
        AppConfig.contactEndpoint,
        jsonEncode(contact.toJson()),
      );
      
      print('CreateContact response: Status ${response.statusCode}, Body: ${response.body}');
      
      switch (response.statusCode) {
        case 200:
        case 201:
          try {
            // Backend retorna solo el ID como entero
            final contactId = int.parse(response.body.trim());
            
            // Retornar el contacto con el nuevo ID
            return Contact(
              id: contactId,
              name: contact.name,
              accountNumber: contact.accountNumber,
              email: contact.email,
              alias: contact.alias,
              rut: contact.rut,
              typeAccount: contact.typeAccount,
              bank: contact.bank,
              idUser: contact.idUser,
            );
          } catch (parseError) {
            print('Error parsing response as int: $parseError');
            // Fallback: retornar contacto sin ID
            return contact;
          }
        case 400:
          throw Exception('Datos de contacto inválidos');
        case 401:
          throw Exception('No autorizado');
        default:
          throw Exception('Error al crear contacto: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createContact: $e');
      throw Exception('Error al crear contacto: $e');
    }
  }

  // Validate contact data before sending to backend
  void _validateContactData(Contact contact) {
    if (contact.name.trim().isEmpty) {
      throw Exception('El nombre es requerido');
    }
    if (contact.email.trim().isEmpty) {
      throw Exception('El email es requerido');
    }
    if (contact.alias.trim().isEmpty) {
      throw Exception('El alias es requerido');
    }
    if (contact.accountNumber <= 0) {
      throw Exception('El número de cuenta debe ser válido');
    }
    if (contact.idUser <= 0) {
      throw Exception('ID de usuario inválido');
    }
  }

}