import 'dart:convert';
import 'package:frontend/src/domain/models/login.dart';
import 'package:http/http.dart' as http;

class LoginService {

  final String baseUrl;

  LoginService({required this.baseUrl});

  Future<LoginResponse> login (String rut, int pin) async {
   try{
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'rut': rut,
          'pin': pin,
        }),
    ).timeout(const Duration(seconds: 10));

    switch (response.statusCode) {
      case 200:
        return LoginResponse.fromJson(jsonDecode(response.body));
        
      case 400:
        throw Exception('Rut o pin incorrectos');
      case 401:
        throw Exception('Credenciales invalidas');
      case 500:
        throw Exception('Error de servidor');
      default:
        throw Exception('Error de conexion');
    }
   } catch (e) {
     if (e.toString().contains('SocketException')) {
       throw Exception('Error de conexion');
     } else if (e.toString().contains('TimeoutException')) {
       throw Exception('Tiempo de espera agotado');
     } else {
       rethrow;
     }
   }

  

  }

}