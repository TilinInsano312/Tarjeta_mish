import 'package:frontend/src/domain/appConfig.dart';
import 'package:frontend/src/domain/services/base_service.dart';
import 'package:frontend/src/domain/models/Account.dart';
import 'dart:convert';

class AccountService extends BaseService{
  
  AccountService({
    required String baseUrl,
  }) : super(baseUrl: baseUrl);

  Future<Account> getAccount() async {
    try{

      final response = await authenticatedGet('${AppConfig.accountEndpoint}/2');
        
      switch (response.statusCode) {
      case 200:
        return Account.fromJson(jsonDecode(response.body));
      case 400:
        throw Exception('Rut o pin incorrectos');
      case 401:
        throw Exception('Credenciales invalidas');
      case 500:
        throw Exception('Error de servidor');
      default:
        throw Exception('Error de conexion');
    }
    } catch(e){
      throw Exception('Error al obtener la cuenta: $e');
    }

  }

}