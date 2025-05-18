import 'package:frontend/src/domain/models/card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CardRepository {
  final String baseUrl;
  final String token;

  CardRepository({
    required this.baseUrl,
    required this.token
  });

  Future<Card> fetchCardInfo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/balance'),
      headers: {'Authorization' : 'Bearer $token'},
    );

    if(response.statusCode == 200) {
      return Card.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener informacion de la tarjeta');
    }
  }
}