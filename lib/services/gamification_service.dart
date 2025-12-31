import 'package:dio/dio.dart';
import 'enhanced_dio_service_v2.dart';
import '../models/gamification_models.dart';

class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  final EnhancedDioServiceV2 _dioService = EnhancedDioServiceV2.instance;

  Future<GamificationProfile?> getMyProfile() async {
    try {
      await _dioService.ensureInitialized();
      final response = await _dioService.dio.get('/gamification/profile');
      if (response.statusCode == 200 && response.data != null) {
        return GamificationProfile.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching gamification profile: $e');
      return null;
    }
  }

  Future<List<GamificationProfile>> getLeaderboard({int limit = 10}) async {
    try {
      await _dioService.ensureInitialized();
      final response = await _dioService.dio.get(
        '/gamification/leaderboard',
        queryParameters: {'limit': limit},
      );
      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List)
            .map((e) => GamificationProfile.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }
}
