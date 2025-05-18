import 'package:http/http.dart' as http;
import 'package:frontend/src/domain/models/movement.dart';
import 'dart:convert';

class MovementRepository {
  final String baseUrl;
  final String token;

  MovementRepository({
    required this.baseUrl,
    required this.token
  });

  Future<List<Movement>> fetchMovements() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movements'),
      headers: {'Authorization' : 'Bearer $token'},
    );

    if(response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body) as List;
      return jsonList.map((json) => Movement.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los movimientos');
    }
  }
}