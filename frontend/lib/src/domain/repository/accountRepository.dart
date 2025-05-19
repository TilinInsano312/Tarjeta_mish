import 'package:http/http.dart' as http;
import 'package:frontend/src/domain/models/Account.dart';
import 'dart:convert';

class AccountRepository {
  final String baseUrl;
  final String token;

  AccountRepository({
    required this.baseUrl,
    required this.token
  });

  Future<Account> fetchBalance() async {
    final response = await http.get(
      Uri.parse('$baseUrl/balance'),
      headers: {'Authorization' : 'Bearer $token'},
    );

    if(response.statusCode == 200) {
      return Account.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener informacion de la cuenta');
    }
  }
}