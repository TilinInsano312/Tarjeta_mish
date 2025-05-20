import 'dart:convert';
import 'package:frontend/src/domain/models/login.dart';
import 'package:http/http.dart' as http;

class Loginrepository {

  final String baseUrl;

  Loginrepository({required this.baseUrl});

  Future<LoginResponse> login (String rut, String pin) async {
    
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'rut': rut,
        'pin': pin,
      }),
    );

    if (response.statusCode == 200){
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al iniciar sesión');
    }

  }

}