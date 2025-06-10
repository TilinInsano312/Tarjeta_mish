import 'package:frontend/src/domain/appConfig.dart';
import 'package:frontend/src/domain/repository/baseRepository.dart';
import 'package:frontend/src/domain/models/movement.dart';
import 'dart:convert';

class MovementRepository extends BaseRepository {
  
  MovementRepository({
    required String baseUrl,
  }) : super(baseUrl: baseUrl);

  Future<List<Movement>> getMovements() async {
    try {

      final response = await authenticatedGet(AppConfig.transactionEndpoint);
      
      switch (response.statusCode) {
        case 200:
          final List<dynamic> jsonList = jsonDecode(response.body);
          return jsonList.map((json) => Movement.fromJson(json)).toList();
        case 400:
          throw Exception('Bad request error');
        case 401:
          throw Exception('Unauthorized');
        case 500:
          throw Exception('Internal server error');
        default:
          throw Exception('Unknown error');
      }
    } catch (e) {
      throw Exception('Error fetching movements: $e');
    }
  }

} 