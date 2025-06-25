import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/src/domain/appConfig.dart';

class RegisterService {
  final String baseUrl;
  
  RegisterService({required this.baseUrl});

  String _cleanRut(String rut) {
    return rut.replaceAll('.', '').replaceAll(' ', '').replaceAll('-', '').toUpperCase();
  }

 
  Future<bool> register(String rut, String name, String email, String pin) async {
    try {
      final cleanRut = _cleanRut(rut);
      
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'rut': cleanRut,
          'name': name,
          'email': email,
          'pin': pin,
        }),
      ).timeout(AppConfig.timeoutDuration);

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Error en el registro');
      }
    } catch (e) {
      print('Error en RegisterService: $e');
      rethrow;
    }
  }
}
