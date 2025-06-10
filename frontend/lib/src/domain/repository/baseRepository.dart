import 'package:frontend/src/core/services/authService.dart';
import 'package:http/http.dart' as http;

abstract class BaseRepository{

  final String baseUrl;
  final AuthService _authService = AuthService();

  BaseRepository({
    required this.baseUrl,
  });

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token de autenticación no encontrado');
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization' : 'Bearer $token',
    };
  }

  Future<http.Response>  authenticatedGet(String endpoint) async {
    final headers = await getAuthHeaders();

    final String url;
    if (endpoint.startsWith('http')) {
      // Si endpoint es una URL completa
      url = endpoint;
    } else {
      // Si endpoint es un path relativo
      String path = endpoint;
      if (endpoint.startsWith('/') && baseUrl.endsWith('/')) {
        path = endpoint.substring(1);
      } else if (!endpoint.startsWith('/') && !baseUrl.endsWith('/')) {
        path = '/$endpoint';
      }
      url = baseUrl + path;
    }

    final uri = Uri.parse(url);
    return await http.get(uri, headers: headers);
  }

  Future<http.Response> authenticatedPost(String endpoint, dynamic body) async {
    final headers = await getAuthHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');

    return await http.post(uri, headers: headers, body: body);
  }

  Future<http.Response> authenticatedPut(String endpoint, dynamic body) async {
    final headers = await getAuthHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');

    return await http.put(uri, headers: headers, body: body);
  }

  Future<http.Response> authenticatedDelete(String endpoint) async {
    final headers = await getAuthHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');

    return await http.delete(uri, headers: headers);
  }

}