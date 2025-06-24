import 'dart:convert';
import 'package:frontend/src/domain/appConfig.dart';
import 'package:frontend/src/domain/models/contact.dart';
import 'package:frontend/src/domain/services/base_service.dart';


class ContactService extends BaseService {
  
  ContactService({
    required super.baseUrl
  });


  Future<List<Contact>> getContacts() async {
    try{
      final response = await authenticatedGet(AppConfig.contactEndpoint);

      switch (response.statusCode){
        case 200:
          final List<dynamic> jsonList = jsonDecode(response.body);
          return jsonList.map((json) => Contact.fromJson(json)).toList();
        case 400:
          throw Exception('Error de solicitud');
        case 401:
          throw Exception('No autorizado');
        case 404:
          throw Exception('Contactios no encontrados');
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error desconocido: ${response.statusCode}');
      }
    }catch (e){
      throw Exception('Error al obtener los contactos: $e');
    }
  }

  Future<Contact> getContactByAlias(String alias) async {
    try {
      final response = await authenticatedGet('${AppConfig.contactEndpoint}/alias/$alias');
      
      switch (response.statusCode) {
        case 200:
          return Contact.fromJson(jsonDecode(response.body));
        case 404:
          throw Exception('Contacto no encontrado');
        default:
          throw Exception('Error al buscar contacto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al buscar contacto: $e');
    }
  }

  Future<Contact> createContact(Contact contact) async {
    try {
      final response = await authenticatedPost(
        AppConfig.contactEndpoint,
        jsonEncode(contact.toJson()),
      );
      
      switch (response.statusCode) {
        case 200:
        case 201:
          return Contact.fromJson(jsonDecode(response.body));
        case 400:
          throw Exception('Datos de contacto inválidos');
        case 401:
          throw Exception('No autorizado');
        default:
          throw Exception('Error al crear contacto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear contacto: $e');
    }
  }

}